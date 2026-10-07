//
//  ItlSkywalkPacketPool.hpp
//  AirportItlwm-Skywalk
//
//  Packet pool for Skywalk Tx/Rx rings.
//  Inspired by BCMC patterns, implemented for Intel HAL.
//

#ifndef ItlSkywalkPacketPool_hpp
#define ItlSkywalkPacketPool_hpp

#include <IOKit/IOTypes.h>
#include <Airport/IOSkywalkPacketBufferPool.h>

class ItlSkywalkPacketPool {
public:
    ItlSkywalkPacketPool();
    ~ItlSkywalkPacketPool();
    
    bool init(uint32_t capacity);
    void free();
    
    // Allocation
    IOSkywalkPacket *allocatePacket(uint32_t size);
    void freePacket(IOSkywalkPacket *pkt);
    
    // Bounce buffer (when no IOMapper)
    void *allocateBounceBuffer(uint32_t size, uint32_t &physicalAddress);
    void freeBounceBuffer(void *buffer, uint32_t size);
    
    uint32_t getCapacity() const { return capacity_; }
    uint32_t getAvailable() const;
    
private:
    uint32_t capacity_;
    IOSkywalkPacketBufferPool *bufferPool_;
    void *bounceBuffers_;
};

#endif /* ItlSkywalkPacketPool_hpp */
