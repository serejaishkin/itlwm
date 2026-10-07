__ZNK28AppleBCMWLANChipConfigurator11resetDeviceEv:
    9f00:	55	pushq	%rbp
    9f01:	48 89 e5	movq	%rsp, %rbp
    9f04:	41 57	pushq	%r15
    9f06:	41 56	pushq	%r14
    9f08:	41 55	pushq	%r13
    9f0a:	41 54	pushq	%r12
    9f0c:	53	pushq	%rbx
    9f0d:	50	pushq	%rax
    9f0e:	8b 87 c4 01 00 00	movl	0x1c4(%rdi), %eax
    9f14:	48 85 c0	testq	%rax, %rax
    9f17:	74 2e	je	0x9f47
    9f19:	48 89 fb	movq	%rdi, %rbx
    9f1c:	48 c1 e0 04	shlq	$0x4, %rax
    9f20:	45 31 ff	xorl	%r15d, %r15d
    9f23:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    9f30:	42 81 bc 3b c4 00 00 00 3c 08 00 00	cmpl	$0x83c, 0xc4(%rbx,%r15)
    9f3c:	74 33	je	0x9f71
    9f3e:	49 83 c7 10	addq	$0x10, %r15
    9f42:	4c 39 f8	cmpq	%r15, %rax
    9f45:	75 e9	jne	0x9f30
    9f47:	48 8d 3d 11 d7 00 00	leaq	0xd711(%rip), %rdi ## literal pool for: "bcmc: %s Error: The chip must provide a PCIe Gen 2 core.\n"
    9f4e:	48 8d 35 44 d7 00 00	leaq	0xd744(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::resetDevice() const"
    9f55:	45 31 f6	xorl	%r14d, %r14d
    9f58:	31 c0	xorl	%eax, %eax
    9f5a:	e8 00 00 00 00	callq	_IOLog
    9f5f:	44 89 f0	movl	%r14d, %eax
    9f62:	48 83 c4 08	addq	$0x8, %rsp
    9f66:	5b	popq	%rbx
    9f67:	41 5c	popq	%r12
    9f69:	41 5d	popq	%r13
    9f6b:	41 5e	popq	%r14
    9f6d:	41 5f	popq	%r15
    9f6f:	5d	popq	%rbp
    9f70:	c3	retq
    9f71:	42 8b 94 3b cc 00 00 00	movl	0xcc(%rbx,%r15), %edx
    9f79:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9f7d:	be 80 00 00 00	movl	$0x80, %esi
    9f82:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9f87:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9f8b:	be bc 00 00 00	movl	$0xbc, %esi
    9f90:	e8 00 00 00 00	callq	__ZN11IOPCIDevice20extendedConfigRead32Ey
    9f95:	41 89 c6	movl	%eax, %r14d
    9f98:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9f9c:	89 c2	movl	%eax, %edx
    9f9e:	83 e2 fc	andl	$-0x4, %edx
    9fa1:	be bc 00 00 00	movl	$0xbc, %esi
    9fa6:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9fab:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9faf:	be 80 00 00 00	movl	$0x80, %esi
    9fb4:	ba 00 00 00 18	movl	$0x18000000, %edx
    9fb9:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9fbe:	48 8b 43 20	movq	0x20(%rbx), %rax
    9fc2:	c7 80 80 00 00 00 04 00 00 00	movl	$0x4, 0x80(%rax)
    9fcc:	bf 64 00 00 00	movl	$0x64, %edi
    9fd1:	e8 00 00 00 00	callq	_IOSleep
    9fd6:	42 8b 94 3b cc 00 00 00	movl	0xcc(%rbx,%r15), %edx
    9fde:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9fe2:	be 80 00 00 00	movl	$0x80, %esi
    9fe7:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9fec:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9ff0:	be bc 00 00 00	movl	$0xbc, %esi
    9ff5:	44 89 f2	movl	%r14d, %edx
    9ff8:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9ffd:	41 b6 01	movb	$0x1, %r14b
    a000:	42 83 bc 3b c8 00 00 00 0d	cmpl	$0xd, 0xc8(%rbx,%r15)
    a009:	0f 87 50 ff ff ff	ja	0x9f5f
    a00f:	45 31 e4	xorl	%r12d, %r12d
    a012:	4c 8d 2d a7 07 01 00	leaq	__ZZNK28AppleBCMWLANChipConfigurator11resetDeviceEvE26kPCIeGen2CoreConfigOffsets(%rip), %r13 ## AppleBCMWLANChipConfigurator::resetDevice() const::kPCIeGen2CoreConfigOffsets
    a019:	0f 1f 80 00 00 00 00	nopl	(%rax)
    a020:	47 8b 34 2c	movl	(%r12,%r13), %r14d
    a024:	42 8b 94 3b cc 00 00 00	movl	0xcc(%rbx,%r15), %edx
    a02c:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    a030:	be 80 00 00 00	movl	$0x80, %esi
    a035:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    a03a:	48 8b 43 20	movq	0x20(%rbx), %rax
    a03e:	44 89 b0 20 01 00 00	movl	%r14d, 0x120(%rax)
    a045:	42 8b 94 3b cc 00 00 00	movl	0xcc(%rbx,%r15), %edx
    a04d:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    a051:	be 80 00 00 00	movl	$0x80, %esi
    a056:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    a05b:	48 8b 43 20	movq	0x20(%rbx), %rax
    a05f:	44 8b b0 24 01 00 00	movl	0x124(%rax), %r14d
    a066:	42 8b 94 3b cc 00 00 00	movl	0xcc(%rbx,%r15), %edx
    a06e:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    a072:	be 80 00 00 00	movl	$0x80, %esi
    a077:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    a07c:	48 8b 43 20	movq	0x20(%rbx), %rax
    a080:	44 89 b0 24 01 00 00	movl	%r14d, 0x124(%rax)
    a087:	49 83 c4 04	addq	$0x4, %r12
    a08b:	49 83 fc 2c	cmpq	$0x2c, %r12
    a08f:	75 8f	jne	0xa020
    a091:	41 b6 01	movb	$0x1, %r14b
    a094:	e9 c6 fe ff ff	jmp	0x9f5f
    a099:	0f 1f 80 00 00 00 00	nopl	(%rax)
