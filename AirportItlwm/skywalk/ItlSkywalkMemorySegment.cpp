//
//  ItlSkywalkMemorySegment.cpp
//  AirportItlwm-Skywalk
//

#include "ItlSkywalkMemorySegment.hpp"
#include <libkern/libkern.h>

#define super IOSkywalkMemorySegment
OSDefineMetaClassAndStructors(ItlSkywalkMemorySegment, IOSkywalkMemorySegment);

ItlSkywalkMemorySegment *ItlSkywalkMemorySegment::withDescriptor(IOMemoryDescriptor *descriptor)
{
    if (!descriptor)
        return nullptr;

    ItlSkywalkMemorySegment *seg = new ItlSkywalkMemorySegment;
    if (!seg)
        return nullptr;

    seg->descriptor_ = descriptor;
    seg->length_ = descriptor->getLength();
    descriptor->retain();

    return seg;
}

void ItlSkywalkMemorySegment::free()
{
    if (descriptor_) {
        descriptor_->release();
        descriptor_ = nullptr;
    }

    super::free();
}

void ItlSkywalkMemorySegment::complete(uint32_t status)
{
    // TODO(phase4): сигнал завершения DMA над сегментом.
}

IOMemoryDescriptor *ItlSkywalkMemorySegment::getMemoryDescriptor(void)
{
    return descriptor_;
}

uint32_t ItlSkywalkMemorySegment::getLength(void)
{
    return length_;
}