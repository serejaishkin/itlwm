__ZNK28AppleBCMWLANChipConfigurator16resetCorePrivateERK14CoreDescriptor:
    8f60:	55	pushq	%rbp
    8f61:	48 89 e5	movq	%rsp, %rbp
    8f64:	41 57	pushq	%r15
    8f66:	41 56	pushq	%r14
    8f68:	53	pushq	%rbx
    8f69:	50	pushq	%rax
    8f6a:	48 89 f3	movq	%rsi, %rbx
    8f6d:	49 89 fe	movq	%rdi, %r14
    8f70:	41 bf 32 00 00 00	movl	$0x32, %r15d
    8f76:	66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    8f80:	8b 53 0c	movl	0xc(%rbx), %edx
    8f83:	49 8b 7e 10	movq	0x10(%r14), %rdi
    8f87:	be 80 00 00 00	movl	$0x80, %esi
    8f8c:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    8f91:	49 8b 46 20	movq	0x20(%r14), %rax
    8f95:	f7 80 00 08 00 00 01 00 00 00	testl	$0x1, 0x800(%rax)
    8f9f:	74 4f	je	0x8ff0
    8fa1:	8b 53 0c	movl	0xc(%rbx), %edx
    8fa4:	49 8b 7e 10	movq	0x10(%r14), %rdi
    8fa8:	be 80 00 00 00	movl	$0x80, %esi
    8fad:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    8fb2:	49 8b 46 20	movq	0x20(%r14), %rax
    8fb6:	c7 80 00 08 00 00 00 00 00 00	movl	$0x0, 0x800(%rax)
    8fc0:	bf 32 00 00 00	movl	$0x32, %edi
    8fc5:	e8 00 00 00 00	callq	_IODelay
    8fca:	41 ff cf	decl	%r15d
    8fcd:	75 b1	jne	0x8f80
    8fcf:	8b 13	movl	(%rbx), %edx
    8fd1:	48 8d 3d bf dc 00 00	leaq	0xdcbf(%rip), %rdi ## literal pool for: "bcmc: %s Warning: Core ID = 0x%x, Timed out waiting for the core to reset.\n"
    8fd8:	48 8d 35 04 dd 00 00	leaq	0xdd04(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::resetCorePrivate(const CoreDescriptor &) const"
    8fdf:	31 c0	xorl	%eax, %eax
    8fe1:	48 83 c4 08	addq	$0x8, %rsp
    8fe5:	5b	popq	%rbx
    8fe6:	41 5e	popq	%r14
    8fe8:	41 5f	popq	%r15
    8fea:	5d	popq	%rbp
    8feb:	e9 00 00 00 00	jmp	_IOLog
    8ff0:	48 83 c4 08	addq	$0x8, %rsp
    8ff4:	5b	popq	%rbx
    8ff5:	41 5e	popq	%r14
    8ff7:	41 5f	popq	%r15
    8ff9:	5d	popq	%rbp
    8ffa:	c3	retq
    8ffb:	0f 1f 44 00 00	nopl	(%rax,%rax)
