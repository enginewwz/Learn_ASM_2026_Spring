	.file	"matrix_transpose_icx.c"
	.text
	.globl	matrix_transpose_icx            # -- Begin function matrix_transpose_icx
	.p2align	4
	.type	matrix_transpose_icx,@function
matrix_transpose_icx:                   # 
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsi, %r8
	movq	%rdi, %rcx
	movq	$4095, (%rsp)                   # imm = 0xFFF
	movl	$.L.kmpc_loc.0.0.4, %edi
	movl	$matrix_transpose_icx.extracted, %edx
	movl	$4, %esi
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	callq	__kmpc_fork_call@PLT
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	matrix_transpose_icx, .Lfunc_end0-matrix_transpose_icx
	.cfi_endproc
                                        # -- End function
	.p2align	4                               # -- Begin function matrix_transpose_icx.extracted
	.type	matrix_transpose_icx.extracted,@function
matrix_transpose_icx.extracted:         # 
	.cfi_startproc
# %bb.0:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rcx, %r14
	movq	%rdx, %r15
	movl	$0, 12(%rsp)
	movl	(%rdi), %ebx
	movl	$0, 4(%rsp)
	movl	$4095, (%rsp)                   # imm = 0xFFF
	movl	$1, 8(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	16(%rsp), %rax
	leaq	20(%rsp), %rcx
	leaq	12(%rsp), %r8
	leaq	8(%rsp), %r9
	movl	$.L.kmpc_loc.0.0, %edi
	movl	%ebx, %esi
	movl	$34, %edx
	pushq	$1
	.cfi_adjust_cfa_offset 8
	pushq	$1
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_for_static_init_4@PLT
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	movl	4(%rsp), %edx
	movl	(%rsp), %eax
	cmpl	%edx, %eax
	jb	.LBB1_5
# %bb.1:
	subl	%edx, %eax
	movl	%edx, %ecx
	shll	$14, %ecx
	leaq	28(%rcx,%r15), %rcx
	leaq	114688(%r14,%rdx,4), %rdx
	xorl	%esi, %esi
	.p2align	4
.LBB1_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	movq	%rdx, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB1_3:                                #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	leaq	-28(%rcx,%r8), %r9
	vmovss	(%r9), %xmm0                    # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -114688(%rdi)
	vmovss	4(%r9), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -98304(%rdi)
	vmovss	8(%r9), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -81920(%rdi)
	vmovss	12(%r9), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -65536(%rdi)
	vmovss	16(%r9), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -49152(%rdi)
	vmovss	20(%r9), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -32768(%rdi)
	vmovss	24(%r9), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, -16384(%rdi)
	vmovss	28(%r9), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, (%rdi)
	addq	$32, %r8
	addq	$131072, %rdi                   # imm = 0x20000
	cmpq	$16384, %r8                     # imm = 0x4000
	jne	.LBB1_3
# %bb.4:                                #   in Loop: Header=BB1_2 Depth=1
	addq	$16384, %rcx                    # imm = 0x4000
	addq	$4, %rdx
	cmpq	%rax, %rsi
	leaq	1(%rsi), %rsi
	jne	.LBB1_2
.LBB1_5:
	movl	$.L.kmpc_loc.0.0.2, %edi
	movl	%ebx, %esi
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	__kmpc_for_static_fini@PLT      # TAILCALL
.Lfunc_end1:
	.size	matrix_transpose_icx.extracted, .Lfunc_end1-matrix_transpose_icx.extracted
	.cfi_endproc
                                        # -- End function
	.type	.L.kmpc_loc.0.0,@object         # 
	.data
	.p2align	4, 0x0
.L.kmpc_loc.0.0:
	.long	0                               # 0x0
	.long	838861314                       # 0x32000202
	.long	0                               # 0x0
	.long	0                               # 0x0
	.quad	.L.source.0.0.3
	.size	.L.kmpc_loc.0.0, 24

	.type	.L.kmpc_loc.0.0.2,@object       # 
	.p2align	4, 0x0
.L.kmpc_loc.0.0.2:
	.long	0                               # 0x0
	.long	838861314                       # 0x32000202
	.long	0                               # 0x0
	.long	0                               # 0x0
	.quad	.L.source.0.0.3
	.size	.L.kmpc_loc.0.0.2, 24

	.type	.L.source.0.0.3,@object         # 
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.source.0.0.3:
	.ascii	";unknown;unknown;0;0;;"
	.size	.L.source.0.0.3, 22

	.type	.L.kmpc_loc.0.0.4,@object       # 
	.data
	.p2align	4, 0x0
.L.kmpc_loc.0.0.4:
	.long	0                               # 0x0
	.long	838860802                       # 0x32000002
	.long	0                               # 0x0
	.long	0                               # 0x0
	.quad	.L.source.0.0.3
	.size	.L.kmpc_loc.0.0.4, 24

	.ident	"Intel(R) oneAPI DPC++/C++ Compiler 2026.0.0 (2026.0.0.20260331)"
	.section	".note.GNU-stack","",@progbits
