//
//  ItlSkywalkMemorySegment.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkMemorySegment.hpp"

ItlSkywalkMemorySegment::ItlSkywalkMemorySegment()
    : mapper_(nullptr)
{
}

ItlSkywalkMemorySegment::~ItlSkywalkMemorySegment()
{
    free();
}

bool ItlSkywalkMemorySegment::init(void *mapper)
{
    mapper_ = mapper;
    
    // TODO: Detect IOMapper from IO80211SkywalkInterface
    // If mapper available: use for Tx/Rx buffers
    // If not: allocate bounce buffers (as in BCMC processPacketNoMapper)
    
    return true;
}

void ItlSkywalkMemorySegment::free()
{
    mapper_ = nullptr;
}

bool ItlSkywalkMemorySegment::mapBuffer(void *virtualAddress, uint32_t size, uint32_t &dmaAddress)
{
    if (!virtualAddress || size == 0)
        return false;
    
    // TODO: If hasMapper(), use mapper_->mapMemoryDescriptor()
    // TODO: Else, return virtualAddress as-is (IOMMU will handle, or bounce buffer alloc)
    
    dmaAddress = 0;
    return true;
}

void ItlSkywalkMemorySegment::unmapBuffer(uint32_t dmaAddress, uint32_t size)
{
    // TODO: If hasMapper(), call mapper_->unmapMemoryDescriptor()
}
