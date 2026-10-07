__ZNK28AppleBCMWLANChipConfigurator18enterDownloadStateEv:
    9690:	55	pushq	%rbp
    9691:	48 89 e5	movq	%rsp, %rbp
    9694:	41 56	pushq	%r14
    9696:	53	pushq	%rbx
    9697:	81 bf b0 00 00 00 52 aa 00 00	cmpl	$0xaa52, 0xb0(%rdi)
    96a1:	0f 85 bd 00 00 00	jne	0x9764
    96a7:	8b 87 c4 01 00 00	movl	0x1c4(%rdi), %eax
    96ad:	48 85 c0	testq	%rax, %rax
    96b0:	74 24	je	0x96d6
    96b2:	48 c1 e0 04	shlq	$0x4, %rax
    96b6:	31 db	xorl	%ebx, %ebx
    96b8:	0f 1f 84 00 00 00 00 00	nopl	(%rax,%rax)
    96c0:	81 bc 1f c4 00 00 00 3e 08 00 00	cmpl	$0x83e, 0xc4(%rdi,%rbx)
    96cb:	74 0e	je	0x96db
    96cd:	48 83 c3 10	addq	$0x10, %rbx
    96d1:	48 39 d8	cmpq	%rbx, %rax
    96d4:	75 ea	jne	0x96c0
    96d6:	e8 05 9c 00 00	callq	__ZNK28AppleBCMWLANChipConfigurator18enterDownloadStateEv.cold.1 ## AppleBCMWLANChipConfigurator::enterDownloadState() const (.cold.1)
    96db:	8b 94 1f cc 00 00 00	movl	0xcc(%rdi,%rbx), %edx
    96e2:	48 8b 47 10	movq	0x10(%rdi), %rax
    96e6:	be 80 00 00 00	movl	$0x80, %esi
    96eb:	49 89 fe	movq	%rdi, %r14
    96ee:	48 89 c7	movq	%rax, %rdi
    96f1:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    96f6:	49 8b 46 20	movq	0x20(%r14), %rax
    96fa:	c7 40 40 05 00 00 00	movl	$0x5, 0x40(%rax)
    9701:	41 8b 94 1e cc 00 00 00	movl	0xcc(%r14,%rbx), %edx
    9709:	49 8b 7e 10	movq	0x10(%r14), %rdi
    970d:	be 80 00 00 00	movl	$0x80, %esi
    9712:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9717:	49 8b 46 20	movq	0x20(%r14), %rax
    971b:	c7 40 4c 00 00 00 00	movl	$0x0, 0x4c(%rax)
    9722:	41 8b 94 1e cc 00 00 00	movl	0xcc(%r14,%rbx), %edx
    972a:	49 8b 7e 10	movq	0x10(%r14), %rdi
    972e:	be 80 00 00 00	movl	$0x80, %esi
    9733:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9738:	49 8b 46 20	movq	0x20(%r14), %rax
    973c:	c7 40 40 07 00 00 00	movl	$0x7, 0x40(%rax)
    9743:	41 8b 94 1e cc 00 00 00	movl	0xcc(%r14,%rbx), %edx
    974b:	49 8b 7e 10	movq	0x10(%r14), %rdi
    974f:	be 80 00 00 00	movl	$0x80, %esi
    9754:	e8 00 00 00 00	callq	__ZN11IOPCIDevice21extendedConfigWrite32Eyj
    9759:	49 8b 46 20	movq	0x20(%r14), %rax
    975d:	c7 40 4c 00 00 00 00	movl	$0x0, 0x4c(%rax)
    9764:	5b	popq	%rbx
    9765:	41 5e	popq	%r14
    9767:	5d	popq	%rbp
    9768:	c3	retq
    9769:	0f 1f 80 00 00 00 00	nopl	(%rax)
