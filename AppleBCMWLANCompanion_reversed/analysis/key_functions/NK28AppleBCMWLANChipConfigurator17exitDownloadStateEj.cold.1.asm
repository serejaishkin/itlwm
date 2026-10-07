__ZNK28AppleBCMWLANChipConfigurator17exitDownloadStateEj.cold.1:
   13320:	55	pushq	%rbp
   13321:	48 89 e5	movq	%rsp, %rbp
   13324:	48 8d 3d f2 3e 00 00	leaq	0x3ef2(%rip), %rdi ## literal pool for: "bcmc: %s Assertion Failed: BCM43602 must provide an internal memory core.\n"
   1332b:	48 8d 35 36 3f 00 00	leaq	0x3f36(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::exitDownloadState(UInt32) const"
   13332:	31 c0	xorl	%eax, %eax
   13334:	e8 00 00 00 00	callq	_IOLog
   13339:	48 8d 3d 48 06 00 00	leaq	0x648(%rip), %rdi ## literal pool for: "bcmc: Assertion triggered in file %s at line %d\n"
   13340:	48 8d 35 b5 3a 00 00	leaq	0x3ab5(%rip), %rsi ## literal pool for: "/Users/runner/work/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion-Private/AppleBCMWLANCompanion/AppleBCMWLANChipConfigurator.cpp"
   13347:	ba d9 04 00 00	movl	$0x4d9, %edx
   1334c:	31 c0	xorl	%eax, %eax
   1334e:	e8 00 00 00 00	callq	_panic
   13353:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
