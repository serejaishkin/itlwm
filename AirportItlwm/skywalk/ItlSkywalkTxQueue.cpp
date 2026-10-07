//
//  ItlSkywalkTxQueue.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkTxQueue.hpp"

ItlSkywalkTxQueue::ItlSkywalkTxQueue()
{
}

ItlSkywalkTxQueue::~ItlSkywalkTxQueue()
{
    free();
}

bool ItlSkywalkTxQueue::init()
{
    // TODO: Initialize Tx queue structures
    return true;
}

void ItlSkywalkTxQueue::free()
{
    // TODO: Cleanup Tx queue
}

void ItlSkywalkTxQueue::submitPacket(void *packet)
{
    if (!packet)
        return;
    
    // TODO: Extract packet data
    // TODO: Fill Intel Tx descriptor
    // TODO: Increment ring pointer
    // TODO: Trigger DMA via register write
}

void ItlSkywalkTxQueue::completePacket(uint32_t txIndex)
{
    // TODO: Dequeue from status ring
    // TODO: Release descriptor
    // TODO: Call packet->complete()
}
