__ZNK28AppleBCMWLANChipConfigurator18enterDownloadStateEv.cold.1:
   132e0:	55	pushq	%rbp
   132e1:	48 89 e5	movq	%rsp, %rbp
   132e4:	48 8d 3d ab 3e 00 00	leaq	0x3eab(%rip), %rdi ## literal pool for: "bcmc: %s Assertion Failed: BCM43602 must provide an ARM Cortex-R4 core.\n"
   132eb:	48 8d 35 ed 3e 00 00	leaq	0x3eed(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::enterDownloadState() const"
   132f2:	31 c0	xorl	%eax, %eax
   132f4:	e8 00 00 00 00	callq	_IOLog
   132f9:	48 8d 3d 88 06 00 00	leaq	0x688(%rip), %rdi ## literal pool for: "bcmc: Assertion triggered in file %s at line %d\n"
   13300:	48 8d 35 f5 3a 00 00	leaq	0x3af5(%rip), %rsi ## literal pool for: "/Users/runner/work/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion/AppleBCMWLANChipConfigurator.cpp"
   13307:	ba ba 04 00 00	movl	$0x4ba, %edx
   1330c:	31 c0	xorl	%eax, %eax
   1330e:	e8 00 00 00 00	callq	_panic
   13313:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
