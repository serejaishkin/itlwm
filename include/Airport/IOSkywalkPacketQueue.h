//
//  IOSkywalkPacketQueue.h
//  itlwm
//
//  Контракт IOSkywalkPacketQueue — сабкласс, на котором ядро вызывает
//  методы датапафа. Сигнатуры выведены из реверса AppleBCMWLANCompanion:
//
//    - AppleBCMWLANPCIeSkywalkTxSubmissionQueue::willDequeuePackets(Queue*,
//        Pkt**, uint32_t)
//    - AppleBCMWLANPCIeSkywalkTxSubmissionQueue::dequeuePackets(Queue*,
//        OSObject*, IO80211NetworkPacket**, uint32_t, void*)
//    - AppleBCMWLANPCIeSkywalkTxSubmissionQueue::didDequeuePackets(Queue*,
//        Pkt**, uint32_t, uint32_t)
//    - AppleBCMWLANPCIeSkywalkTxSubmissionQueue::requestDequeue(Queue*,
//        void*, uint32_t)
//    - AppleBCMWLANPCIeSkywalk{ Tx,Rx }CompletionQueue::stagePacket(Queue*,
//        Pkt*/IO80211NetworkPacket*, bool, bool)
//
//  Apple драйверы (BCMC/AirPort*) создают ПО 2 очереди на направление
//  (submission + completion) c IOSkywalkPacketBufferPool и регистрируют их:
//      IOSkywalkEthernetInterface::registerEthernetInterface(
//          &registInfo, queues, count, txPool, rxPool, capacity)
//  order элементов в "queues" (TX sub, TX comp, RX sub, RX comp)
//  фиксируется при интерфейсе на -itlwmcontract.
//
//  ВНИМАНИЕ: скелет контракта. Неиспользуемые виртуальные методы и размер
//  (filter[]) уточнять на целевой ОС.

#ifndef IOSkywalkPacketQueue_h
#define IOSkywalkPacketQueue_h

#include <IOKit/IOService.h>

class IOSkywalkPacket;
class IO80211NetworkPacket;
class IOSkywalkPacketBufferPool;

class IOSkywalkPacketQueue : public OSObject {
    OSDeclareAbstractStructors(IOSkywalkPacketQueue)

public:
    virtual void free() APPLE_KEXT_OVERRIDE;

    // Submission side: ядро пополняет буфер и передаёт пакеты на отправку.
    // Драйвер должен забрать пакеты из buffer[], отправить их на железо и
    // вернуть заполненное число в почте return.
    virtual void willDequeuePackets(IOSkywalkPacket **buffer, uint32_t count);
    virtual void didDequeuePackets(IOSkywalkPacket **buffer, uint32_t count, uint32_t requestedCount);
    virtual void requestDequeue(void *arg, uint32_t count);
    virtual void dequeuePackets(OSObject *queueInfo, IO80211NetworkPacket **packets, uint32_t count, void *reserved);

    // Completion side: ядро возвращает пакеты после обработки.
    virtual void stagePacket(IO80211NetworkPacket *packet, bool a, bool b);

public:
    uint8_t filter[0x40];
};

#endif /* IOSkywalkPacketQueue_h */