//
//  IOSkywalkMemorySegment.h
//  itlwm
//
//  Контракт IOSkywalkMemorySegment — сегмент памяти, который драйвер
//  выделяет для пакетов Skywalk. В реверсе AppleBCMWLANCompanion виден
//  сабкласс:
//
//    - AppleBCMWLANPCIeSkywalkMemorySegmentBridge::complete(
//        AppleBCMWLANPCIeSkywalkMemorySegment*, uint32_t)
//    - AppleBCMWLANPCIeSkywalkMemorySegment::withProvider(...
//        IODMACommand / IOMapper ...)
//
//  ВНimание: реальный размер и полный набор виртуальных методов уточнять
//  на целевой ОС (-itlwmcontract). Это рабочий скелет.

#ifndef IOSkywalkMemorySegment_h
#define IOSkywalkMemorySegment_h

#include <IOKit/IOService.h>
#include <IOKit/IOMemoryDescriptor.h>

class IOSkywalkMemorySegment : public OSObject {
    OSDeclareAbstractStructors(IOSkywalkMemorySegment)

public:
    virtual void free() APPLE_KEXT_OVERRIDE;

    // Завершение DMA-операции над сегментом (сигнатура из
    // AppleBCMWLANPCIeSkywalkMemorySegmentBridge::complete)
    virtual void complete(uint32_t status);

    virtual IOMemoryDescriptor *getMemoryDescriptor(void);
    virtual uint32_t getLength(void);

public:
    uint8_t filter[0x40];
};

#endif /* IOSkywalkMemorySegment_h */