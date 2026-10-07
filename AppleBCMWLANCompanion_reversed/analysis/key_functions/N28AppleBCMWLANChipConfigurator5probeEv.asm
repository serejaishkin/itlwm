__ZN28AppleBCMWLANChipConfigurator5probeEv:
    8ad0:	55	pushq	%rbp
    8ad1:	48 89 e5	movq	%rsp, %rbp
    8ad4:	53	pushq	%rbx
    8ad5:	48 83 ec 28	subq	$0x28, %rsp
    8ad9:	48 89 fb	movq	%rdi, %rbx
    8adc:	48 8b 7f 10	movq	0x10(%rdi), %rdi
    8ae0:	be 80 00 00 00	movl	$0x80, %esi
    8ae5:	ba 00 00 00 18	movl	$0x18000000, %edx
    8aea:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    8aef:	48 8b 43 20	movq	0x20(%rbx), %rax
    8af3:	8b 00	movl	(%rax), %eax
    8af5:	0f b7 c8	movzwl	%ax, %ecx
    8af8:	89 8b b0 00 00 00	movl	%ecx, 0xb0(%rbx)
    8afe:	41 89 c0	movl	%eax, %r8d
    8b01:	41 c1 e8 10	shrl	$0x10, %r8d
    8b05:	41 83 e0 0f	andl	$0xf, %r8d
    8b09:	44 89 83 b4 00 00 00	movl	%r8d, 0xb4(%rbx)
    8b10:	c1 e8 1c	shrl	$0x1c, %eax
    8b13:	89 83 b8 00 00 00	movl	%eax, 0xb8(%rbx)
    8b19:	8d 81 ff 5f ff ff	leal	-0xa001(%rcx), %eax
    8b1f:	3d ff 9f ff ff	cmpl	$0xffff9fff, %eax
    8b24:	48 8d 05 37 e0 00 00	leaq	0xe037(%rip), %rax ## literal pool for: "BCM%d/%u"
    8b2b:	48 8d 15 39 e0 00 00	leaq	0xe039(%rip), %rdx ## literal pool for: "BCM%x/%u"
    8b32:	48 0f 42 d0	cmovbq	%rax, %rdx
    8b36:	48 8d bb a0 00 00 00	leaq	0xa0(%rbx), %rdi
    8b3d:	be 10 00 00 00	movl	$0x10, %esi
    8b42:	31 c0	xorl	%eax, %eax
    8b44:	e8 00 00 00 00	callq	_snprintf
    8b49:	83 bb b8 00 00 00 01	cmpl	$0x1, 0xb8(%rbx)
    8b50:	0f 85 2d 01 00 00	jne	0x8c83
    8b56:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    8b5a:	be 80 00 00 00	movl	$0x80, %esi
    8b5f:	ba 00 00 00 18	movl	$0x18000000, %edx
    8b64:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    8b69:	48 8b 43 20	movq	0x20(%rbx), %rax
    8b6d:	8b 40 04	movl	0x4(%rax), %eax
    8b70:	89 83 bc 00 00 00	movl	%eax, 0xbc(%rbx)
    8b76:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    8b7a:	be 80 00 00 00	movl	$0x80, %esi
    8b7f:	ba 00 00 00 18	movl	$0x18000000, %edx
    8b84:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    8b89:	48 8b 43 20	movq	0x20(%rbx), %rax
    8b8d:	8b 80 ac 00 00 00	movl	0xac(%rax), %eax
    8b93:	89 83 c0 00 00 00	movl	%eax, 0xc0(%rbx)
    8b99:	48 89 df	movq	%rbx, %rdi
    8b9c:	e8 3f f2 ff ff	callq	__ZN28AppleBCMWLANChipConfigurator9probeEROMEv ## AppleBCMWLANChipConfigurator::probeEROM()
    8ba1:	84 c0	testb	%al, %al
    8ba3:	0f 84 e3 00 00 00	je	0x8c8c
    8ba9:	48 89 df	movq	%rbx, %rdi
    8bac:	e8 ff f6 ff ff	callq	__ZN28AppleBCMWLANChipConfigurator8readSROMEv ## AppleBCMWLANChipConfigurator::readSROM()
    8bb1:	48 85 c0	testq	%rax, %rax
    8bb4:	0f 84 db 00 00 00	je	0x8c95
    8bba:	c7 45 f0 00 00 00 00	movl	$0x0, -0x10(%rbp)
    8bc1:	48 c7 45 e8 00 00 00 00	movq	$0x0, -0x18(%rbp)
    8bc9:	48 c7 45 e0 00 00 00 00	movq	$0x0, -0x20(%rbp)
    8bd1:	48 c7 45 d8 00 00 00 00	movq	$0x0, -0x28(%rbp)
    8bd9:	48 8d 7d d8	leaq	-0x28(%rbp), %rdi
    8bdd:	48 89 c6	movq	%rax, %rsi
    8be0:	e8 5b 9d ff ff	callq	__ZN4SROM8identifyEPKh ## SROM::identify(unsigned char const*)
    8be5:	80 7d f0 00	cmpb	$0x0, -0x10(%rbp)
    8be9:	0f 84 af 00 00 00	je	0x8c9e
    8bef:	48 8b 45 e8	movq	-0x18(%rbp), %rax
    8bf3:	48 89 83 e0 01 00 00	movq	%rax, 0x1e0(%rbx)
    8bfa:	48 8b 45 d8	movq	-0x28(%rbp), %rax
    8bfe:	48 8b 4d e0	movq	-0x20(%rbp), %rcx
    8c02:	48 89 8b d8 01 00 00	movq	%rcx, 0x1d8(%rbx)
    8c09:	48 89 83 d0 01 00 00	movq	%rax, 0x1d0(%rbx)
    8c10:	8b 83 c4 01 00 00	movl	0x1c4(%rbx), %eax
    8c16:	48 85 c0	testq	%rax, %rax
    8c19:	74 5f	je	0x8c7a
    8c1b:	48 8d 8b c4 00 00 00	leaq	0xc4(%rbx), %rcx
    8c22:	48 89 ce	movq	%rcx, %rsi
    8c25:	48 89 c2	movq	%rax, %rdx
    8c28:	0f 1f 84 00 00 00 00 00	nopl	(%rax,%rax)
    8c30:	81 3e 3e 08 00 00	cmpl	$0x83e, (%rsi)
    8c36:	0f 84 97 00 00 00	je	0x8cd3
    8c3c:	48 83 c6 10	addq	$0x10, %rsi
    8c40:	48 ff ca	decq	%rdx
    8c43:	75 eb	jne	0x8c30
    8c45:	48 c1 e0 04	shlq	$0x4, %rax
    8c49:	31 d2	xorl	%edx, %edx
    8c4b:	0f 1f 44 00 00	nopl	(%rax,%rax)
    8c50:	81 3c 11 47 08 00 00	cmpl	$0x847, (%rcx,%rdx)
    8c57:	0f 84 80 00 00 00	je	0x8cdd
    8c5d:	48 83 c2 10	addq	$0x10, %rdx
    8c61:	48 39 d0	cmpq	%rdx, %rax
    8c64:	75 ea	jne	0x8c50
    8c66:	31 d2	xorl	%edx, %edx
    8c68:	81 3c 11 2a 08 00 00	cmpl	$0x82a, (%rcx,%rdx)
    8c6f:	74 75	je	0x8ce6
    8c71:	48 83 c2 10	addq	$0x10, %rdx
    8c75:	48 39 d0	cmpq	%rdx, %rax
    8c78:	75 ee	jne	0x8c68
    8c7a:	48 8d 3d 8d e2 00 00	leaq	0xe28d(%rip), %rdi ## literal pool for: "bcmc: %s Error: The chip does not have a known ARM core.\n"
    8c81:	eb 6a	jmp	0x8ced
    8c83:	48 8d 3d ea de 00 00	leaq	0xdeea(%rip), %rdi ## literal pool for: "bcmc: %s Error: Chips that have a interconnect type of Sonic Backplane is not supported.\n"
    8c8a:	eb 2e	jmp	0x8cba
    8c8c:	48 8d 3d 66 df 00 00	leaq	0xdf66(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to probe the EROM.\n"
    8c93:	eb 25	jmp	0x8cba
    8c95:	48 8d 3d 55 db 00 00	leaq	0xdb55(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to read the SROM content.\n"
    8c9c:	eb 07	jmp	0x8ca5
    8c9e:	48 8d 3d ad db 00 00	leaq	0xdbad(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to read and identify the SROM.\n"
    8ca5:	48 8d 35 77 db 00 00	leaq	0xdb77(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::probeSROM()"
    8cac:	31 c0	xorl	%eax, %eax
    8cae:	e8 00 00 00 00	callq	_IOLog
    8cb3:	48 8d 3d 6a df 00 00	leaq	0xdf6a(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to probe the SROM.\n"
    8cba:	48 8d 35 0d df 00 00	leaq	0xdf0d(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::probe()"
    8cc1:	31 db	xorl	%ebx, %ebx
    8cc3:	31 c0	xorl	%eax, %eax
    8cc5:	e8 00 00 00 00	callq	_IOLog
    8cca:	89 d8	movl	%ebx, %eax
    8ccc:	48 83 c4 28	addq	$0x28, %rsp
    8cd0:	5b	popq	%rbx
    8cd1:	5d	popq	%rbp
    8cd2:	c3	retq
    8cd3:	48 89 df	movq	%rbx, %rdi
    8cd6:	e8 d5 05 00 00	callq	__ZNK28AppleBCMWLANChipConfigurator13setPassiveCR4ERK14CoreDescriptor ## AppleBCMWLANChipConfigurator::setPassiveCR4(CoreDescriptor const&) const
    8cdb:	eb 1e	jmp	0x8cfb
    8cdd:	48 8d 3d 6d dd 00 00	leaq	0xdd6d(%rip), %rdi ## literal pool for: "bcmc: %s Error: ARM Cortex-A7 core is not supported at this moment.\n"
    8ce4:	eb 07	jmp	0x8ced
    8ce6:	48 8d 3d de dd 00 00	leaq	0xddde(%rip), %rdi ## literal pool for: "bcmc: %s Error: ARM Cortex-M3 core is not supported at this moment.\n"
    8ced:	48 8d 35 e4 e1 00 00	leaq	0xe1e4(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::setPassive() const"
    8cf4:	31 c0	xorl	%eax, %eax
    8cf6:	e8 00 00 00 00	callq	_IOLog
    8cfb:	48 89 df	movq	%rbx, %rdi
    8cfe:	e8 8d fc ff ff	callq	__ZN28AppleBCMWLANChipConfigurator15probeMemoryInfoEv ## AppleBCMWLANChipConfigurator::probeMemoryInfo()
    8d03:	b3 01	movb	$0x1, %bl
    8d05:	84 c0	testb	%al, %al
    8d07:	75 c1	jne	0x8cca
    8d09:	48 8d 3d 3f df 00 00	leaq	0xdf3f(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to fetch the information about the chip memory.\n"
    8d10:	eb a8	jmp	0x8cba
    8d12:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
