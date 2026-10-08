# Phase 3: Skywalk Datapath Skeleton

This directory contains the Phase 3 Skywalk datapath skeleton, refactored to the
4-queue contract recovered from AppleBCMWLANCompanion (reference only, no BCM code).

## Files

- **ItlSkywalkTxSubmissionQueue.{hpp,cpp}** — `IOSkywalkPacketQueue` subclass.
  Kernel fills Tx packet buffers; `willDequeuePackets`/`dequeuePackets` hand them
  to the Intel Tx HAL.

- **ItlSkywalkTxCompletionQueue.{hpp,cpp}** — `IOSkywalkPacketQueue` subclass.
  Kernel returns transmitted packets via `stagePacket`, frees buffer back to pool.

- **ItlSkywalkRxSubmissionQueue.{hpp,cpp}** — `IOSkywalkPacketQueue` subclass.
  Kernel fills Rx buffers; driver hands them to the Intel Rx ring for DMA.

- **ItlSkywalkRxCompletionQueue.{hpp,cpp}** — `IOSkywalkPacketQueue` subclass.
  Driver returns received frames via `stagePacket`.

- **ItlSkywalkPacketPool.{hpp,cpp}** — `IOSkywalkPacketBufferPool` subclass.
  Real Skywalk packet allocation from the pool, bounce fallback when no IOMapper.

- **ItlSkywalkMemorySegment.{hpp,cpp}** — `IOSkywalkMemorySegment` subclass.
  DMA segment wrapper; mapping on Phase 4.

## Contract (from BCMC reversal, Apple only)

- Submission side: `willDequeuePackets(IOSkywalkPacket**, uint32_t)`,
  `dequeuePackets(OSObject*, IO80211NetworkPacket**, uint32_t, void*)`
- Completion side: `stagePacket(IO80211NetworkPacket*, bool, bool)` (Rx),
  `stagePacket(IOSkywalkPacket*, bool, bool)` (Tx)
- Register 4 queues via
  `IOSkywalkEthernetInterface::registerEthernetInterface(&registInfo, queues, count,
  txPool, rxPool, capacity)` — exact order fixed on `-itlwmcontract`.

## Status

- Headers/Implementation: stubs, TODO markers throughout
- Xcode: `skywalk/*.{hpp,cpp}` added to targets AirportItlwm-Sonoma14.0 and
  AirportItlwm-Sonoma14.4
- Integration: pending connection to AirportItlwmV2.cpp start()

## Next Phase

1. Compile skeleton on MacBook
2. CONTRACT fingerprint per-OS to confirm queue/order and vtable
3. Wire Tx: Skywalk submission → hwqueue descriptor fill
4. Wire Rx: hwqueue → Skywalk completion enqueue
5. Test: ping through Skywalk rings (with logging)