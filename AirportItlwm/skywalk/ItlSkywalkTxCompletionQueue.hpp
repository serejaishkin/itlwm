//
//  ItlSkywalkTxCompletionQueue.hpp
//  AirportItlwm-Skywalk
//
//  Tx completion queue: ядро возвращает отправленные пакеты через stagePacket.
//  По контракту BCMC: stagePacket(AppleBCMWLANPCIeSkywalkPacket*, bool, bool).
//

#ifndef ItlSkywalkTxCompletionQueue_hpp
#define ItlSkywalkTxCompletionQueue_hpp

#include <Airport/IOSkywalkPacketQueue.h>

class ItlSkywalkTxCompletionQueue : public IOSkywalkPacketQueue {
    OSDeclareDefaultStructors(ItlSkywalkTxCompletionQueue)

private:
    uint32_t queueHead_;
    uint32_t queueTail_;
    uint32_t queueCapacity_;

public:
    bool init(uint32_t capacity, uint64_t featureFlags, const char *name);

    virtual void free() APPLE_KEXT_OVERRIDE;

    virtual void stagePacket(IO80211NetworkPacket *packet, bool a, bool b) APPLE_KEXT_OVERRIDE;
};

#endif /* ItlSkywalkTxCompletionQueue_hpp */