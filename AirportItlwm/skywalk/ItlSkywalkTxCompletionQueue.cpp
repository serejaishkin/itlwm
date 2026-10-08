//
//  ItlSkywalkTxCompletionQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkTxCompletionQueue.hpp"
#include <libkern/libkern.h>
#include <IOKit/IOLib.h>

#define super IOSkywalkPacketQueue
OSDefineMetaClassAndStructors(ItlSkywalkTxCompletionQueue, IOSkywalkPacketQueue);

bool ItlSkywalkTxCompletionQueue::init(uint32_t capacity, uint64_t featureFlags, const char *name)
{
    if (!super::init())
        return false;

    queueHead_ = 0;
    queueTail_ = 0;
    queueCapacity_ = capacity;

    IOLog("%s: TxCompletionQueue<%s> capacity %u\n", __FUNCTION__, name, capacity);

    return true;
}

void ItlSkywalkTxCompletionQueue::free()
{
    IOLog("%s: freeing TxCompletionQueue\n", __FUNCTION__);

    super::free();
}

void ItlSkywalkTxCompletionQueue::stagePacket(IO80211NetworkPacket *packet, bool a, bool b)
{
    if (!packet)
        return;

    // TODO(phase3): пакет отправлен железом — вернуть буфер в пул, разбудить
    //      Tx path itl_ring. Обёртка IO80211NetworkPacket::getSkywalkPacket().
}