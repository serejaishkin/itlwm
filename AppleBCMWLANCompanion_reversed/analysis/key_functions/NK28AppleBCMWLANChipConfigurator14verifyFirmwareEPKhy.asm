__ZNK28AppleBCMWLANChipConfigurator14verifyFirmwareEPKhy:
    9470:	55	pushq	%rbp
    9471:	48 89 e5	movq	%rsp, %rbp
    9474:	41 57	pushq	%r15
    9476:	41 56	pushq	%r14
    9478:	41 54	pushq	%r12
    947a:	53	pushq	%rbx
    947b:	48 81 ec a0 00 00 00	subq	$0xa0, %rsp
    9482:	48 89 fb	movq	%rdi, %rbx
    9485:	48 8b 05 bc 1b 01 00	movq	0x11bbc(%rip), %rax
    948c:	48 8b 00	movq	(%rax), %rax
    948f:	48 89 45 d8	movq	%rax, -0x28(%rbp)
    9493:	48 8b 7f 58	movq	0x58(%rdi), %rdi
    9497:	48 85 ff	testq	%rdi, %rdi
    949a:	0f 84 10 01 00 00	je	0x95b0
    94a0:	49 89 f7	movq	%rsi, %r15
    94a3:	49 89 d6	movq	%rdx, %r14
    94a6:	48 8b 07	movq	(%rdi), %rax
    94a9:	ff 90 40 01 00 00	callq	*0x140(%rax)
    94af:	83 f8 20	cmpl	$0x20, %eax
    94b2:	0f 85 01 01 00 00	jne	0x95b9
    94b8:	48 c7 45 c8 00 00 00 00	movq	$0x0, -0x38(%rbp)
    94c0:	48 c7 45 c0 00 00 00 00	movq	$0x0, -0x40(%rbp)
    94c8:	48 c7 45 b8 00 00 00 00	movq	$0x0, -0x48(%rbp)
    94d0:	48 c7 45 b0 00 00 00 00	movq	$0x0, -0x50(%rbp)
    94d8:	48 c7 45 a8 00 00 00 00	movq	$0x0, -0x58(%rbp)
    94e0:	48 c7 45 a0 00 00 00 00	movq	$0x0, -0x60(%rbp)
    94e8:	48 c7 45 98 00 00 00 00	movq	$0x0, -0x68(%rbp)
    94f0:	48 c7 45 90 00 00 00 00	movq	$0x0, -0x70(%rbp)
    94f8:	48 c7 45 88 00 00 00 00	movq	$0x0, -0x78(%rbp)
    9500:	48 c7 45 80 00 00 00 00	movq	$0x0, -0x80(%rbp)
    9508:	48 c7 85 78 ff ff ff 00 00 00 00	movq	$0x0, -0x88(%rbp)
    9513:	48 c7 85 70 ff ff ff 00 00 00 00	movq	$0x0, -0x90(%rbp)
    951e:	48 c7 85 68 ff ff ff 00 00 00 00	movq	$0x0, -0x98(%rbp)
    9529:	48 c7 85 60 ff ff ff 00 00 00 00	movq	$0x0, -0xa0(%rbp)
    9534:	48 c7 85 58 ff ff ff 00 00 00 00	movq	$0x0, -0xa8(%rbp)
    953f:	48 c7 85 50 ff ff ff 00 00 00 00	movq	$0x0, -0xb0(%rbp)
    954a:	48 c7 85 48 ff ff ff 00 00 00 00	movq	$0x0, -0xb8(%rbp)
    9555:	48 c7 85 40 ff ff ff 00 00 00 00	movq	$0x0, -0xc0(%rbp)
    9560:	4c 8d a5 40 ff ff ff	leaq	-0xc0(%rbp), %r12
    9567:	4c 89 e7	movq	%r12, %rdi
    956a:	e8 00 00 00 00	callq	_SHA256_Init
    956f:	4c 89 e7	movq	%r12, %rdi
    9572:	4c 89 fe	movq	%r15, %rsi
    9575:	4c 89 f2	movq	%r14, %rdx
    9578:	e8 00 00 00 00	callq	_SHA256_Update
    957d:	4c 8d 75 b0	leaq	-0x50(%rbp), %r14
    9581:	4c 89 f7	movq	%r14, %rdi
    9584:	4c 89 e6	movq	%r12, %rsi
    9587:	e8 00 00 00 00	callq	_SHA256_Final
    958c:	48 8b 7b 58	movq	0x58(%rbx), %rdi
    9590:	48 8b 07	movq	(%rdi), %rax
    9593:	ff 90 78 01 00 00	callq	*0x178(%rax)
    9599:	ba 20 00 00 00	movl	$0x20, %edx
    959e:	4c 89 f7	movq	%r14, %rdi
    95a1:	48 89 c6	movq	%rax, %rsi
    95a4:	e8 00 00 00 00	callq	_memcmp
    95a9:	85 c0	testl	%eax, %eax
    95ab:	0f 94 c3	sete	%bl
    95ae:	eb 20	jmp	0x95d0
    95b0:	48 8d 3d cc d9 00 00	leaq	0xd9cc(%rip), %rdi ## literal pool for: "bcmc: %s Error: Users did not specify the firmware checksum.\n"
    95b7:	eb 07	jmp	0x95c0
    95b9:	48 8d 3d 55 da 00 00	leaq	0xda55(%rip), %rdi ## literal pool for: "bcmc: %s Error: Users did not specify a valid SHA-256 checksum.\n"
    95c0:	48 8d 35 fa d9 00 00	leaq	0xd9fa(%rip), %rsi ## literal pool for: "bool AppleBCMWLANChipConfigurator::verifyFirmware(const UInt8 *, IOByteCount) const"
    95c7:	31 db	xorl	%ebx, %ebx
    95c9:	31 c0	xorl	%eax, %eax
    95cb:	e8 00 00 00 00	callq	_IOLog
    95d0:	48 8b 05 71 1a 01 00	movq	0x11a71(%rip), %rax
    95d7:	48 8b 00	movq	(%rax), %rax
    95da:	48 3b 45 d8	cmpq	-0x28(%rbp), %rax
    95de:	75 12	jne	0x95f2
    95e0:	89 d8	movl	%ebx, %eax
    95e2:	48 81 c4 a0 00 00 00	addq	$0xa0, %rsp
    95e9:	5b	popq	%rbx
    95ea:	41 5c	popq	%r12
    95ec:	41 5e	popq	%r14
    95ee:	41 5f	popq	%r15
    95f0:	5d	popq	%rbp
    95f1:	c3	retq
    95f2:	e8 00 00 00 00	callq	___stack_chk_fail
    95f7:	66 0f 1f 84 00 00 00 00 00	nopw	(%rax,%rax)
