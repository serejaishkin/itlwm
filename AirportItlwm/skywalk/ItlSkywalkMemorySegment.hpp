//
//  ItlSkywalkMemorySegment.hpp
//  AirportItlwm-Skywalk
//
//  Memory segment abstraction: IOMapper-aware DMA mapping or bounce buffer fallback.
//

#ifndef ItlSkywalkMemorySegment_hpp
#define ItlSkywalkMemorySegment_hpp

#include <IOKit/IOTypes.h>
#include <IOKit/IOMemoryDescriptor.h>

class ItlSkywalkMemorySegment {
public:
    ItlSkywalkMemorySegment();
    ~ItlSkywalkMemorySegment();
    
    // Initialize with optional IOMapper
    bool init(void *mapper = nullptr);
    void free();
    
    // Map virtual buffer to DMA address
    bool mapBuffer(void *virtualAddress, uint32_t size, uint32_t &dmaAddress);
    void unmapBuffer(uint32_t dmaAddress, uint32_t size);
    
    // Check if IOMapper is available
    bool hasMapper() const { return mapper_ != nullptr; }
    
private:
    void *mapper_;
};

#endif /* ItlSkywalkMemorySegment_hpp */
