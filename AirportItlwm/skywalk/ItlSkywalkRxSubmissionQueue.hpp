//
//  ItlSkywalkRxSubmissionQueue.hpp
//  AirportItlwm-Skywalk
//
//  Rx submission queue: ядро наполняет буферы для приёма фреймов.
//  Драйвер отдаёт их Intel Rx ring и возвращает заполненные.
//

#ifndef ItlSkywalkRxSubmissionQueue_hpp
#define ItlSkywalkRxSubmissionQueue_hpp

#include <Airport/IOSkywalkPacketQueue.h>

class ItlSkywalkRxSubmissionQueue : public IOSkywalkPacketQueue {
    OSDeclareDefaultStructors(ItlSkywalkRxSubmissionQueue)

private:
    uint32_t queueHead_;
    uint32_t queueTail_;
    uint32_t queueCapacity_;

public:
    bool init(uint32_t capacity, uint64_t featureFlags, const char *name);

    virtual void free() APPLE_KEXT_OVERRIDE;

    virtual void willDequeuePackets(IOSkywalkPacket **buffer, uint32_t count) APPLE_KEXT_OVERRIDE;
    virtual void dequeuePackets(OSObject *queueInfo, IO80211NetworkPacket **packets, uint32_t count, void *reserved) APPLE_KEXT_OVERRIDE;
};

#endif /* ItlSkywalkRxSubmissionQueue_hpp */