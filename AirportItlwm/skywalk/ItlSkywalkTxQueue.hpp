//
//  ItlSkywalkTxQueue.hpp
//  AirportItlwm-Skywalk
//
//  Tx queue adapter: bridge from Skywalk submission to Intel Tx ring.
//

#ifndef ItlSkywalkTxQueue_hpp
#define ItlSkywalkTxQueue_hpp

#include <IOKit/IOTypes.h>

class ItlSkywalkTxQueue {
public:
    ItlSkywalkTxQueue();
    ~ItlSkywalkTxQueue();
    
    bool init();
    void free();
    
    // Called when Skywalk has a packet to send
    void submitPacket(void *packet);
    
    // Called when Intel Tx ring completes a descriptor
    void completePacket(uint32_t txIndex);
    
private:
};

#endif /* ItlSkywalkTxQueue_hpp */
