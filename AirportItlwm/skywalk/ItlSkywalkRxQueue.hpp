//
//  ItlSkywalkRxQueue.hpp
//  AirportItlwm-Skywalk
//
//  Rx queue adapter: bridge from Intel Rx ring to Skywalk completion.
//

#ifndef ItlSkywalkRxQueue_hpp
#define ItlSkywalkRxQueue_hpp

#include <IOKit/IOTypes.h>

class ItlSkywalkRxQueue {
public:
    ItlSkywalkRxQueue();
    ~ItlSkywalkRxQueue();
    
    bool init();
    void free();
    
    // Called when Intel Rx ring has a frame
    void submitFrame(void *frameBuffer, uint32_t length, uint32_t rxIndex);
    
    // Enqueue frame to Skywalk completion queue
    void completeFrame();
    
private:
};

#endif /* ItlSkywalkRxQueue_hpp */
