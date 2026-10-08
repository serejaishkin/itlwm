//
//  ItlSkywalkRxCompletionQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkRxCompletionQueue.hpp"
#include <libkern/libkern.h>
#include <IOKit/IOLib.h>

#define super IOSkywalkPacketQueue
OSDefineMetaClassAndStructors(ItlSkywalkRxCompletionQueue, IOSkywalkPacketQueue);

bool ItlSkywalkRxCompletionQueue::init(uint32_t capacity, uint64_t featureFlags, const char *name)
{
    if (!super::init())
        return false;

    queueHead_ = 0;
    queueTail_ = 0;
    queueCapacity_ = capacity;

    IOLog("%s: RxCompletionQueue<%s> capacity %u\n", __FUNCTION__, name, capacity);

    return true;
}

void ItlSkywalkRxCompletionQueue::free()
{
    IOLog("%s: freeing RxCompletionQueue\n", __FUNCTION__);

    super::free();
}

void ItlSkywalkRxCompletionQueue::stagePacket(IO80211NetworkPacket *packet, bool a, bool b)
{
    if (!packet)
        return;

    IOLog("%s: staging Rx packet\n", __FUNCTION__);

    // TODO(phase3): закоммитить фрейм в Rx path itl_ring; ядро снимет данные
    //      через getDataVirtualAddress и вернёт буфер в пул.
}