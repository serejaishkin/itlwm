//
//  ItlSkywalkRxSubmissionQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkRxSubmissionQueue.hpp"
#include <libkern/libkern.h>
#include <IOKit/IOLib.h>

#define super IOSkywalkPacketQueue
OSDefineMetaClassAndStructors(ItlSkywalkRxSubmissionQueue, IOSkywalkPacketQueue);

bool ItlSkywalkRxSubmissionQueue::init(uint32_t capacity, uint64_t featureFlags, const char *name)
{
    if (!super::init())
        return false;

    queueHead_ = 0;
    queueTail_ = 0;
    queueCapacity_ = capacity;

    IOLog("%s: RxSubmissionQueue<%s> capacity %u\n", __FUNCTION__, name, capacity);

    return true;
}

void ItlSkywalkRxSubmissionQueue::free()
{
    IOLog("%s: freeing RxSubmissionQueue\n", __FUNCTION__);

    super::free();
}

void ItlSkywalkRxSubmissionQueue::willDequeuePackets(IOSkywalkPacket **buffer, uint32_t count)
{
    // TODO(phase3): ядро наполняет буферы; драйвер помечает их пустыми
    //      для RxSubmission и передаёт в Rx ring for DMA.
}

void ItlSkywalkRxSubmissionQueue::dequeuePackets(OSObject *queueInfo, IO80211NetworkPacket **packets, uint32_t count, void *reserved)
{
    // TODO(phase3): заполнить пакеты из Intel Rx ring после DMA и
    //      застейджить в Rx completion queue.
}