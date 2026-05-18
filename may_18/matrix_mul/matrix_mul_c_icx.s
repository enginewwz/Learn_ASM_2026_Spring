	.file	"matrix_mul_c.c"
	.text
	.globl	matrix_mul_c                    # -- Begin function matrix_mul_c
	.p2align	4
	.type	matrix_mul_c,@function
matrix_mul_c:                           # 
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$232, %rsp
	.cfi_def_cfa_offset 288
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdx, %rbx
	movq	%rsi, %r14
	movq	%rdi, %r15
	xorl	%r12d, %r12d
	movl	$67108864, %edx                 # imm = 0x4000000
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_intel_fast_memset@PLT
	.p2align	4
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%r12, 8(%rsp)                   # 8-byte Spill
	shlq	$18, %r12
	movq	%r12, (%rsp)                    # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4
.LBB0_2:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rax, %rdx
	shlq	$6, %rdx
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	shlq	$18, %rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	addq	(%rsp), %rdx                    # 8-byte Folded Reload
	xorl	%edi, %edi
	.p2align	4
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rdi, %r8
	shlq	$6, %r8
	movq	(%rsp), %rax                    # 8-byte Reload
	leaq	(%rax,%r8), %r9
	addq	24(%rsp), %r8                   # 8-byte Folded Reload
	xorl	%r10d, %r10d
	.p2align	4
.LBB0_4:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%r10, %r11
	shlq	$14, %r11
	leaq	(%rdx,%r11), %r13
	addq	%r9, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB0_5:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB0_6 Depth 6
	leaq	(%r13,%r12,4), %rax
	movq	%r12, %rbp
	shlq	$14, %rbp
	addq	%r8, %rbp
	leaq	(%r15,%rax,4), %rax
	vbroadcastss	(%rax), %ymm0
	vmovups	%ymm0, 192(%rsp)                # 32-byte Spill
	vbroadcastss	16384(%rax), %ymm0
	vmovups	%ymm0, 160(%rsp)                # 32-byte Spill
	vbroadcastss	32768(%rax), %ymm0
	vmovups	%ymm0, 128(%rsp)                # 32-byte Spill
	vbroadcastss	49152(%rax), %ymm0
	vmovups	%ymm0, 96(%rsp)                 # 32-byte Spill
	vbroadcastss	4(%rax), %ymm0
	vmovups	%ymm0, 64(%rsp)                 # 32-byte Spill
	vbroadcastss	16388(%rax), %ymm0
	vmovups	%ymm0, 32(%rsp)                 # 32-byte Spill
	vbroadcastss	32772(%rax), %ymm6
	vbroadcastss	49156(%rax), %ymm7
	vbroadcastss	8(%rax), %ymm8
	vbroadcastss	16392(%rax), %ymm9
	vbroadcastss	32776(%rax), %ymm10
	vbroadcastss	49160(%rax), %ymm11
	vbroadcastss	12(%rax), %ymm12
	vbroadcastss	16396(%rax), %ymm13
	vbroadcastss	32780(%rax), %ymm14
	vbroadcastss	49164(%rax), %ymm15
	xorl	%ecx, %ecx
	.p2align	4
.LBB0_6:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        # =>          This Inner Loop Header: Depth=6
	leaq	(%r11,%rcx), %rax
	leaq	(%rbp,%rcx), %rsi
	vmovups	(%r14,%rsi,4), %ymm0
	leaq	(%rbx,%rax,4), %rax
	vmovups	(%rax), %ymm3
	vfmadd231ps	192(%rsp), %ymm0, %ymm3 # 32-byte Folded Reload
                                        # ymm3 = (ymm0 * mem) + ymm3
	vmovups	16384(%rax), %ymm2
	vfmadd231ps	160(%rsp), %ymm0, %ymm2 # 32-byte Folded Reload
                                        # ymm2 = (ymm0 * mem) + ymm2
	vmovups	32768(%rax), %ymm1
	vfmadd231ps	128(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
                                        # ymm1 = (ymm0 * mem) + ymm1
	vmovups	96(%rsp), %ymm4                 # 32-byte Reload
	vfmadd213ps	49152(%rax), %ymm4, %ymm0 # ymm0 = (ymm4 * ymm0) + mem
	vmovups	16384(%r14,%rsi,4), %ymm4
	vfmadd231ps	64(%rsp), %ymm4, %ymm3  # 32-byte Folded Reload
                                        # ymm3 = (ymm4 * mem) + ymm3
	vfmadd231ps	32(%rsp), %ymm4, %ymm2  # 32-byte Folded Reload
                                        # ymm2 = (ymm4 * mem) + ymm2
	vfmadd231ps	%ymm6, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm6) + ymm1
	vfmadd231ps	%ymm4, %ymm7, %ymm0     # ymm0 = (ymm7 * ymm4) + ymm0
	vmovups	32768(%r14,%rsi,4), %ymm4
	vfmadd231ps	%ymm8, %ymm4, %ymm3     # ymm3 = (ymm4 * ymm8) + ymm3
	vmovups	49152(%r14,%rsi,4), %ymm5
	vfmadd231ps	%ymm12, %ymm5, %ymm3    # ymm3 = (ymm5 * ymm12) + ymm3
	vmovups	%ymm3, (%rax)
	vfmadd231ps	%ymm9, %ymm4, %ymm2     # ymm2 = (ymm4 * ymm9) + ymm2
	vfmadd231ps	%ymm13, %ymm5, %ymm2    # ymm2 = (ymm5 * ymm13) + ymm2
	vmovups	%ymm2, 16384(%rax)
	vfmadd231ps	%ymm10, %ymm4, %ymm1    # ymm1 = (ymm4 * ymm10) + ymm1
	vfmadd231ps	%ymm14, %ymm5, %ymm1    # ymm1 = (ymm5 * ymm14) + ymm1
	vmovups	%ymm1, 32768(%rax)
	vfmadd231ps	%ymm4, %ymm11, %ymm0    # ymm0 = (ymm11 * ymm4) + ymm0
	vfmadd231ps	%ymm5, %ymm15, %ymm0    # ymm0 = (ymm15 * ymm5) + ymm0
	vmovups	%ymm0, 49152(%rax)
	cmpq	$56, %rcx
	leaq	8(%rcx), %rcx
	jb	.LBB0_6
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=5
	cmpq	$15, %r12
	leaq	1(%r12), %r12
	jne	.LBB0_5
# %bb.8:                                #   in Loop: Header=BB0_4 Depth=4
	cmpq	$15, %r10
	leaq	1(%r10), %r10
	jne	.LBB0_4
# %bb.9:                                #   in Loop: Header=BB0_3 Depth=3
	cmpq	$63, %rdi
	leaq	1(%rdi), %rdi
	jne	.LBB0_3
# %bb.10:                               #   in Loop: Header=BB0_2 Depth=2
	movq	16(%rsp), %rax                  # 8-byte Reload
	cmpq	$63, %rax
	leaq	1(%rax), %rax
	jne	.LBB0_2
# %bb.11:                               #   in Loop: Header=BB0_1 Depth=1
	movq	8(%rsp), %r12                   # 8-byte Reload
	cmpq	$63, %r12
	leaq	1(%r12), %r12
	jne	.LBB0_1
# %bb.12:
	addq	$232, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	matrix_mul_c, .Lfunc_end0-matrix_mul_c
	.cfi_endproc
                                        # -- End function
	.ident	"Intel(R) oneAPI DPC++/C++ Compiler 2026.0.0 (2026.0.0.20260331)"
	.section	".note.GNU-stack","",@progbits
