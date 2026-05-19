	.file	"matrix_mul_c.c"
	.text
	.p2align 4
	.globl	matrix_mul_c_gcc
	.type	matrix_mul_c_gcc, @function
matrix_mul_c_gcc:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdi, %r9
	movq	%rsi, %rdi
	xorl	%r8d, %r8d
	movq	%rdx, %rsi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	leaq	67108864(%rdi), %rbx
.L2:
	movq	%r8, %r10
	movq	%rdi, %r11
	leaq	16384(%rsi), %r12
	movq	%rbx, %rcx
	salq	$14, %r10
	addq	%r9, %r10
.L4:
	movq	%r10, %rdx
	movq	%r11, %rax
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L3:
	vbroadcastss	(%rdx), %ymm0
	vmulps	(%rax), %ymm0, %ymm0
	addq	$16384, %rax
	addq	$4, %rdx
	cmpq	%rcx, %rax
	vaddps	%ymm0, %ymm1, %ymm1
	jne	.L3
	vmovups	%ymm1, (%rsi)
	addq	$32, %rsi
	addq	$32, %r11
	leaq	32(%rax), %rcx
	cmpq	%r12, %rsi
	jne	.L4
	addq	$1, %r8
	cmpq	$4096, %r8
	jne	.L2
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	matrix_mul_c_gcc, .-matrix_mul_c_gcc
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
