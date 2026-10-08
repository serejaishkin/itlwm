//
//  ItlSkywalkTxSubmissionQueue.hpp
//  AirportItlwm-Skywalk
//
//  Tx submission queue: ядро наполняет пакетами для отправки и вызывает
//  willDequeuePackets/dequeuePackets. Мост в Intel Tx ring HAL.
//  Сигнатуры по контракту из реверса AppleBCMWLANCompanion.
//

#ifndef ItlSkywalkTxSubmissionQueue_hpp
#define ItlSkywalkTxSubmissionQueue_hpp

#include <Airport/IOSkywalkPacketQueue.h>

class ItlSkywalkTxSubmissionQueue : public IOSkywalkPacketQueue {
    OSDeclareDefaultStructors(ItlSkywalkTxSubmissionQueue)

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

#endif /* ItlSkywalkTxSubmissionQueue_hpp */