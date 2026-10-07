__ZN33AppleBCMWLANChipManagerPCIeBridge28setM2MResetOnSSResetDisabledEP27AppleBCMWLANChipManagerPCIeb:
    5c90:	55	pushq	%rbp
    5c91:	48 89 e5	movq	%rsp, %rbp
    5c94:	48 8b 05 b5 74 01 00	movq	__ZN21ClassInterceptorMakerI33AppleBCMWLANChipManagerPCIeBridgeE6bridgeE(%rip), %rax ## ClassInterceptorMaker<AppleBCMWLANChipManagerPCIeBridge>::bridge
    5c9b:	48 8b 80 38 03 00 00	movq	0x338(%rax), %rax
    5ca2:	48 85 c0	testq	%rax, %rax
    5ca5:	74 07	je	0x5cae
    5ca7:	40 0f b6 f6	movzbl	%sil, %esi
    5cab:	5d	popq	%rbp
    5cac:	ff e0	jmpq	*%rax
    5cae:	48 8b 47 18	movq	0x18(%rdi), %rax
    5cb2:	40 88 b0 cf 00 00 00	movb	%sil, 0xcf(%rax)
    5cb9:	5d	popq	%rbp
    5cba:	c3	retq
    5cbb:	0f 1f 44 00 00	nopl	(%rax,%rax)
