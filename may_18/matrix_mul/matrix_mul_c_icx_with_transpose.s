	.file	"matrix_mul_c_with_transpose.c"
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
	subq	$520, %rsp                      # imm = 0x208
	.cfi_def_cfa_offset 576
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdx, %rbx
	movq	%rsi, %r12
	movq	%rdi, 168(%rsp)                 # 8-byte Spill
	leaq	256(%rsp), %rdi
	movl	$32, %esi
	movl	$67108864, %edx                 # imm = 0x4000000
	callq	posix_memalign
	xorl	%r14d, %r14d
	testl	%eax, %eax
	movq	256(%rsp), %rbp
	movl	$0, %esi
	cmoveq	%rbp, %rsi
	movq	%r12, %rdi
	movq	%rsi, 16(%rsp)                  # 8-byte Spill
	callq	matrix_transpose_avx2
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
	movq	%r14, 24(%rsp)                  # 8-byte Spill
	shlq	$18, %r14
	leaq	8(%r14), %rax
	movq	%rax, 88(%rsp)                  # 8-byte Spill
	leaq	16(%r14), %rax
	movq	%rax, 80(%rsp)                  # 8-byte Spill
	leaq	24(%r14), %rax
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	leaq	32(%r14), %rax
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	leaq	40(%r14), %rax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	leaq	48(%r14), %rax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	movq	%r14, 8(%rsp)                   # 8-byte Spill
	leaq	56(%r14), %rax
	movq	%rax, 40(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4
.LBB0_2:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rax, %rcx
	shlq	$6, %rcx
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	shlq	$18, %rax
	addq	8(%rsp), %rcx                   # 8-byte Folded Reload
	movq	%rcx, 176(%rsp)                 # 8-byte Spill
	leaq	8(%rax), %rcx
	movq	%rcx, 144(%rsp)                 # 8-byte Spill
	leaq	16(%rax), %rcx
	movq	%rcx, 136(%rsp)                 # 8-byte Spill
	leaq	24(%rax), %rcx
	movq	%rcx, 128(%rsp)                 # 8-byte Spill
	leaq	32(%rax), %rcx
	movq	%rcx, 120(%rsp)                 # 8-byte Spill
	leaq	40(%rax), %rcx
	movq	%rcx, 112(%rsp)                 # 8-byte Spill
	leaq	48(%rax), %rcx
	movq	%rcx, 104(%rsp)                 # 8-byte Spill
	movq	%rax, 152(%rsp)                 # 8-byte Spill
	addq	$56, %rax
	movq	%rax, 96(%rsp)                  # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rcx, 160(%rsp)                 # 8-byte Spill
	shlq	$6, %rcx
	movq	152(%rsp), %rax                 # 8-byte Reload
	leaq	(%rax,%rcx), %r10
	movq	8(%rsp), %rax                   # 8-byte Reload
	addq	%rcx, %rax
	movq	%rax, 240(%rsp)                 # 8-byte Spill
	movq	144(%rsp), %rax                 # 8-byte Reload
	leaq	(%rcx,%rax), %r15
	movq	88(%rsp), %rax                  # 8-byte Reload
	leaq	(%rcx,%rax), %rax
	movq	%rax, 232(%rsp)                 # 8-byte Spill
	movq	136(%rsp), %rax                 # 8-byte Reload
	leaq	(%rcx,%rax), %rdx
	movq	80(%rsp), %rax                  # 8-byte Reload
	leaq	(%rcx,%rax), %rax
	movq	%rax, 224(%rsp)                 # 8-byte Spill
	movq	128(%rsp), %rax                 # 8-byte Reload
	leaq	(%rcx,%rax), %rdi
	movq	72(%rsp), %rax                  # 8-byte Reload
	leaq	(%rcx,%rax), %rax
	movq	%rax, 216(%rsp)                 # 8-byte Spill
	movq	120(%rsp), %rax                 # 8-byte Reload
	leaq	(%rcx,%rax), %rax
	movq	64(%rsp), %rsi                  # 8-byte Reload
	leaq	(%rcx,%rsi), %rsi
	movq	%rsi, 208(%rsp)                 # 8-byte Spill
	movq	112(%rsp), %rsi                 # 8-byte Reload
	leaq	(%rcx,%rsi), %r9
	movq	56(%rsp), %rsi                  # 8-byte Reload
	leaq	(%rcx,%rsi), %rsi
	movq	%rsi, 200(%rsp)                 # 8-byte Spill
	movq	104(%rsp), %rsi                 # 8-byte Reload
	leaq	(%rcx,%rsi), %r13
	movq	48(%rsp), %rsi                  # 8-byte Reload
	addq	%rcx, %rsi
	movq	%rsi, 192(%rsp)                 # 8-byte Spill
	movq	96(%rsp), %rsi                  # 8-byte Reload
	addq	%rcx, %rsi
	movq	40(%rsp), %r8                   # 8-byte Reload
	addq	%r8, %rcx
	movq	%rcx, 184(%rsp)                 # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4
.LBB0_4:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rcx, 248(%rsp)                 # 8-byte Spill
	shlq	$12, %rcx
	movq	176(%rsp), %r8                  # 8-byte Reload
	leaq	(%r8,%rcx), %r12
	movq	240(%rsp), %r8                  # 8-byte Reload
	addq	%rcx, %r8
	movq	168(%rsp), %r11                 # 8-byte Reload
	vmovups	(%r11,%r8,4), %ymm0
	movq	232(%rsp), %r8                  # 8-byte Reload
	leaq	(%rcx,%r8), %r8
	vmovups	(%r11,%r8,4), %ymm1
	movq	224(%rsp), %r8                  # 8-byte Reload
	leaq	(%rcx,%r8), %r8
	vmovups	(%r11,%r8,4), %ymm2
	movq	216(%rsp), %r8                  # 8-byte Reload
	leaq	(%rcx,%r8), %r8
	vmovups	(%r11,%r8,4), %ymm3
	movq	208(%rsp), %r8                  # 8-byte Reload
	addq	%rcx, %r8
	vmovups	(%r11,%r8,4), %ymm4
	movq	200(%rsp), %r8                  # 8-byte Reload
	addq	%rcx, %r8
	vmovups	(%r11,%r8,4), %ymm5
	movq	192(%rsp), %r8                  # 8-byte Reload
	addq	%rcx, %r8
	vmovups	(%r11,%r8,4), %ymm6
	addq	184(%rsp), %rcx                 # 8-byte Folded Reload
	vmovups	(%r11,%rcx,4), %ymm7
	xorl	%ecx, %ecx
	.p2align	4
.LBB0_5:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB0_6 Depth 6
	movq	%rcx, %r14
	shlq	$12, %r14
	leaq	(%r10,%r14), %r8
	vmulps	(%rbp,%r8,4), %ymm0, %ymm8
	vmovups	%ymm8, 264(%rsp)
	leaq	(%r14,%r15), %r8
	vmulps	(%rbp,%r8,4), %ymm1, %ymm8
	vmovups	%ymm8, 296(%rsp)
	leaq	(%r14,%rdx), %r8
	vmulps	(%rbp,%r8,4), %ymm2, %ymm8
	vmovups	%ymm8, 328(%rsp)
	leaq	(%r14,%rdi), %r8
	vmulps	(%rbp,%r8,4), %ymm3, %ymm8
	vmovups	%ymm8, 360(%rsp)
	leaq	(%r14,%rax), %r8
	vmulps	(%rbp,%r8,4), %ymm4, %ymm8
	vmovups	%ymm8, 392(%rsp)
	leaq	(%r12,%rcx), %r8
	leaq	(%r14,%r9), %r11
	vmulps	(%rbp,%r11,4), %ymm5, %ymm8
	vmovups	%ymm8, 424(%rsp)
	vmovss	(%rbx,%r8,4), %xmm8             # xmm8 = mem[0],zero,zero,zero
	leaq	(%r14,%r13), %r11
	vmulps	(%rbp,%r11,4), %ymm6, %ymm9
	vmovups	%ymm9, 456(%rsp)
	addq	%rsi, %r14
	vmulps	(%rbp,%r14,4), %ymm7, %ymm9
	vmovups	%ymm9, 488(%rsp)
	xorl	%r14d, %r14d
	.p2align	4
.LBB0_6:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        # =>          This Inner Loop Header: Depth=6
	vmovups	264(%rsp,%r14), %xmm9
	vaddps	280(%rsp,%r14), %xmm9, %xmm9
	vshufpd	$1, %xmm9, %xmm9, %xmm10        # xmm10 = xmm9[1,0]
	vaddps	%xmm10, %xmm9, %xmm9
	vmovshdup	%xmm9, %xmm10           # xmm10 = xmm9[1,1,3,3]
	vaddss	%xmm10, %xmm9, %xmm9
	vaddss	%xmm9, %xmm8, %xmm8
	addq	$32, %r14
	cmpq	$256, %r14                      # imm = 0x100
	jne	.LBB0_6
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=5
	vmovss	%xmm8, (%rbx,%r8,4)
	cmpq	$63, %rcx
	leaq	1(%rcx), %rcx
	jne	.LBB0_5
# %bb.8:                                #   in Loop: Header=BB0_4 Depth=4
	movq	248(%rsp), %rcx                 # 8-byte Reload
	cmpq	$63, %rcx
	leaq	1(%rcx), %rcx
	jne	.LBB0_4
# %bb.9:                                #   in Loop: Header=BB0_3 Depth=3
	movq	160(%rsp), %rcx                 # 8-byte Reload
	cmpq	$63, %rcx
	leaq	1(%rcx), %rcx
	jne	.LBB0_3
# %bb.10:                               #   in Loop: Header=BB0_2 Depth=2
	movq	32(%rsp), %rax                  # 8-byte Reload
	cmpq	$63, %rax
	leaq	1(%rax), %rax
	jne	.LBB0_2
# %bb.11:                               #   in Loop: Header=BB0_1 Depth=1
	movq	24(%rsp), %r14                  # 8-byte Reload
	cmpq	$63, %r14
	leaq	1(%r14), %r14
	jne	.LBB0_1
# %bb.12:
	movq	16(%rsp), %rdi                  # 8-byte Reload
	vzeroupper
	callq	free
	addq	$520, %rsp                      # imm = 0x208
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
	retq
.Lfunc_end0:
	.size	matrix_mul_c, .Lfunc_end0-matrix_mul_c
	.cfi_endproc
                                        # -- End function
	.ident	"Intel(R) oneAPI DPC++/C++ Compiler 2026.0.0 (2026.0.0.20260331)"
	.section	".note.GNU-stack","",@progbits
