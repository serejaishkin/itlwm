//
//  ItlSkywalkRxQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkRxQueue.hpp"

ItlSkywalkRxQueue::ItlSkywalkRxQueue()
{
}

ItlSkywalkRxQueue::~ItlSkywalkRxQueue()
{
    free();
}

bool ItlSkywalkRxQueue::init()
{
    // TODO: Initialize Rx queue structures
    return true;
}

void ItlSkywalkRxQueue::free()
{
    // TODO: Cleanup Rx queue
}

void ItlSkywalkRxQueue::submitFrame(void *frameBuffer, uint32_t length, uint32_t rxIndex)
{
    if (!frameBuffer || length == 0)
        return;
    
    // TODO: Check if bounce needed (no IOMapper)
    // TODO: Copy or map frame to bounce/DMA buffer
    // TODO: Create Skywalk packet from frame
    // TODO: Enqueue to Skywalk completion queue
}

void ItlSkywalkRxQueue::completeFrame()
{
    // TODO: Dequeue from Skywalk, signal completion
}
