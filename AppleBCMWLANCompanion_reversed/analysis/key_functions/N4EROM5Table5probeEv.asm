__ZN4EROM5Table5probeEv:
    b570:	55	pushq	%rbp
    b571:	48 89 e5	movq	%rsp, %rbp
    b574:	41 57	pushq	%r15
    b576:	41 56	pushq	%r14
    b578:	41 55	pushq	%r13
    b57a:	41 54	pushq	%r12
    b57c:	53	pushq	%rbx
    b57d:	50	pushq	%rax
    b57e:	49 89 ff	movq	%rdi, %r15
    b581:	bf 00 01 00 00	movl	$0x100, %edi
    b586:	e8 00 00 00 00	callq	_IOMallocZero
    b58b:	48 89 c3	movq	%rax, %rbx
    b58e:	45 31 f6	xorl	%r14d, %r14d
    b591:	48 85 c0	testq	%rax, %rax
    b594:	75 1f	jne	0xb5b5
    b596:	48 89 d8	movq	%rbx, %rax
    b599:	44 89 f2	movl	%r14d, %edx
    b59c:	48 83 c4 08	addq	$0x8, %rsp
    b5a0:	5b	popq	%rbx
    b5a1:	41 5c	popq	%r12
    b5a3:	41 5d	popq	%r13
    b5a5:	41 5e	popq	%r14
    b5a7:	41 5f	popq	%r15
    b5a9:	5d	popq	%rbp
    b5aa:	c3	retq
    b5ab:	0f 1f 44 00 00	nopl	(%rax,%rax)
    b5b0:	83 f9 03	cmpl	$0x3, %ecx
    b5b3:	74 e1	je	0xb596
    b5b5:	41 8b 47 0c	movl	0xc(%r15), %eax
    b5b9:	41 3b 47 08	cmpl	0x8(%r15), %eax
    b5bd:	73 d7	jae	0xb596
    b5bf:	49 8b 17	movq	(%r15), %rdx
    b5c2:	8d 48 01	leal	0x1(%rax), %ecx
    b5c5:	41 89 4f 0c	movl	%ecx, 0xc(%r15)
    b5c9:	44 8b 24 82	movl	(%rdx,%rax,4), %r12d
    b5cd:	b9 02 00 00 00	movl	$0x2, %ecx
    b5d2:	41 f6 c4 01	testb	$0x1, %r12b
    b5d6:	74 d8	je	0xb5b0
    b5d8:	41 83 fc 0f	cmpl	$0xf, %r12d
    b5dc:	74 b8	je	0xb596
    b5de:	41 f6 c4 0e	testb	$0xe, %r12b
    b5e2:	75 cc	jne	0xb5b0
    b5e4:	8d 70 02	leal	0x2(%rax), %esi
    b5e7:	41 89 77 0c	movl	%esi, 0xc(%r15)
    b5eb:	44 8b 6c 82 04	movl	0x4(%rdx,%rax,4), %r13d
    b5f0:	41 f6 c5 0e	testb	$0xe, %r13b
    b5f4:	75 a0	jne	0xb596
    b5f6:	41 c1 ec 08	shrl	$0x8, %r12d
    b5fa:	41 81 e4 ff 0f 00 00	andl	$0xfff, %r12d
    b601:	44 89 e8	movl	%r13d, %eax
    b604:	c1 e8 0e	shrl	$0xe, %eax
    b607:	44 89 ea	movl	%r13d, %edx
    b60a:	c1 ea 13	shrl	$0x13, %edx
    b60d:	09 c2	orl	%eax, %edx
    b60f:	f6 c2 1f	testb	$0x1f, %dl
    b612:	74 66	je	0xb67a
    b614:	c7 45 d0 00 00 00 00	movl	$0x0, -0x30(%rbp)
    b61b:	c7 45 d4 00 00 00 00	movl	$0x0, -0x2c(%rbp)
    b622:	4c 89 ff	movq	%r15, %rdi
    b625:	48 8d 75 d0	leaq	-0x30(%rbp), %rsi
    b629:	48 8d 55 d4	leaq	-0x2c(%rbp), %rdx
    b62d:	e8 de fc ff ff	callq	__ZN4EROM5Table17findCoreAddressesERjS1_ ## EROM::Table::findCoreAddresses(unsigned int&, unsigned int&)
    b632:	b9 02 00 00 00	movl	$0x2, %ecx
    b637:	84 c0	testb	%al, %al
    b639:	0f 84 71 ff ff ff	je	0xb5b0
    b63f:	b9 03 00 00 00	movl	$0x3, %ecx
    b644:	41 83 fe 0f	cmpl	$0xf, %r14d
    b648:	0f 87 62 ff ff ff	ja	0xb5b0
    b64e:	41 c1 ed 18	shrl	$0x18, %r13d
    b652:	8b 45 d0	movl	-0x30(%rbp), %eax
    b655:	8b 4d d4	movl	-0x2c(%rbp), %ecx
    b658:	44 89 f2	movl	%r14d, %edx
    b65b:	41 ff c6	incl	%r14d
    b65e:	48 c1 e2 04	shlq	$0x4, %rdx
    b662:	44 89 24 13	movl	%r12d, (%rbx,%rdx)
    b666:	44 89 6c 13 04	movl	%r13d, 0x4(%rbx,%rdx)
    b66b:	89 44 13 08	movl	%eax, 0x8(%rbx,%rdx)
    b66f:	89 4c 13 0c	movl	%ecx, 0xc(%rbx,%rdx)
    b673:	31 c9	xorl	%ecx, %ecx
    b675:	e9 36 ff ff ff	jmp	0xb5b0
    b67a:	41 81 fc 40 08 00 00	cmpl	$0x840, %r12d
    b681:	74 91	je	0xb614
    b683:	41 81 fc 27 08 00 00	cmpl	$0x827, %r12d
    b68a:	74 88	je	0xb614
    b68c:	e9 1f ff ff ff	jmp	0xb5b0
    b691:	90	nop
    b692:	90	nop
    b693:	90	nop
    b694:	90	nop
    b695:	90	nop
    b696:	90	nop
    b697:	90	nop
    b698:	90	nop
    b699:	90	nop
    b69a:	90	nop
    b69b:	90	nop
    b69c:	90	nop
    b69d:	90	nop
    b69e:	90	nop
    b69f:	90	nop
