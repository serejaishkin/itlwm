__ZNK28AppleBCMWLANChipConfigurator15requestFirmwareEv:
    9600:	55	pushq	%rbp
    9601:	48 89 e5	movq	%rsp, %rbp
    9604:	41 56	pushq	%r14
    9606:	53	pushq	%rbx
    9607:	48 83 ec 10	subq	$0x10, %rsp
    960b:	48 89 fb	movq	%rdi, %rbx
    960e:	48 8b 7f 50	movq	0x50(%rdi), %rdi
    9612:	48 85 ff	testq	%rdi, %rdi
    9615:	74 41	je	0x9658
    9617:	48 8b 07	movq	(%rdi), %rax
    961a:	ff 90 78 01 00 00	callq	*0x178(%rax)
    9620:	48 c7 45 e8 00 00 00 00	movq	$0x0, -0x18(%rbp)
    9628:	48 8d 75 e8	leaq	-0x18(%rbp), %rsi
    962c:	48 89 c7	movq	%rax, %rdi
    962f:	e8 00 00 00 00	callq	__ZN6FileIO16readFileToBufferEPKcRm
    9634:	48 85 c0	testq	%rax, %rax
    9637:	74 28	je	0x9661
    9639:	48 8b 55 e8	movq	-0x18(%rbp), %rdx
    963d:	48 89 df	movq	%rbx, %rdi
    9640:	49 89 c6	movq	%rax, %r14
    9643:	48 89 c6	movq	%rax, %rsi
    9646:	e8 25 fe ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator14verifyFirmwareEPKhy ## AppleBCMWLANChipConfigurator::verifyFirmware(unsigned char const*, unsigned long long) const
    964b:	84 c0	testb	%al, %al
    964d:	74 1b	je	0x966a
    964f:	48 8b 5d e8	movq	-0x18(%rbp), %rbx
    9653:	4c 89 f0	movq	%r14, %rax
    9656:	eb 2b	jmp	0x9683
    9658:	48 8d 3d f7 d9 00 00	leaq	0xd9f7(%rip), %rdi ## literal pool for: "bcmc: %s Error: Users did not specify the firmware path.\n"
    965f:	eb 10	jmp	0x9671
    9661:	48 8d 3d 7f da 00 00	leaq	0xda7f(%rip), %rdi ## literal pool for: "bcmc: %s Error: Failed to read the firmware from the filesystem.\n"
    9668:	eb 07	jmp	0x9671
    966a:	48 8d 3d b8 da 00 00	leaq	0xdab8(%rip), %rdi ## literal pool for: "bcmc: %s Error: The firmware is invalid because its SHA-256 checksum does not match the user-specified one.\n"
    9671:	48 8d 35 18 da 00 00	leaq	0xda18(%rip), %rsi ## literal pool for: "Pair<const UInt8 *, IOByteCount> AppleBCMWLANChipConfigurator::requestFirmware() const"
    9678:	31 db	xorl	%ebx, %ebx
    967a:	31 c0	xorl	%eax, %eax
    967c:	e8 00 00 00 00	callq	_IOLog
    9681:	31 c0	xorl	%eax, %eax
    9683:	48 89 da	movq	%rbx, %rdx
    9686:	48 83 c4 10	addq	$0x10, %rsp
    968a:	5b	popq	%rbx
    968b:	41 5e	popq	%r14
    968d:	5d	popq	%rbp
    968e:	c3	retq
    968f:	90	nop
