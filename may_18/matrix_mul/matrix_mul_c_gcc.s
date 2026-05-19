	.file	"matrix_mul_c.c"
	.text
	.p2align 4
	.globl	matrix_mul_c
	.type	matrix_mul_c, @function
matrix_mul_c:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %r8
	movq	%rdi, %r11
	movq	%rdx, %rsi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	xorl	%r9d, %r9d
	leaq	67108864(%r8), %rbp
.L2:
	movq	%r9, %r10
	movq	%r8, %rdi
	leaq	16384(%rsi), %rbx
	movq	%rbp, %rcx
	salq	$14, %r10
	addq	%r11, %r10
.L4:
	movq	%r10, %rdx
	movq	%rdi, %rax
	pxor	%xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L3:
	movss	(%rdx), %xmm0
	movups	(%rax), %xmm2
	addq	$16384, %rax
	addq	$4, %rdx
	shufps	$0, %xmm0, %xmm0
	mulps	%xmm2, %xmm0
	addps	%xmm0, %xmm1
	cmpq	%rcx, %rax
	jne	.L3
	movups	%xmm1, (%rsi)
	addq	$16, %rsi
	addq	$16, %rdi
	leaq	16(%rax), %rcx
	cmpq	%rbx, %rsi
	jne	.L4
	addq	$1, %r9
	cmpq	$4096, %r9
	jne	.L2
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
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
