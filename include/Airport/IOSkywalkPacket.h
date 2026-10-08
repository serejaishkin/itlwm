//
//  IOSkywalkPacket.h
//  itlwm
//
//  Контракт IOSkywalkPacket — выведен из реверса AppleBCMWLANCompanion
//  (AppleBCMWLANCompanion_reversed/disassembly/full_x86_64.asm + symbols).
//
//  Источник сигнатур:
//    - AppleBCMWLANPCIeSkywalkPacketBridge::prepareWithQueue(AppleBCMWLANPCIeSkywalkPacket*,
//        IOSkywalkPacketQueue*, IOSkywalkPacketDirection)
//    - AppleBCMWLANPCIeSkywalkPacketBridge::complete(AppleBCMWLANPCIeSkywalkPacket*,
//        IOSkywalkPacketQueue*, IOSkywalkPacketDirection)
//    - IOSkywalkPacketBridge::getDataLength(IOSkywalkPacket*)
//    - IOSkywalkPacketBridge::getDataOffset(IOSkywalkPacket*)
//
//  ВНИМАНИЕ: это рабочий скелет контракта, а не полный реверс класса.
//  Размер/поля (filter[]) и неиспользуемые виртуальные методы уточнять
//  по dump фингерпринта (-itlwmcontract) на целевой ОС.

#ifndef IOSkywalkPacket_h
#define IOSkywalkPacket_h

#include <IOKit/IOService.h>

class IOSkywalkPacketQueue;
class IOSkywalkPacketBufferPool;
class IOSkywalkPacketDescriptor;

enum IOSkywalkPacketDirection : uint32_t {
    IOSkywalkPacketDirectionNone           = 0,
    IOSkywalkPacketDirectionTxSubmission   = 1,
    IOSkywalkPacketDirectionTxCompletion   = 2,
    IOSkywalkPacketDirectionRxSubmission   = 3,
    IOSkywalkPacketDirectionRxCompletion   = 4,
};

class IOSkywalkPacket : public OSObject {
    OSDeclareAbstractStructors(IOSkywalkPacket)

public:
    virtual void free() APPLE_KEXT_OVERRIDE;

    // Работа с полезной нагрузкой (сигнатуры из IOSkywalkPacketBridge)
    virtual UInt getDataLength(void);
    virtual unsigned short getDataOffset(void);
    virtual void setDataLength(uint);
    virtual void setDataOffset(unsigned short);
    virtual void *getDataVirtualAddress(void);
    virtual void *getDataIOVirtualAddress(void);

    // Подготовка/завершение относительно очереди (сигнатуры из
    // AppleBCMWLANPCIeSkywalkPacketBridge — это то, что ядро ожидает от пакета)
    virtual bool prepareWithQueue(IOSkywalkPacketQueue *, IOSkywalkPacketDirection);
    virtual bool prepare(IOSkywalkPacketQueue *, unsigned long long, unsigned int);
    virtual void completeWithQueue(IOSkywalkPacketQueue *, uint, uint);
    virtual void complete(IOSkywalkPacketQueue *, IOSkywalkPacketDirection);
    virtual void disposePacket(void);

public:
    uint8_t filter[0x80];
};

#endif /* IOSkywalkPacket_h */