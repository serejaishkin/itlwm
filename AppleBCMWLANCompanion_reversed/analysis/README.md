# AppleBCMWLANCompanion 1.1.0 — reverse-engineering workspace

Original input: `AppleBCMWLANCompanion` (Mach-O 64-bit x86_64 KEXT bundle, 465 KB).

## Contents
- `binary/` — untouched original Mach-O binary.
- `metadata/` — Mach-O headers/load commands.
- `symbols/` — symbol table and demangled symbol table.
- `disassembly/` — full x86_64 disassembly produced by LLVM `llvm-objdump`.
- `strings/` — all printable strings and a filtered hardware/PCIe/power/firmware subset.
- `analysis/key_functions.txt` — addresses of functions relevant to BCM43602 initialization.
- `analysis/key_functions/` — extracted disassembly for reset/power/firmware functions.
- `xcode/` — Xcode project metadata and a text-based browsing workspace.

## Important scope
This is a binary reverse-engineering workspace. The generated assembly is not source code and must not be treated as an exact reconstruction of the original Apple/FireWolf source.

The binary retains C++ symbols and source-path strings, which makes function-level analysis substantially easier.

## Initial targets
The first functions to study are:
- `AppleBCMWLANChipConfigurator::resetDevice()`
- `AppleBCMWLANChipConfigurator::resetBus()`
- `AppleBCMWLANChipConfigurator::resetCore(...)`
- `AppleBCMWLANChipConfigurator::resetCorePrivate(...)`
- `AppleBCMWLANChipBackplaneBridge::forcePower(...)`
- `AppleBCMWLANChipBackplaneBridge::forcePowerLite(...)`
- `AppleBCMWLANChipManagerPCIeBridge::setPowerControlRequired(...)`
- `AppleBCMWLANChipManagerPCIeBridge::setM2MResetOnSSResetDisabled(...)`
- `AppleBCMWLANChipConfigurator::probe()`
- `AppleBCMWLANChipConfigurator::enterDownloadState()`
- `AppleBCMWLANChipConfigurator::exitDownloadState(...)`
- `AppleBCMWLANChipConfigurator::requestFirmware()`
- `AppleBCMWLANChipConfigurator::verifyFirmware(...)`

## Why these matter
The Windows test shows that the BCM43602 PCIe device can enumerate cleanly and the Broadcom miniport can recover from a no-scan state after a Disable/Enable cycle. The goal of this reverse-engineering pass is to identify the low-level PCIe/reset/power/firmware sequence used by BCMC and compare it with the Windows behavior.

No Windows INF or OpenCore modification is included in this archive.
