//
//  ItlSkywalkPacketPool.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkPacketPool.hpp"
#include <libkern/libkern.h>

#define super IOSkywalkPacketBufferPool
OSDefineMetaClassAndStructors(ItlSkywalkPacketPool, IOSkywalkPacketBufferPool);

ItlSkywalkPacketPool *ItlSkywalkPacketPool::create(const char *name, OSObject *owner,
                                                   uint32_t capacity, uint32_t maxBuffersPerPacket,
                                                   uint32_t bufferSize)
{
    ItlSkywalkPacketPool *pool = new ItlSkywalkPacketPool;
    if (!pool)
        return nullptr;

    IOSkywalkPacketBufferPool::PoolOptions options = {};
    options.packetCount = capacity;
    options.bufferCount = capacity * maxBuffersPerPacket;
    options.bufferSize = bufferSize;
    options.maxBuffersPerPacket = maxBuffersPerPacket;
    options.memorySegmentSize = 0;
    options.poolFlags = 0;

    if (!pool->initWithName(name, owner, 0, &options)) {
        pool->release();
        return nullptr;
    }

    return pool;
}

bool ItlSkywalkPacketPool::initWithName(const char *name, OSObject *owner, uint featureFlags,
                                        IOSkywalkPacketBufferPool::PoolOptions const *options)
{
    if (!super::initWithName(name, owner, featureFlags, options))
        return false;

    if (options) {
        capacity_ = options->packetCount;
        bufferSize_ = options->bufferSize;
    }

    IOLog("%s: <%s> capacity %u bufferSize %u\n", __FUNCTION__, name, capacity_, bufferSize_);

    // TODO(phase3): после CONTRACT-фингерпринта заменить делегирование
    //      реальной реализацией IOSkywalkFamily (find/attach IOSkywalkFamily).

    return true;
}

void ItlSkywalkPacketPool::free()
{
    IOLog("%s: freeing pool\n", __FUNCTION__);

    super::free();
}

bool ItlSkywalkPacketPool::allocatePacket(IOSkywalkPacket **packet, uint size)
{
    // TODO(phase3): обёртка вокруг буферов пула + bounce при отсутствии IOMapper.
    return false;
}

void ItlSkywalkPacketPool::deallocatePacket(IOSkywalkPacket *packet)
{
    // TODO(phase3): вернуть буфер в пул.
}