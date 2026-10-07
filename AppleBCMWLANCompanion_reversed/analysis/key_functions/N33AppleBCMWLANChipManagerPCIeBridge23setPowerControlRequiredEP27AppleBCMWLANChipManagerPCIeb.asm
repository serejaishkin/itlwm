__ZN33AppleBCMWLANChipManagerPCIeBridge23setPowerControlRequiredEP27AppleBCMWLANChipManagerPCIeb:
    5cc0:	55	pushq	%rbp
    5cc1:	48 89 e5	movq	%rsp, %rbp
    5cc4:	48 8b 05 85 74 01 00	movq	__ZN21ClassInterceptorMakerI33AppleBCMWLANChipManagerPCIeBridgeE6bridgeE(%rip), %rax ## ClassInterceptorMaker<AppleBCMWLANChipManagerPCIeBridge>::bridge
    5ccb:	48 8b 80 40 03 00 00	movq	0x340(%rax), %rax
    5cd2:	48 85 c0	testq	%rax, %rax
    5cd5:	74 07	je	0x5cde
    5cd7:	40 0f b6 f6	movzbl	%sil, %esi
    5cdb:	5d	popq	%rbp
    5cdc:	ff e0	jmpq	*%rax
    5cde:	48 8b 47 18	movq	0x18(%rdi), %rax
    5ce2:	40 88 b0 d0 00 00 00	movb	%sil, 0xd0(%rax)
    5ce9:	5d	popq	%rbp
    5cea:	c3	retq
    5ceb:	0f 1f 44 00 00	nopl	(%rax,%rax)
