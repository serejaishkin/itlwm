# Skywalk Porting Plan for AirportItlwm

## Overview
Plan to adapt AirportItlwm from legacy iOS80211Interface to modern Skywalk stack (Sequoia 14.x / Tahoe 15.x), inspired by patterns in AppleBCMWLANCompanion reversed binary, but using Intel HAL.

## Phase 0: Reference & Non-Goals ✓

**What we DO NOT copy from BCMC:**
- `AppleBCMWLANChip*` classes, Cortex-R4 firmware, chip probe/reset logic
- EROM/SROM reads, DART memory mapping, M2M reset sequences
- Lilu/KernelPatcher interception (we're a standalone driver, not a companion)
- Broadcom-specific register layouts and offsets

**What we CAN learn from BCMC (as patterns only):**
- Skywalk registration flow (RegistrationInfo in mExpansionData)
- Packet pool / bounce buffer patterns when IOMapper unavailable
- Tx/Rx submission/completion queue model
- CCPipe logging namespace / debug hooks
- Integration with IO80211SkywalkInterface vtable

**Target parity:** Same user-facing functionality as legacy AirportItlwm (scan, associate, WPA2/WPA3, DHCP, sleep/wake), not AWDL/Continuity (those were stubs in V1 too).

---

## Phase 1: IOCTL Parity Inventory (1-2 days) — IN PROGRESS

### Goal
Map every get/set IOCTL from legacy AirportItlwm.cpp → current AirportItlwmSkywalkInterface.cpp, identify gaps blocking airportd/wifid startup.

### V1 → V2 IOCTL Mapping Table

| Category | V1 Method (AirportItlwm.cpp) | V2 Method (AirportItlwmSkywalkInterface) | Status | Notes |
|----------|-----|--------|--------|-------|
| **SSID** | `getSSID` / `getSCAN_RESULT` | `getSSID` / `getSCAN_RESULT` | ✓ Implemented | Both parse net80211 state |
| **Auth** | `getAUTH_TYPE` | `getAUTH_TYPE` | ✓ Implemented | RSN/WPA2/WPA3 supported |
| **BSSID** | `getBSSID` | `getBSSID` | ✓ Implemented | From assoc record |
| **Channel** | `getCHANNEL` | `getCHANNEL` | ✓ Implemented | Current + TX rate tracking |
| **RSSI** | `getRSSI` / `getNOISE` | `getRSSI` / `getNOISE` | ✓ Implemented | Per-frame in HAL |
| **State** | `getSTATE` | `getSTATE` | ✓ Implemented | IEEE80211_S_* states mapped |
| **Rate** | `getRATE` | `getRATE` | ✓ Implemented | From Tx descriptor |
| **Keys** | N/A `setPTK` / `setGTK` | `setPTK` / `setGTK` | ✓ Implemented | Direct CAM write |
| **Assoc** | N/A `associateSSID` | `associateSSID` | ✓ Implemented | Triggers 802.11 state machine |
| **Scan** | `getSCAN_RESULT` | `getSCAN_RESULT` | ✓ Implemented | Via net80211 scan |
| **Power Save** | `getPOWERSAVE` / `setPOWERSAVE` | `getPOWERSAVE` | ⚠ Partially | Returns PM state, no set handler |
| **TX Power** | `getTXPOWER` | `getTXPOWER` | ⚠ Partially | Returns limit, no per-rate control |
| **Locale** | `getLOCALE` | `getLOCALE` | ✓ Implemented | Regulatory domain |
| **Deauth** | N/A `setDEAUTH` | `getDEAUTH` | ⚠ Partially | Getter only, no explicit deauth cmd |
| **PHY Mode** | `getPHY_MODE` | `getPHY_MODE` | ✓ Implemented | 11a/b/g/n/ac/ax |
| **Rate Set** | `getRATE_SET` | `getRATE_SET` | ✓ Implemented | Supported rates by PHY |
| **Stats** | `getSTATS` | `getSTATS` | ✗ Unsupported | Returns error |
| **STA List** | `getSTATION_LIST` | `getSTATION_LIST` | ✗ Unsupported | Not multi-STA mode |
| **DTIM Interval** | `getDTIM_INT` | `getDTIM_INT` | ✗ Unsupported | Beacon parsing needed |
| **Capabilities** | — | `getHW_SUPPORTED_CHANNELS` | ✗ Unsupported | Should return 2.4/5/6 GHz bands |
| **Virtual IF** | `createVirtualInterface` | — | ✗ Not implemented | AWDL is stub; acceptable for MVP |
| **AWDL** | `setAWDL_ENABLED` / flags | — | ✗ Not implemented | Return `kIOReturnUnsupported` (as before) |

### Critical gaps for airportd startup
- ❌ **`getHW_SUPPORTED_CHANNELS`** — airportd may skip interface if unknown bands
  - **Action:** Implement to return 2.4/5/6 GHz capabilities via HAL
  
- ⚠ **`setPOWERSAVE` handler** — wifid may enforce power profile
  - **Action:** Add setter stub that logs call; return success
  
- ⚠ **`setDEAUTH` / deauth packet sequence** — explicit disconnect
  - **Action:** Trigger `ieee80211_crypto_delpeerkeys` + send deauth frame

### Non-critical (skip for MVP)
- Stats, STA list (not multi-STA)
- Ranging, NAN, 6 GHz WCL
- Chip diags, trap info, thermal
- Soft AP, virtual IF
- AWDL/Handoff (stubs return `kIOReturnUnsupported` as before)

---

## Phase 2: Tahoe Skywalk Contract Fix (Main Blocker)

### Goal
Fix mismatch between Sequoia and Tahoe vtable layouts for `IO80211SkywalkInterface` and related Apple base classes.

### Current Issue
- `AirportItlwmV2.cpp` line ~304: **double `initRegistrationInfo()` call**
- Direct dereference of `mExpansionData` without NULL checks
- Both allocation patterns unsafe; second call overwrites first redundantly

### Root Cause
Skywalk base class layout changed between Sequoia and Tahoe; field offsets shifted. Headers available to this project are incomplete/inconsistent.

### Solution
1. ✓ **Remove duplicate** `initRegistrationInfo()` (line 308)
2. ✓ **Add NULL checks** on `mExpansionData` / `mExpansionData2`
3. ✓ **Safe allocation** pattern: allocate to temp vars, check both succeeded, assign to pointers
4. ✓ **Proper cleanup** on partial failure: free both if either allocation fails
5. **Verify with** `-itlwmcontract` logging that vtable contract matches after fix

### Testing command
```bash
# After rebuild, run on Tahoe:
log stream --level debug --predicate 'process == "kernel" && message contains "SkywalkContract"'
# Should NOT show vtable shift warnings
```

**Status:** Implemented in commit `61400b1`.

---

## Phase 3: Datapath by BCMC Patterns (Weeks)

### Goal
Implement Skywalk Tx/Rx datapath without Broadcom-specific code.

### Pattern from BCMC (reference only)
- **Packet pool**: Allocate fixed-size ring, pre-map DMA, reuse via producer/consumer
- **Tx flow**: 
  1. Dequeue from Skywalk submission queue
  2. Map packet to Intel Tx descriptor(s)
  3. Increment ring pointer
  4. On completion: dequeue Apple completion, call `packet->complete()`
- **Rx flow**:
  1. Allocate bounce buffer if no IOMapper
  2. DMA to buffer
  3. Enqueue to Skywalk completion
  4. Host processes packet

### MVP Datapath
**Current:** `mbuf` from net80211 → BSD attach → loss in translation to Skywalk.

**Goal:** `mbuf` → `IOSkywalkPacket` wrapper → Intel Tx ring → DMA → `IOEthernetInterface` (temporary).

**Not goal:** Remove IOEthernetInterface entirely (that's post-MVP).

### Files to create
```
AirportItlwm/
  skywalk/
    ItlSkywalkPacketPool.{hpp,cpp}       Pool alloc/free, descriptor ring
    ItlSkywalkTxSubmissionQueue.{hpp,cpp} Wrap Tx path
    ItlSkywalkTxCompletionQueue.{hpp,cpp} Wrap Tx completion
    ItlSkywalkRxSubmissionQueue.{hpp,cpp} Wrap Rx alloc
    ItlSkywalkRxCompletionQueue.{hpp,cpp} Wrap Rx completion
    ItlSkywalkMemorySegment.{hpp,cpp}    IOMapper / bounce buffer
```

**Status:** Not started; blocked on Phase 2.

---

## Phase 4: Control Plane Parity (Assoc/Scan/Security)

### Goal
Ensure same state machine behavior as V1 for user-visible Wi-Fi actions.

### Current state
- Scan already working (net80211 scan → Skywalk event)
- Associate triggered by `associateSSID`, but some edge cases differ
- Key negotiation (PTK/GTK) implemented, but not all corner cases

### Gaps
- **Scan cache** not cleared on `APPLE80211_IOC_SCANCACHE_CLEAR`
- **Deauth** sequence incomplete; may not trigger `eventHandler` properly
- **Roam** candidates — net80211 tracks, but Skywalk callback not always fired
- **Virtual IF** — stub returns error (acceptable if airportd doesn't require it)

### Actions
1. Review V1 `AirportSTAIOCTL.cpp` dispatch, ensure V2 calls corresponding Skywalk methods
2. Add missing IOCTL handlers (scan cache, deauth, capabilities)
3. Test: associate → DHCP → ping → disassoc → idle

**Status:** Mostly ready; need setter stubs for `setPOWERSAVE`, deauth command.

---

## Phase 5: Continuity / AWDL (Out of scope for MVP)

### Current behavior
V1 `AirportAWDL.cpp` returns `kIOReturnUnsupported` for AWDL enables.

### Target behavior
Same — do not crash on AWDL ioctl, return unsupported gracefully.

**Status:** Acceptable, skip for MVP.

---

## Phase 6: Build & Regression (Integration)

### Targets
- **AirportItlwm-Sequoia14.0** (baseline, must compile)
- **AirportItlwm-Sequoia14.4** (existing)
- **AirportItlwm-Tahoe15.x** (new, Phase 2 dependent)

### Build command
```bash
cd ~/GitHub/itlwm
xcodebuild -scheme AirportItlwm -configuration Release -derivedDataPath build -verbose 2>&1 | tee build.log
```

### Regression tests (on target Mac)
1. Load kext, check dmesg for panics
2. Scan networks (5+ seconds)
3. Connect WPA2/WPA3
4. Ping 8.8.8.8, iperf bandwidth
5. Sleep 5s, wake, reconnect
6. Disable/enable Wi-Fi in System Preferences (10 cycles)
7. Check VT-d on/off (reboot to BIOS)

**Status:** Pending Phase 3 implementation.

---

## Implementation Order

1. ✓ **Phase 0**: Clarify non-goals
2. **→ Phase 1**: IOCTL parity table (this doc + implement missing setPOWERSAVE, capabilities, deauth)
3. **→ Phase 2**: Fix Tahoe vtable (NULL checks, safe allocation) — *critical blocker*
4. **→ Phase 3**: Skywalk datapath (months, can parallelize with 1-2)
5. **→ Phase 4**: Control plane getter/setters
6. **→ Phase 5**: AWDL stubs (already done)
7. **→ Phase 6**: Build and test

---

## Why NOT copy BCMC sources into this repo

BCMC binary reverse engineering gives us:
- ✓ **Packet queue model** (which fields, which order)
- ✓ **Skywalk registration ceremony** (when to call, error handling)
- ✓ **Logging namespace** (how Apple names components)
- ✓ **Reference for VT-d bounce patterns** (what to do when no IOMMU)

But we do NOT get:
- ✗ **Intel firmware interface** (BCMC has BCM hardware, we have iwx)
- ✗ **PCIe/reset sequences** (Broadcom backplane ≠ Intel config space)
- ✗ **Chip probe / power management** (different hardware, different init)
- ✗ **Lilu/KernelPatcher logic** (we're a driver, not a companion)

Copying `.cpp` would create dead code + name collisions. Pattern reuse = document patterns, implement new code.

---

## References

- `include/Airport/IO80211SkywalkInterface.h` — abstract base class, ~100 vtable methods
- `include/Airport/IOSkywalkEthernetInterface.h` — MAC-layer methods
- `include/Airport/IOSkywalkNetworkInterface.h` — registration struct
- `AirportItlwm/AirportItlwmSkywalkInterface.cpp` — V2 implementation (starting point)
- `AirportItlwm/AirportItlwmV2.cpp` — controller (where Skywalk attach happens)
- `AppleBCMWLANCompanion_reversed/analysis/key_functions/` — Broadcom reference (for queue patterns only)

---

## Success Criteria

- ✓ Kext loads on Sequoia 14.4 (backward compat)
- ✓ Kext loads on Tahoe 15.x (no vtable crashes)
- ✓ Scan network list appears in System Preferences within 5s
- ✓ Connect WPA2 and WPA3 networks
- ✓ DHCP works, ping 8.8.8.8 succeeds
- ✓ Sleep/wake reconnect automatically
- ✓ No panic on VT-d toggle
- ⚠ AWDL: acceptable to return `kIOReturnUnsupported` (same as V1)
- ⚠ Stats/ranging: acceptable to return `kIOReturnUnsupported` (not user-facing)

---

## Next Step
Start Phase 1: Run `grep -r "getPOWERSAVE\|getHW_SUPPORTED_CHANNELS\|setDEAUTH" AirportItlwm/*.cpp` and implement missing setters.
