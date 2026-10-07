__ZNK28AppleBCMWLANChipConfigurator8resetBusEv.cold.1:
   133a0:	55	pushq	%rbp
   133a1:	48 89 e5	movq	%rsp, %rbp
   133a4:	48 8d 3d 86 43 00 00	leaq	0x4386(%rip), %rdi ## literal pool for: "bcmc: %s Assertion Failed: The chip must provide a PCIe Gen 2 core.\n"
   133ab:	48 8d 35 4b 43 00 00	leaq	0x434b(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::resetBus() const"
   133b2:	31 c0	xorl	%eax, %eax
   133b4:	e8 00 00 00 00	callq	_IOLog
   133b9:	48 8d 3d c8 05 00 00	leaq	0x5c8(%rip), %rdi ## literal pool for: "bcmc: Assertion triggered in file %s at line %d\n"
   133c0:	48 8d 35 35 3a 00 00	leaq	0x3a35(%rip), %rsi ## literal pool for: "/Users/runner/work/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion/AppleBCMWLANChipConfigurator.cpp"
   133c7:	ba 71 06 00 00	movl	$0x671, %edx
   133cc:	31 c0	xorl	%eax, %eax
   133ce:	e8 00 00 00 00	callq	_panic
   133d3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
