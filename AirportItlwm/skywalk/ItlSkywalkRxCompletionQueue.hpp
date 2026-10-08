//
//  ItlSkywalkRxCompletionQueue.hpp
//  AirportItlwm-Skywalk
//
//  Rx completion queue: драйвер возвращает принятые фреймы через stagePacket.
//  По контракту BCMC: stagePacket(IO80211NetworkPacket*, bool, bool).
//

#ifndef ItlSkywalkRxCompletionQueue_hpp
#define ItlSkywalkRxCompletionQueue_hpp

#include <Airport/IOSkywalkPacketQueue.h>

class ItlSkywalkRxCompletionQueue : public IOSkywalkPacketQueue {
    OSDeclareDefaultStructors(ItlSkywalkRxCompletionQueue)

private:
    uint32_t queueHead_;
    uint32_t queueTail_;
    uint32_t queueCapacity_;

public:
    bool init(uint32_t capacity, uint64_t featureFlags, const char *name);

    virtual void free() APPLE_KEXT_OVERRIDE;

    virtual void stagePacket(IO80211NetworkPacket *packet, bool a, bool b) APPLE_KEXT_OVERRIDE;
};

#endif /* ItlSkywalkRxCompletionQueue_hpp */