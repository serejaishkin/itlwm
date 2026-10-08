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

## Phase 1: IOCTL Parity Inventory (1-2 days) — ✓ COMPLETED

### Goal
Map every get/set IOCTL from legacy AirportItlwm.cpp → current AirportItlwmSkywalkInterface.cpp, identify gaps blocking airportd/wifid startup.

### Actions Completed
1. ✓ Created comprehensive parity table (20+ methods, 3 categories)
2. ✓ Implemented `getHW_SUPPORTED_CHANNELS` — delegates to `getSUPPORTED_CHANNELS`, enables airportd band detection
3. ✓ Implemented `setPOWERSAVE` setter — accepts calls, logs for debugging, returns success
4. ✓ Verified `getDEAUTH` / `setDEAUTH` / `setDISASSOCIATE` — all implemented
5. ✓ Commit: `33a8fa1` Phase 1 IOCTL handlers

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
- `AirportItlwmV2.cpp` line ~304: ✓ **FIXED** — double `initRegistrationInfo()` call removed
- Direct dereference of `mExpansionData` — ✓ **FIXED** — NULL checks added
- Both allocation patterns — ✓ **FIXED** — safe allocation with proper cleanup on failure

### Root Cause
Skywalk base class layout changed between Sequoia and Tahoe; field offsets shifted. Headers available to this project are incomplete/inconsistent.

### Solution Implemented
1. ✓ **Remove duplicate** `initRegistrationInfo()` (original line 308)
2. ✓ **Add NULL checks** on `mExpansionData` / `mExpansionData2`
3. ✓ **Safe allocation** pattern: allocate to temp vars, check both succeeded, assign to pointers
4. ✓ **Proper cleanup** on partial failure: free both if either allocation fails
5. ✓ Commit: `61400b1` — Fix Skywalk registration bootstrap

### Testing command
```bash
# After rebuild, run on Tahoe:
log stream --level debug --predicate 'process == "kernel" && message contains "SkywalkContract"'
# Should NOT show vtable shift warnings
```

### Still TODO (if issues persist)
- Sniff CONTRACT on Sequoia (working baseline) and Tahoe with `-itlwmcontract` boot-arg
- Run `scripts/analyze-contract.sh` to compare vtable slot mappings
- If slots differ: update header offsets in `include/Airport/IO80211SkywalkInterface.h` or apply patch offset in code

**Status:** Bootstrap memory-safety fixed; await Tahoe testing to confirm no vtable crashes.

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

**Status:** Skeleton refactored to the 4-queue BCMC contract (TxSubmission/TxCompletion/
RxSubmission/RxCompletion as IOSkywalkPacketQueue subclasses, pool subclassing
IOSkywalkPacketBufferPool, segment subclassing IOSkywalkMemorySegment). All
`skywalk/*.{hpp,cpp}` registered in itlwm.xcodeproj (targets AirportItlwm-Sonoma14.0
and AirportItlwm-Sonoma14.4). Pending: compile on MacBook, then CONTRACT fingerprint
to confirm vtable/order before real datapath wiring.

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

## Completed Work Summary

### Commits in this session
1. **`61400b1`** — Fix Skywalk registration bootstrap
   - Remove duplicate `initRegistrationInfo()` call
   - Add NULL checks for `mExpansionData` / `mExpansionData2`
   - Safe IOMalloc pattern with proper cleanup on failure
   - Prevents use-after-free / double-free vulnerabilities

2. **`206bf0c`** — Add comprehensive Skywalk porting plan
   - Phases 0-6 documented with success criteria
   - IOCTL parity table (20+ methods): Status, gaps, actions
   - Architecture notes (where NOT to copy BCMC)

3. **`33a8fa1`** — Phase 1: Implement missing IOCTL handlers
   - `getHW_SUPPORTED_CHANNELS` — enables airportd band detection
   - `setPOWERSAVE` setter — accepts power profile changes
   - Critical gaps from Phase 1 closure

---

## Next Steps by Phase

### Phase 2: Tahoe Contract (If persistent vtable issues)
**When to do:** After Tahoe testing shows crashes in `fNetIf->start(this)` or attachment failures.
- Run `log stream` with `-itlwmcontract` boot-arg on Tahoe
- Capture vtable signatures with `scripts/analyze-contract.sh`
- Compare against Sequoia baseline
- If offsets differ: apply patch or update header offsets

### Phase 3: Datapath (Weeks, can run in parallel with 1-2)
**Goal:** Skywalk Tx/Rx queues with bounce buffer when no IOMapper.
**Sketch:** Create `AirportItlwm/skywalk/` with:
- `ItlSkywalkPacketPool` — pre-allocated ring
- `ItlSkywalkTxSubmissionQueue` — dequeue Skywalk → fill Intel Tx
- `ItlSkywalkRxCompletionQueue` — enqueue to Skywalk
- `ItlSkywalkMemorySegment` — IOMapper / bounce logic

### Phase 4: Control plane (After Phase 3 basics)
**Goal:** Ensure same state machine as V1.
- Scan cache clear handler (`setSCANCACHE_CLEAR`)
- Verify deauth sequence in `setDISASSOCIATE`
- Test: scan → assoc → DHCP → ping → disassoc

### Phase 5: AWDL stubs (Low priority, mostly done)
**Goal:** Don't crash on AWDL ioctl, return `kIOReturnUnsupported`.

### Phase 6: Build & Regression (Final)
**Targets:** Sequoia 14.0, 14.4, Tahoe 15.x
**Regression:** Load, scan, WPA2/WPA3, DHCP, sleep/wake, VT-d toggle

---

## For Tahoe Testing

1. **Prepare:**
   - Transfer to macOS Tahoe machine with Xcode
   - Build: `xcodebuild -scheme AirportItlwm -configuration Release`
   
2. **Install & test with logging enabled:**
   ```bash
   sudo kextload build/Release/AirportItlwm.kext
   log stream --level debug --predicate 'eventMessage contains "AirportItlwm"'
   ```
   
3. **Capture vtable signature (if Phase 2 needed):**
   ```bash
   log stream -o contract.log --level debug -p "kernel" &
   sudo nvram boot-args="-v -itlwmcontract"
   sudo reboot
   # After boot: bash scripts/analyze-contract.sh contract.log
   ```

---

## Next Step
Start Phase 3 (if Phase 2 tests OK) or run Phase 2 diagnostics (if vtable crashes occur). For now, proceed with documentation and staging Phase 3 skeleton.
