//
//  ItlSkywalkTxSubmissionQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkTxSubmissionQueue.hpp"
#include <libkern/libkern.h>

#define super IOSkywalkPacketQueue
OSDefineMetaClassAndStructors(ItlSkywalkTxSubmissionQueue, IOSkywalkPacketQueue);

bool ItlSkywalkTxSubmissionQueue::init(uint32_t capacity, uint64_t featureFlags, const char *name)
{
    if (!super::init())
        return false;

    queueHead_ = 0;
    queueTail_ = 0;
    queueCapacity_ = capacity;

    IOLog("%s: TxSubmissionQueue<%s> capacity %u\n", __FUNCTION__, name, capacity);

    return true;
}

void ItlSkywalkTxSubmissionQueue::free()
{
    IOLog("%s: freeing TxSubmissionQueue\n", __FUNCTION__);

    super::free();
}

void ItlSkywalkTxSubmissionQueue::willDequeuePackets(IOSkywalkPacket **buffer, uint32_t count)
{
    IOLog("%s: count %u\n", __FUNCTION__, count);

    // TODO(phase3): раздать буферы из пула, затем передать пакеты в Intel Tx HAL.
    // TODO(phase3): в буферы попадают IOSkywalkPacket, флаг полезного груза —
    //      IOSkywalkPacketDirection::TxSubmission.
}

void ItlSkywalkTxSubmissionQueue::dequeuePackets(OSObject *queueInfo, IO80211NetworkPacket **packets, uint32_t count, void *reserved)
{
    IOLog("%s: count %u\n", __FUNCTION__, count);

    // TODO(phase3): забрать IOSkywalkPacket из packets[], пометить как
    //      TxSubmission и передать в itl_ring.c Tx path.
}