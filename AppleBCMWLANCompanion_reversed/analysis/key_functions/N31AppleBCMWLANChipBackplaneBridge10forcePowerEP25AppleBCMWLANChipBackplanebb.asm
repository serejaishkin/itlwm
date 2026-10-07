__ZN31AppleBCMWLANChipBackplaneBridge10forcePowerEP25AppleBCMWLANChipBackplanebb:
    3a50:	55	pushq	%rbp
    3a51:	48 89 e5	movq	%rsp, %rbp
    3a54:	48 8b 05 dd 96 01 00	movq	__ZN21ClassInterceptorMakerI31AppleBCMWLANChipBackplaneBridgeE6bridgeE(%rip), %rax ## ClassInterceptorMaker<AppleBCMWLANChipBackplaneBridge>::bridge
    3a5b:	48 8b 40 18	movq	0x18(%rax), %rax
    3a5f:	5d	popq	%rbp
    3a60:	ff e0	jmpq	*%rax
    3a62:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
