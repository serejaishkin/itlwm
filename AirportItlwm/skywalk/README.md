# Phase 3: Skywalk Datapath Skeleton

This directory contains headers for Phase 3 (Skywalk datapath implementation).

## Files

- **ItlSkywalkPacketPool.{hpp,cpp}** — Packet pool and ring allocation
  - Pre-allocate fixed-size DMA-friendly buffers
  - Reuse descriptors across Tx/Rx cycles
  - Inspired by BCMC `AppleBCMWLANPCIeSkywalkPacketPool` pattern

- **ItlSkywalkTxQueue.{hpp,cpp}** — Skywalk → Intel Tx ring adapter
  - Dequeue packet from Skywalk submission queue
  - Map to Intel Tx descriptor(s)
  - Trigger DMA, monitor completion

- **ItlSkywalkRxQueue.{hpp,cpp}** — Intel Rx ring → Skywalk adapter
  - Allocate/bounce-buffer frame from Intel Rx ring
  - Enqueue to Skywalk completion queue
  - Release descriptor back to Intel pool

- **ItlSkywalkMemorySegment.{hpp,cpp}** — IOMapper abstraction
  - Use IOMapper if available (VT-d enabled)
  - Fall back to bounce buffer if no IOMMU
  - Hide BCMC-specific DART mapping (we're Intel)

## MVP Goals

1. Load kext on Sequoia/Tahoe (Phase 1-2 already done)
2. Scan and list networks (Phase 1 IOCTL done)
3. Associate to WPA2/WPA3 network
4. DHCP and ping through Skywalk Tx/Rx
5. Sleep/wake and reconnect

## Not Included (Post-MVP)

- AWDL/P2P queues
- HMAP power saving
- Multi-band/RSDB
- Virtual interfaces
- Ranging, NAN, 6 GHz

## Design Notes

**DO NOT copy Broadcom code:**
- BCMC handles BCM hardware (backplane, EROM, SROM, Cortex-R4)
- Intel path: iwx firmware → Tx/Rx descriptors → Skywalk bridge

**Key pattern from BCMC (reference only):**
```
Skywalk packet ring (pre-allocated, DMA-friendly)
    ↓
Submission queue (enqueue Intel packet, trigger ring)
    ↓
Completion queue (dequeue finished, call packet->complete())
```

**Intel-specific adaptation:**
- hwqueue (iwx Tx ring) = Intel descriptor array, not Apple CCPipe
- Bounce buffer only when IOMapper unavailable (BCMC always has it)
- No DART, no M2M reset, no chip reset (that's HAL's job)

## Status

- Headers: Written
- Implementation (.cpp): Stubs only, TODO markers throughout
- Integration: Pending connection to AirportItlwmV2.cpp start()

## Next Phase

After Phase 3 is outlined and stubs compile:
1. Implement packet pool alloc/free via IOSkywalkFamily APIs
2. Wire Tx: Skywalk → hwqueue descriptor fill
3. Wire Rx: hwqueue → Skywalk completion enqueue
4. Test: ping through Skywalk rings (with logging)
