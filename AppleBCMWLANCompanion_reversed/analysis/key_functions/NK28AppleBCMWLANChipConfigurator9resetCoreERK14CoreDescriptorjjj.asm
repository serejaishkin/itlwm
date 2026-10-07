__ZNK28AppleBCMWLANChipConfigurator9resetCoreERK14CoreDescriptorjjj:
    9000:	55	pushq	%rbp
    9001:	48 89 e5	movq	%rsp, %rbp
    9004:	41 57	pushq	%r15
    9006:	41 56	pushq	%r14
    9008:	41 55	pushq	%r13
    900a:	41 54	pushq	%r12
    900c:	53	pushq	%rbx
    900d:	50	pushq	%rax
    900e:	49 89 f7	movq	%rsi, %r15
    9011:	48 89 fb	movq	%rdi, %rbx
    9014:	81 3e 12 08 00 00	cmpl	$0x812, (%rsi)
    901a:	44 89 45 d4	movl	%r8d, -0x2c(%rbp)
    901e:	0f 85 4b 01 00 00	jne	0x916f
    9024:	8b 83 c4 01 00 00	movl	0x1c4(%rbx), %eax
    902a:	48 85 c0	testq	%rax, %rax
    902d:	0f 84 3c 01 00 00	je	0x916f
    9033:	4c 8d a3 c4 00 00 00	leaq	0xc4(%rbx), %r12
    903a:	be 01 00 00 00	movl	$0x1, %esi
    903f:	eb 1e	jmp	0x905f
    9041:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    9050:	ff ce	decl	%esi
    9052:	49 83 c4 10	addq	$0x10, %r12
    9056:	48 ff c8	decq	%rax
    9059:	0f 84 10 01 00 00	je	0x916f
    905f:	41 81 3c 24 12 08 00 00	cmpl	$0x812, (%r12)
    9067:	75 e9	jne	0x9052
    9069:	85 f6	testl	%esi, %esi
    906b:	75 e3	jne	0x9050
    906d:	48 89 df	movq	%rbx, %rdi
    9070:	4c 89 fe	movq	%r15, %rsi
    9073:	41 89 d5	movl	%edx, %r13d
    9076:	41 89 ce	movl	%ecx, %r14d
    9079:	e8 c2 fd ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator11disableCoreERK14CoreDescriptorjj ## AppleBCMWLANChipConfigurator::disableCore(CoreDescriptor const&, unsigned int, unsigned int) const
    907e:	48 89 df	movq	%rbx, %rdi
    9081:	4c 89 e6	movq	%r12, %rsi
    9084:	44 89 ea	movl	%r13d, %edx
    9087:	44 89 f1	movl	%r14d, %ecx
    908a:	e8 b1 fd ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator11disableCoreERK14CoreDescriptorjj ## AppleBCMWLANChipConfigurator::disableCore(CoreDescriptor const&, unsigned int, unsigned int) const
    908f:	41 be 32 00 00 00	movl	$0x32, %r14d
    9095:	66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    90a0:	41 8b 57 0c	movl	0xc(%r15), %edx
    90a4:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    90a8:	be 80 00 00 00	movl	$0x80, %esi
    90ad:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    90b2:	48 8b 43 20	movq	0x20(%rbx), %rax
    90b6:	f7 80 00 08 00 00 01 00 00 00	testl	$0x1, 0x800(%rax)
    90c0:	74 47	je	0x9109
    90c2:	41 8b 57 0c	movl	0xc(%r15), %edx
    90c6:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    90ca:	be 80 00 00 00	movl	$0x80, %esi
    90cf:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    90d4:	48 8b 43 20	movq	0x20(%rbx), %rax
    90d8:	c7 80 00 08 00 00 00 00 00 00	movl	$0x0, 0x800(%rax)
    90e2:	bf 32 00 00 00	movl	$0x32, %edi
    90e7:	e8 00 00 00 00	callq	_IODelay
    90ec:	41 ff ce	decl	%r14d
    90ef:	75 af	jne	0x90a0
    90f1:	41 8b 17	movl	(%r15), %edx
    90f4:	48 8d 3d 9c db 00 00	leaq	0xdb9c(%rip), %rdi ## literal pool for: "bcmc: %s Warning: Core ID = 0x%x, Timed out waiting for the core to reset.\n"
    90fb:	48 8d 35 e1 db 00 00	leaq	0xdbe1(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::resetCorePrivate(const CoreDescriptor &) const"
    9102:	31 c0	xorl	%eax, %eax
    9104:	e8 00 00 00 00	callq	_IOLog
    9109:	41 be 32 00 00 00	movl	$0x32, %r14d
    910f:	90	nop
    9110:	41 8b 54 24 0c	movl	0xc(%r12), %edx
    9115:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9119:	be 80 00 00 00	movl	$0x80, %esi
    911e:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9123:	48 8b 43 20	movq	0x20(%rbx), %rax
    9127:	f7 80 00 08 00 00 01 00 00 00	testl	$0x1, 0x800(%rax)
    9131:	0f 84 64 01 00 00	je	0x929b
    9137:	41 8b 54 24 0c	movl	0xc(%r12), %edx
    913c:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9140:	be 80 00 00 00	movl	$0x80, %esi
    9145:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    914a:	48 8b 43 20	movq	0x20(%rbx), %rax
    914e:	c7 80 00 08 00 00 00 00 00 00	movl	$0x0, 0x800(%rax)
    9158:	bf 32 00 00 00	movl	$0x32, %edi
    915d:	e8 00 00 00 00	callq	_IODelay
    9162:	41 ff ce	decl	%r14d
    9165:	75 a9	jne	0x9110
    9167:	45 31 ed	xorl	%r13d, %r13d
    916a:	4d 89 e6	movq	%r12, %r14
    916d:	eb 78	jmp	0x91e7
    916f:	48 89 df	movq	%rbx, %rdi
    9172:	4c 89 fe	movq	%r15, %rsi
    9175:	e8 c6 fc ff ff	callq	__ZNK28AppleBCMWLANChipConfigurator11disableCoreERK14CoreDescriptorjj ## AppleBCMWLANChipConfigurator::disableCore(CoreDescriptor const&, unsigned int, unsigned int) const
    917a:	41 bc 32 00 00 00	movl	$0x32, %r12d
    9180:	45 31 f6	xorl	%r14d, %r14d
    9183:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    9190:	41 8b 57 0c	movl	0xc(%r15), %edx
    9194:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9198:	be 80 00 00 00	movl	$0x80, %esi
    919d:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    91a2:	48 8b 43 20	movq	0x20(%rbx), %rax
    91a6:	f7 80 00 08 00 00 01 00 00 00	testl	$0x1, 0x800(%rax)
    91b0:	74 53	je	0x9205
    91b2:	41 8b 57 0c	movl	0xc(%r15), %edx
    91b6:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    91ba:	be 80 00 00 00	movl	$0x80, %esi
    91bf:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    91c4:	48 8b 43 20	movq	0x20(%rbx), %rax
    91c8:	c7 80 00 08 00 00 00 00 00 00	movl	$0x0, 0x800(%rax)
    91d2:	bf 32 00 00 00	movl	$0x32, %edi
    91d7:	e8 00 00 00 00	callq	_IODelay
    91dc:	41 ff cc	decl	%r12d
    91df:	75 af	jne	0x9190
    91e1:	41 b5 01	movb	$0x1, %r13b
    91e4:	4d 89 fc	movq	%r15, %r12
    91e7:	41 8b 14 24	movl	(%r12), %edx
    91eb:	48 8d 3d a5 da 00 00	leaq	0xdaa5(%rip), %rdi ## literal pool for: "bcmc: %s Warning: Core ID = 0x%x, Timed out waiting for the core to reset.\n"
    91f2:	48 8d 35 ea da 00 00	leaq	0xdaea(%rip), %rsi ## literal pool for: "void AppleBCMWLANChipConfigurator::resetCorePrivate(const CoreDescriptor &) const"
    91f9:	31 c0	xorl	%eax, %eax
    91fb:	e8 00 00 00 00	callq	_IOLog
    9200:	4d 89 f4	movq	%r14, %r12
    9203:	eb 06	jmp	0x920b
    9205:	41 b5 01	movb	$0x1, %r13b
    9208:	45 31 e4	xorl	%r12d, %r12d
    920b:	44 8b 75 d4	movl	-0x2c(%rbp), %r14d
    920f:	41 83 ce 01	orl	$0x1, %r14d
    9213:	41 8b 57 0c	movl	0xc(%r15), %edx
    9217:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    921b:	be 80 00 00 00	movl	$0x80, %esi
    9220:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9225:	48 8b 43 20	movq	0x20(%rbx), %rax
    9229:	44 89 b0 08 04 00 00	movl	%r14d, 0x408(%rax)
    9230:	41 8b 57 0c	movl	0xc(%r15), %edx
    9234:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9238:	be 80 00 00 00	movl	$0x80, %esi
    923d:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9242:	48 8b 43 20	movq	0x20(%rbx), %rax
    9246:	8b 80 08 04 00 00	movl	0x408(%rax), %eax
    924c:	45 84 ed	testb	%r13b, %r13b
    924f:	75 3b	jne	0x928c
    9251:	41 8b 54 24 0c	movl	0xc(%r12), %edx
    9256:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    925a:	be 80 00 00 00	movl	$0x80, %esi
    925f:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9264:	48 8b 43 20	movq	0x20(%rbx), %rax
    9268:	44 89 b0 08 04 00 00	movl	%r14d, 0x408(%rax)
    926f:	41 8b 54 24 0c	movl	0xc(%r12), %edx
    9274:	48 8b 7b 10	movq	0x10(%rbx), %rdi
    9278:	be 80 00 00 00	movl	$0x80, %esi
    927d:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9282:	48 8b 43 20	movq	0x20(%rbx), %rax
    9286:	8b 80 08 04 00 00	movl	0x408(%rax), %eax
    928c:	48 83 c4 08	addq	$0x8, %rsp
    9290:	5b	popq	%rbx
    9291:	41 5c	popq	%r12
    9293:	41 5d	popq	%r13
    9295:	41 5e	popq	%r14
    9297:	41 5f	popq	%r15
    9299:	5d	popq	%rbp
    929a:	c3	retq
    929b:	45 31 ed	xorl	%r13d, %r13d
    929e:	e9 68 ff ff ff	jmp	0x920b
    92a3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
