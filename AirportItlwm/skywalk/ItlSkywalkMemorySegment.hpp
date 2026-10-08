//
//  ItlSkywalkMemorySegment.hpp
//  AirportItlwm-Skywalk
//
//  Сегмент памяти для DMA: субкласс IOSkywalkMemorySegment. Скелет —
//  IOMapper-маппинг или bounce fallback, реальный маппинг на фазе 4.
//

#ifndef ItlSkywalkMemorySegment_hpp
#define ItlSkywalkMemorySegment_hpp

#include <Airport/IOSkywalkMemorySegment.h>
#include <IOKit/IOMemoryDescriptor.h>

class ItlSkywalkMemorySegment : public IOSkywalkMemorySegment {
    OSDeclareDefaultStructors(ItlSkywalkMemorySegment)

private:
    IOMemoryDescriptor *descriptor_;
    uint32_t length_;

public:
    static ItlSkywalkMemorySegment *withDescriptor(IOMemoryDescriptor *descriptor);

    virtual void free() APPLE_KEXT_OVERRIDE;

    virtual void complete(uint32_t status) APPLE_KEXT_OVERRIDE;
    virtual IOMemoryDescriptor *getMemoryDescriptor(void) APPLE_KEXT_OVERRIDE;
    virtual uint32_t getLength(void) APPLE_KEXT_OVERRIDE;
};

#endif /* ItlSkywalkMemorySegment_hpp */