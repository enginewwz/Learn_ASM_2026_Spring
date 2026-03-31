	.file	"structure_transform_test.c"
	.text
	.globl	Complext_Struct_Transmit
	.type	Complext_Struct_Transmit, @function
Complext_Struct_Transmit:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -56(%rbp)		# save output struct addr
	movq	%rsi, -64(%rbp)		# save input struct addr
	movq	-64(%rbp), %rax
	movl	(%rax), %r11d		# int a
	movq	-64(%rbp), %rax
	movl	4(%rax), %r10d		# unsigned int b
	movq	-64(%rbp), %rax
	movzbl	8(%rax), %r9d		# char c
	movq	-64(%rbp), %rax
	movss	12(%rax), %xmm1		# float d
	movq	-64(%rbp), %rax
	movsd	16(%rax), %xmm0		# double e
	movq	-64(%rbp), %rax
	movq	24(%rax), %r8		# long long f
	movq	-64(%rbp), %rax
	movq	32(%rax), %rdi		# long long g
	movq	-64(%rbp), %rax
	movzwl	40(%rax), %esi		# short h
	movq	-64(%rbp), %rax
	movzwl	42(%rax), %ecx		# unsigned short i
	movq	-64(%rbp), %rax
	movzbl	44(%rax), %edx		# unsigned char j
	movq	-56(%rbp), %rax		# output struct addr
	movl	%r11d, (%rax)		# save int a
	movq	-56(%rbp), %rax
	movl	%r10d, 4(%rax)		# save unsigned int b
	movq	-56(%rbp), %rax			
	movq	-56(%rbp), %rax
	movss	%xmm1, 12(%rax)		# save float d
	movq	-56(%rbp), %rax
	movsd	%xmm0, 16(%rax)		# save double e
	movq	-56(%rbp), %rax
	movq	%r8, 24(%rax)		# save long long f
	movq	-56(%rbp), %rax
	movq	%rdi, 32(%rax)		# save long long g
	movq	-56(%rbp), %rax
	movw	%si, 40(%rax)		# save short h
	movq	-56(%rbp), %rax
	movw	%cx, 42(%rax)		# save unsigned short i
	movq	-56(%rbp), %rax
	movb	%dl, 44(%rax)		# save unsigned char j
	movq	-56(%rbp), %rax		# return output struct addr
	popq	%rbp
	ret
	.size	Complext_Struct_Transmit, .-Complext_Struct_Transmit
	.globl	main
	.type	main, @function
main:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp					# allocate space for local variables
	movq	%fs:40, %rax				# stack canary
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -112(%rbp)				# int a = 1
	movl	$2, -108(%rbp)				# unsigned int b = 2
	movb	$65, -104(%rbp)				# char c = 'A'
	movss	.LC0(%rip), %xmm0
	movss	%xmm0, -100(%rbp)			# float d transmit by xmm0
	movsd	.LC1(%rip), %xmm0
	movsd	%xmm0, -96(%rbp)			# double e transmit by xmm0
	movabsq	$123456789012345, %rax
	movq	%rax, -88(%rbp)				# long long f = 123456789012345
	movabsq	$987654321098765, %rax
	movq	%rax, -80(%rbp)				# long long g = 987654321098765
	movw	$42, -72(%rbp)				# short h = 42	
	movw	$-1, -70(%rbp)				# unsigned short i = -1
	movb	$90, -68(%rbp)				# unsigned char j = 'Z'
	leaq	-64(%rbp), %rax
	leaq	-112(%rbp), %rdx
	movq	%rdx, %rsi					# rsi = input structure address
	movq	%rax, %rdi					# rdi = output structure address
	call	Complext_Struct_Transmit
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx				# check stack canary
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 4
.LC0:
	.long	1078523331
	.align 8
.LC1:
	.long	-1783957616
	.long	1074118409
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
