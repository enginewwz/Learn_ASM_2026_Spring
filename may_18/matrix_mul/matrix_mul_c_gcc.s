	.file	"matrix_mul_c.c"
	.text
	.p2align 4
	.globl	matrix_mul_c
	.type	matrix_mul_c, @function
matrix_mul_c:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %r11
	movq	%rdx, %r9
	xorl	%r10d, %r10d
	leaq	67108864(%rsi), %rbx
.L2:
	movq	%rbx, %rsi
	leaq	(%r11,%r10,4), %r8
	movq	%r9, %rcx
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L4:
	movl	$0x00000000, (%rcx)
	leaq	-67108864(%rsi), %rax
	movq	%r8, %rdx
	pxor	%xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L3:
	movss	(%rdx), %xmm0
	mulss	(%rax), %xmm0
	addq	$16384, %rax
	addq	$4, %rdx
	addss	%xmm0, %xmm1
	movss	%xmm1, (%rcx)
	cmpq	%rsi, %rax
	jne	.L3
	addl	$1, %edi
	addq	$4, %rcx
	leaq	4(%rax), %rsi
	cmpl	$4096, %edi
	jne	.L4
	addq	$4096, %r10
	addq	$16384, %r9
	cmpq	$16777216, %r10
	jne	.L2
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE0:
	.size	matrix_mul_c, .-matrix_mul_c
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
