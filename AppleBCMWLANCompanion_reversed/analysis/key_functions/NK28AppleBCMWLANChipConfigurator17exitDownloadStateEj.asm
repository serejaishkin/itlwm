__ZNK28AppleBCMWLANChipConfigurator17exitDownloadStateEj:
    9770:	55	pushq	%rbp
    9771:	48 89 e5	movq	%rsp, %rbp
    9774:	41 56	pushq	%r14
    9776:	53	pushq	%rbx
    9777:	81 bf b0 00 00 00 52 aa 00 00	cmpl	$0xaa52, 0xb0(%rdi)
    9781:	75 48	jne	0x97cb
    9783:	8b 87 c4 01 00 00	movl	0x1c4(%rdi), %eax
    9789:	48 85 c0	testq	%rax, %rax
    978c:	74 23	je	0x97b1
    978e:	41 89 f6	movl	%esi, %r14d
    9791:	48 8d b7 c4 00 00 00	leaq	0xc4(%rdi), %rsi
    9798:	0f 1f 84 00 00 00 00 00	nopl	(%rax,%rax)
    97a0:	81 3e 0e 08 00 00	cmpl	$0x80e, (%rsi)
    97a6:	74 0e	je	0x97b6
    97a8:	48 83 c6 10	addq	$0x10, %rsi
    97ac:	48 ff c8	decq	%rax
    97af:	75 ef	jne	0x97a0
    97b1:	e8 6a 9b 00 00	callq	__ZNK28AppleBCMWLANChipConfigurator17exitDownloadStateEj.cold.1 ## AppleBCMWLANChipConfigurator::exitDownloadState(unsigned int) const (.cold.1)
    97b6:	48 89 fb	movq	%rdi, %rbx
    97b9:	31 d2	xorl	%edx, %edx
    97bb:	31 c9	xorl	%ecx, %ecx
    97bd:	45 31 c0	xorl	%r8d, %r8d
    97c0:	e8 3b f8 ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator9resetCoreERK14CoreDescriptorjjj ## AppleBCMWLANChipConfigurator::resetCore(CoreDescriptor const&, unsigned int, unsigned int, unsigned int) const
    97c5:	48 89 df	movq	%rbx, %rdi
    97c8:	44 89 f6	movl	%r14d, %esi
    97cb:	5b	popq	%rbx
    97cc:	41 5e	popq	%r14
    97ce:	5d	popq	%rbp
    97cf:	e9 cc fb ff ff	jmp	__ZNK28AppleBCMWLANChipConfigurator9setActiveEj ## AppleBCMWLANChipConfigurator::setActive(unsigned int) const
    97d4:	66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
