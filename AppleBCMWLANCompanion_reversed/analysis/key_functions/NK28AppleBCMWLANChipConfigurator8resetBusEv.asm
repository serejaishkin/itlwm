__ZNK28AppleBCMWLANChipConfigurator8resetBusEv:
    a0a0:	55	pushq	%rbp
    a0a1:	48 89 e5	movq	%rsp, %rbp
    a0a4:	41 57	pushq	%r15
    a0a6:	41 56	pushq	%r14
    a0a8:	41 54	pushq	%r12
    a0aa:	53	pushq	%rbx
    a0ab:	49 89 fe	movq	%rdi, %r14
    a0ae:	e8 4d fe ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator11resetDeviceEv ## AppleBCMWLANChipConfigurator::resetDevice() const
    a0b3:	89 c3	movl	%eax, %ebx
    a0b5:	84 c0	testb	%al, %al
    a0b7:	74 33	je	0xa0ec
    a0b9:	41 8b 86 c4 01 00 00	movl	0x1c4(%r14), %eax
    a0c0:	48 85 c0	testq	%rax, %rax
    a0c3:	74 22	je	0xa0e7
    a0c5:	48 c1 e0 04	shlq	$0x4, %rax
    a0c9:	45 31 ff	xorl	%r15d, %r15d
    a0cc:	0f 1f 40 00	nopl	(%rax)
    a0d0:	43 81 bc 3e c4 00 00 00 3c 08 00 00	cmpl	$0x83c, 0xc4(%r14,%r15)
    a0dc:	74 25	je	0xa103
    a0de:	49 83 c7 10	addq	$0x10, %r15
    a0e2:	4c 39 f8	cmpq	%r15, %rax
    a0e5:	75 e9	jne	0xa0d0
    a0e7:	e8 b4 92 00 00	callq	__ZNK28AppleBCMWLANChipConfigurator8resetBusEv.cold.1 ## AppleBCMWLANChipConfigurator::resetBus() const (.cold.1)
    a0ec:	48 8d 3d dd d5 00 00	leaq	0xd5dd(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to reset the device.\n"
    a0f3:	48 8d 35 03 d6 00 00	leaq	0xd603(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::resetBus() const"
    a0fa:	31 c0	xorl	%eax, %eax
    a0fc:	e8 00 00 00 00	callq	_IOLog
    a101:	eb 42	jmp	0xa145
    a103:	43 8b 94 3e cc 00 00 00	movl	0xcc(%r14,%r15), %edx
    a10b:	49 8b 7e 10	movq	0x10(%r14), %rdi
    a10f:	be 80 00 00 00	movl	$0x80, %esi
    a114:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    a119:	49 8b 46 20	movq	0x20(%r14), %rax
    a11d:	44 8b 60 48	movl	0x48(%rax), %r12d
    a121:	41 83 fc ff	cmpl	$-0x1, %r12d
    a125:	74 1e	je	0xa145
    a127:	43 8b 94 3e cc 00 00 00	movl	0xcc(%r14,%r15), %edx
    a12f:	49 8b 7e 10	movq	0x10(%r14), %rdi
    a133:	be 80 00 00 00	movl	$0x80, %esi
    a138:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    a13d:	49 8b 46 20	movq	0x20(%r14), %rax
    a141:	44 89 60 48	movl	%r12d, 0x48(%rax)
    a145:	89 d8	movl	%ebx, %eax
    a147:	5b	popq	%rbx
    a148:	41 5c	popq	%r12
    a14a:	41 5e	popq	%r14
    a14c:	41 5f	popq	%r15
    a14e:	5d	popq	%rbp
    a14f:	c3	retq
