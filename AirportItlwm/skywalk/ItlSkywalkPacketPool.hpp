//
//  ItlSkywalkPacketPool.hpp
//  AirportItlwm-Skywalk
//
//  Пул пакетов Skywalk: субкласс IOSkywalkPacketBufferPool, чтобы ядро
//  выделяло/возвращало настоящие IOSkywalkPacket в нашем пуле.
//

#ifndef ItlSkywalkPacketPool_hpp
#define ItlSkywalkPacketPool_hpp

#include <Airport/IOSkywalkPacketBufferPool.h>

class ItlSkywalkPacketPool : public IOSkywalkPacketBufferPool {
    OSDeclareDefaultStructors(ItlSkywalkPacketPool)

private:
    uint32_t capacity_;
    uint32_t bufferSize_;

public:
    static ItlSkywalkPacketPool *create(const char *name, OSObject *owner,
                                        uint32_t capacity, uint32_t maxBuffersPerPacket,
                                        uint32_t bufferSize);

    virtual bool initWithName(const char *name, OSObject *owner, uint featureFlags,
                              IOSkywalkPacketBufferPool::PoolOptions const *options) APPLE_KEXT_OVERRIDE;

    virtual void free() APPLE_KEXT_OVERRIDE;

    virtual bool allocatePacket(IOSkywalkPacket **packet, uint size) APPLE_KEXT_OVERRIDE;
    virtual void deallocatePacket(IOSkywalkPacket *packet) APPLE_KEXT_OVERRIDE;

    uint32_t getCapacity() const { return capacity_; }
    uint32_t getBufferSize() const { return bufferSize_; }
};

#endif /* ItlSkywalkPacketPool_hpp */