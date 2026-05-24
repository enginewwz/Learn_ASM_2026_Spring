本报告分析过程中所引用的源代码片段，均严格遵守其原始开源协议。原始版权声明及许可证说明如下：

Linux Kernel 实现：

引用源：Linux Kernel v7.0 (arch/x86/lib/memcpy_64.S)
许可协议：GPL-2.0-only
版权归属：Copyright 2002 Andi Kleen

glibc 实现：

引用源：GNU C Library (glibc) v2.39 (sysdeps/x86_64/multiarch/memmove-ssse3.S)
许可协议：LGPL-2.1 或更高版本
版权归属：Copyright 2022-2024 Free Software Foundation, Inc.


我们先讨论 Linux Kernel 的实现：  
首先执行以下代码：  
```asm
SYM_TYPED_FUNC_START(__memcpy)
	ALTERNATIVE "jmp memcpy_orig", "", X86_FEATURE_FSRM

	movq %rdi, %rax
	movq %rdx, %rcx
	rep movsb
	RET
SYM_FUNC_END(__memcpy)
```
如果当前 CPU 支持 FSRM（Fast Short Rep Movsb）特性，则会使用 rep movsb 指令来执行内存复制操作。movsb 通过将源地址（%rsi）和目的地址（%rdi）以及复制的字节数（%rcx）加载到寄存器中，然后使用 rep 前缀来重复执行 movsb 指令，直到完成指定字节数的复制。

如果 CPU 不支持 FSRM，则会跳转到 memcpy_orig 标签处执行原始的 memcpy 实现。

下面我们分析 memcpy_orig 的实现：  
```asm
SYM_FUNC_START_LOCAL(memcpy_orig)
	movq %rdi, %rax

	cmpq $0x20, %rdx
	jb .Lhandle_tail

	/*
	 * We check whether memory false dependence could occur,
	 * then jump to corresponding copy mode.
	 */
	cmp  %dil, %sil
	jl .Lcopy_backward
	subq $0x20, %rdx
.Lcopy_forward_loop:
	subq $0x20,	%rdx

	/*
	 * Move in blocks of 4x8 bytes:
	 */
	movq 0*8(%rsi),	%r8
	movq 1*8(%rsi),	%r9
	movq 2*8(%rsi),	%r10
	movq 3*8(%rsi),	%r11
	leaq 4*8(%rsi),	%rsi

	movq %r8,	0*8(%rdi)
	movq %r9,	1*8(%rdi)
	movq %r10,	2*8(%rdi)
	movq %r11,	3*8(%rdi)
	leaq 4*8(%rdi),	%rdi
	jae  .Lcopy_forward_loop
	addl $0x20,	%edx
	jmp  .Lhandle_tail
```
如果复制的字节数（%rdx）小于 32 字节，则直接跳转到 .Lhandle_tail 标签处处理剩余的字节。否则使用块复制的方式进行内存复制。首先比较源地址（%rsi）和目的地址（%rdi）的最低字节，如果目的地址小于源地址，则说明可能存在内存重叠的情况，需要使用向后复制的方式，否则使用向前复制的方式。在向前复制的循环中，每次复制 32 字节（4 个 8 字节块），直到剩余的字节数小于 32 字节为止。最后处理剩余的字节。

```asm
.Lcopy_backward:
	/*
	 * Calculate copy position to tail.
	 */
	addq %rdx,	%rsi
	addq %rdx,	%rdi
	subq $0x20,	%rdx
	/*
	 * At most 3 ALU operations in one cycle,
	 * so append NOPS in the same 16 bytes trunk.
	 */
	.p2align 4
.Lcopy_backward_loop:
	subq $0x20,	%rdx
	movq -1*8(%rsi),	%r8
	movq -2*8(%rsi),	%r9
	movq -3*8(%rsi),	%r10
	movq -4*8(%rsi),	%r11
	leaq -4*8(%rsi),	%rsi
	movq %r8,		-1*8(%rdi)
	movq %r9,		-2*8(%rdi)
	movq %r10,		-3*8(%rdi)
	movq %r11,		-4*8(%rdi)
	leaq -4*8(%rdi),	%rdi
	jae  .Lcopy_backward_loop

	/*
	 * Calculate copy position to head.
	 */
	addl $0x20,	%edx
	subq %rdx,	%rsi
	subq %rdx,	%rdi
```

向后复制几乎没有改变复制方式，只是复制的方向相反。这部分实现防止了目标地址与源地址重叠时数据被覆盖的问题。

进入处理剩余字节的部分：
如果剩余字节数大于等于16字节而小于32字节，则使用头尾复制的方法。从头尾各复制16字节的数据，这样即使有重叠也不会导致数据被覆盖。

```asm
.Lhandle_tail:
	cmpl $16,	%edx
	jb   .Lless_16bytes

	/*
	 * Move data from 16 bytes to 31 bytes.
	 */
	movq 0*8(%rsi), %r8
	movq 1*8(%rsi),	%r9
	movq -2*8(%rsi, %rdx),	%r10
	movq -1*8(%rsi, %rdx),	%r11
	movq %r8,	0*8(%rdi)
	movq %r9,	1*8(%rdi)
	movq %r10,	-2*8(%rdi, %rdx)
	movq %r11,	-1*8(%rdi, %rdx)
	RET
```
这样，不使用分支判断就完整完成了工作。

如果剩余字节数小于16字节，则使用

```asm
.Lless_16bytes:
	cmpl $8,	%edx
	jb   .Lless_8bytes
	/*
	 * Move data from 8 bytes to 15 bytes.
	 */
	movq 0*8(%rsi),	%r8
	movq -1*8(%rsi, %rdx),	%r9
	movq %r8,	0*8(%rdi)
	movq %r9,	-1*8(%rdi, %rdx)
	RET
	.p2align 4
.Lless_8bytes:
	cmpl $4,	%edx
	jb   .Lless_3bytes

	/*
	 * Move data from 4 bytes to 7 bytes.
	 */
	movl (%rsi), %ecx
	movl -4(%rsi, %rdx), %r8d
	movl %ecx, (%rdi)
	movl %r8d, -4(%rdi, %rdx)
	RET
	.p2align 4
.Lless_3bytes:
	subl $1, %edx
	jb .Lend
	/*
	 * Move data from 1 bytes to 3 bytes.
	 */
	movzbl (%rsi), %ecx
	jz .Lstore_1byte
	movzbq 1(%rsi), %r8
	movzbq (%rsi, %rdx), %r9
	movb %r8b, 1(%rdi)
	movb %r9b, (%rdi, %rdx)
.Lstore_1byte:
	movb %cl, (%rdi)

.Lend:
	RET
SYM_FUNC_END(memcpy_orig)
```

用一系列分支二分处理。

Linux Kernel的做法相当稳健，如果能用 rep movsb 就交给硬件完成。如果硬件不支持，则使用软件。软件方面首先尽量减少分支提高性能。其次使用寄存器而不是向量寄存器，防止干扰用户进程的 AVX 上下文。Linux 的写法是“以最小的逻辑复杂度换取硬件的最大性能”。开发者深知在内核中，逻辑越复杂，引入 Bug 和安全漏洞的概率就越高。内核开发者更倾向于编写“能够根据硬件自我演进”的代码，而不是沉溺于编写复杂的、针对特定指令集的汇编代码。

另一方面，Linux Kernel的写法做了内存重叠的容灾冗余，这使得程序鲁棒性大大提高。逻辑直观便于审查，并且强调了通用性。这符合内核力求稳定的基础上高效的特点。


现在我们讨论 glibc 的实现方式：

首先，我们惊奇地发现，glibc 中并没有专门的 memcpy-ssse3 模块，实际上，他将三条指令（memmove、memcpy、mempcpy）都放在同一个文件中实现，展示了高超的复用技巧。

```asm
#if ISA_SHOULD_BUILD (2)

# include <sysdep.h>
# ifndef MEMMOVE
#  define MEMMOVE	__memmove_ssse3
#  define MEMMOVE_CHK	__memmove_chk_ssse3
#  define MEMCPY	__memcpy_ssse3
#  define MEMCPY_CHK	__memcpy_chk_ssse3
#  define MEMPCPY	__mempcpy_ssse3
#  define MEMPCPY_CHK	__mempcpy_chk_ssse3
# endif

	.section .text.ssse3, "ax", @progbits
# if defined SHARED
ENTRY(MEMPCPY_CHK)
	cmp	%RDX_LP, %RCX_LP
	jb	HIDDEN_JUMPTARGET(__chk_fail)
END(MEMPCPY_CHK)
# endif

ENTRY(MEMPCPY)
	mov	%RDI_LP, %RAX_LP
	add	%RDX_LP, %RAX_LP
	jmp	L(start)
END(MEMPCPY)

# if defined SHARED
ENTRY(MEMMOVE_CHK)
	cmp	%RDX_LP, %RCX_LP
	jb	HIDDEN_JUMPTARGET(__chk_fail)
END(MEMMOVE_CHK)
# endif
```

进入主程序，开头如下：
```asm
ENTRY_P2ALIGN(MEMMOVE, 6)
# ifdef __ILP32__
	/* Clear the upper 32 bits.  */
	movl	%edx, %edx
# endif
	movq	%rdi, %rax
L(start):
	cmpq	$16, %rdx
	jb	L(copy_0_15)

	/* These loads are always useful.  */
	movups	0(%rsi), %xmm0
	movups	-16(%rsi, %rdx), %xmm7
	cmpq	$32, %rdx
	ja	L(more_2x_vec)

	movups	%xmm0, 0(%rdi)
	movups	%xmm7, -16(%rdi, %rdx)
	ret
```

如果是 16 - 32 长度的数据直接使用头尾覆盖（注意这时直接使用了两个向量寄存器）完成复制。否则如果长度在 0 - 15 处理如下：

```asm
L(copy_0_15):
	cmpl	$4, %edx
	jb	L(copy_0_3)
	cmpl	$8, %edx
	jb	L(copy_4_7)
	movq	0(%rsi), %rcx
	movq	-8(%rsi, %rdx), %rsi
	movq	%rcx, 0(%rdi)
	movq	%rsi, -8(%rdi, %rdx)
	ret

	.p2align 4,, 4
L(copy_4_7):
	movl	0(%rsi), %ecx
	movl	-4(%rsi, %rdx), %esi
	movl	%ecx, 0(%rdi)
	movl	%esi, -4(%rdi, %rdx)
	ret

	.p2align 4,, 4
L(copy_0_3):
	decl	%edx
	jl	L(copy_0_0)
	movb	(%rsi), %cl
	je	L(copy_1_1)

	movzwl	-1(%rsi, %rdx), %esi
	movw	%si, -1(%rdi, %rdx)
L(copy_1_1):
	movb	%cl, (%rdi)
L(copy_0_0):
	ret
```

8 - 15 乃至 4 - 7 仍旧使用首尾复制法（两个通用寄存器）。更低的情况则使用按字或位搬运。

相似的情形出现在 33 - 64 位的情况：

```asm
.p2align 4,, 4
L(copy_4x_vec):
	movups	16(%rsi), %xmm1
	movups	-32(%rsi, %rdx), %xmm2

	movups	%xmm0, 0(%rdi)
	movups	%xmm1, 16(%rdi)
	movups	%xmm2, -32(%rdi, %rdx)
	movups	%xmm7, -16(%rdi, %rdx)
L(nop):
	ret

	.p2align 4
L(more_2x_vec):
	cmpq	$64, %rdx
	jbe	L(copy_4x_vec)
```

接下来是向前/向后检查。
```asm
/* We use rcx later to get alignr value.  */
	movq	%rdi, %rcx

	/* Backward copy for overlap + dst > src for memmove safety.  */
	subq	%rsi, %rcx
	cmpq	%rdx, %rcx
	jb	L(copy_backward)
```

接下来，很有趣地，我们将最后三个 16 字节存入寄存器（方便在末尾直接做一次头尾覆盖），而将开头的寄存器内的内容早早载入（这样，循环结束时相当于会突出 16 字节，这样就省俭了一次写内存）

```asm
/* Load tail.  */

	/* -16(%rsi, %rdx) already loaded into xmm7.  */
	movups	-32(%rsi, %rdx), %xmm8
	movups	-48(%rsi, %rdx), %xmm9

	/* Get misalignment.  */
	andl	$0xf, %ecx

	movq	%rsi, %r9
	addq	%rcx, %rsi
	andq	$-16, %rsi
	/* Get first vec for `palignr`.  */
	movaps	(%rsi), %xmm1

	/* We have loaded (%rsi) so safe to do this store before the
	   loop.  */
	movups	%xmm0, (%rdi)
```

做一次缓存检查：

```asm
# ifdef SHARED_CACHE_SIZE_HALF
	cmp	$SHARED_CACHE_SIZE_HALF, %RDX_LP
# else
	cmp	__x86_shared_cache_size_half(%rip), %rdx
# endif
	ja	L(large_memcpy)
```

若缓存不够就改用非临时流存储指令（movntps）

于是我们达到最精彩的位置：

```asm
    leaq	-64(%rdi, %rdx), %r8
	andq	$-16, %rdi
	movl	$48, %edx

	leaq	L(loop_fwd_start)(%rip), %r9
	sall	$6, %ecx
	addq	%r9, %rcx
	jmp	* %rcx
```

前半部分计算 16 字节对齐内存地址以及循环结束位置，并且指出每次循环推进 48 字节。后一个部分则与下列定义有关：

```asm
    /* Instead of a typical jump table all 16 loops are exactly
	   64-bytes in size. So, we can just jump to first loop + r8 *
	   64. Before modifying any loop ensure all their sizes match!
	 */
	.p2align 6
```

不同循环体将以 64 字节位置对齐，这样计算出来的跳转值就恰好跳到合适的位置上了

缓存不够和反向时代码有些微不同，这里我们先向正向推进：

```asm
L(loop_fwd_start):
L(loop_fwd_0x0):
	movaps	16(%rsi), %xmm1     # <= 注意不是从 0（%rsi）开始读的，下面的情况也相似
	movaps	32(%rsi), %xmm2
	movaps	48(%rsi), %xmm3
	movaps	%xmm1, 16(%rdi)
	movaps	%xmm2, 32(%rdi)
	movaps	%xmm3, 48(%rdi)
	addq	%rdx, %rdi
	addq	%rdx, %rsi
	cmpq	%rdi, %r8
	ja	L(loop_fwd_0x0)
L(end_loop_fwd):                # <= 只需要恢复三个寄存器
	movups	%xmm9, 16(%r8)
	movups	%xmm8, 32(%r8)
	movups	%xmm7, 48(%r8)
	ret
```

在绝对对齐时，我们会直接使用 movaps 保证速度

```asm
	/* Exactly 64 bytes if `jmp L(end_loop_fwd)` is long encoding.
	   60 bytes otherwise.  */
# define ALIGNED_LOOP_FWD(align_by);	\
	.p2align 6;	\
L(loop_fwd_ ## align_by):	\
	movaps	16(%rsi), %xmm0;	\
	movaps	32(%rsi), %xmm2;	\
	movaps	48(%rsi), %xmm3;	\
	movaps	%xmm3, %xmm4;	\
	palignr	$align_by, %xmm2, %xmm3;	\
	palignr	$align_by, %xmm0, %xmm2;	\
	palignr	$align_by, %xmm1, %xmm0;	\
	movaps	%xmm4, %xmm1;	\
	movaps	%xmm0, 16(%rdi);	\
	movaps	%xmm2, 32(%rdi);	\
	movaps	%xmm3, 48(%rdi);	\
	addq	%rdx, %rdi;	\
	addq	%rdx, %rsi;	\
	cmpq	%rdi, %r8;	\
	ja	L(loop_fwd_ ## align_by);	\
	jmp	L(end_loop_fwd);

	/* Must be in descending order.  */
	ALIGNED_LOOP_FWD (0xf)
	ALIGNED_LOOP_FWD (0xe)
	ALIGNED_LOOP_FWD (0xd)
	ALIGNED_LOOP_FWD (0xc)
	ALIGNED_LOOP_FWD (0xb)
	ALIGNED_LOOP_FWD (0xa)
	ALIGNED_LOOP_FWD (0x9)
	ALIGNED_LOOP_FWD (0x8)
	ALIGNED_LOOP_FWD (0x7)
	ALIGNED_LOOP_FWD (0x6)
	ALIGNED_LOOP_FWD (0x5)
	ALIGNED_LOOP_FWD (0x4)
	ALIGNED_LOOP_FWD (0x3)
	ALIGNED_LOOP_FWD (0x2)
	ALIGNED_LOOP_FWD (0x1)
```

非对齐时，我们强制读取对齐的内容，然后往右推进相应的量。如果考虑初值，%xmm1在很早时就已经是存放（%rsi）的位置。每次循环时，使用 palignr 将前一个寄存器的值向右侧压，这样就能完成非对称的储存，推进完之后将 %xmm4 复制的上一次的尾巴送给 %xmm1 。由初值我们不难发现，实际上最终写出的寄存器 %xmm0 %xmm2 %xmm3 取的内存地址是提前的，偏的越少序号（需要右移越远）越靠前，这便是必须倒序排列的原因。至于 loop_fwd_0x0 不需要偏移一整个 16 是因为之前已经靠 %xmm0 预先存数完成。

接下来我们先看缓存不够的情况：

```asm
L(large_memcpy):
	movups	-64(%r9, %rdx), %xmm10      # <= 开头将预存数（收尾时写回内存）拓展到 80 字节
	movups	-80(%r9, %rdx), %xmm11

	sall	$5, %ecx                    # <= *32
	leal	(%rcx, %rcx, 2), %r8d       # <= *3
	leaq	-96(%rdi, %rdx), %rcx
	andq	$-16, %rdi
	leaq	L(large_loop_fwd_start)(%rip), %rdx
	addq	%r8, %rdx
	jmp	* %rdx
```

实际上思路是一样的，正向时只需要考虑到 96 - 16 = 80 字节的预存数即可。  
由于非对齐时没有用到缓存，我们能够够使用 32 字节对齐。之后的注释指出此时程序在 96 字节处，于是我们注意到此时程序使用了 sal + leal 的 trick

```asm
.p2align 6
L(large_loop_fwd_start):
L(large_loop_fwd_0x0):
	movaps	16(%rsi), %xmm1
	movaps	32(%rsi), %xmm2
	movaps	48(%rsi), %xmm3
	movaps	64(%rsi), %xmm4
	movaps	80(%rsi), %xmm5
	movntps	%xmm1, 16(%rdi)
	movntps	%xmm2, 32(%rdi)
	movntps	%xmm3, 48(%rdi)
	movntps	%xmm4, 64(%rdi)
	movntps	%xmm5, 80(%rdi)
	addq	$80, %rdi
	addq	$80, %rsi
	cmpq	%rdi, %rcx
	ja	L(large_loop_fwd_0x0)

	/* Ensure no icache line split on tail.  */
	.p2align 4
L(end_large_loop_fwd):
	sfence
	movups	%xmm11, 16(%rcx)
	movups	%xmm10, 32(%rcx)
	movups	%xmm9, 48(%rcx)
	movups	%xmm8, 64(%rcx)
	movups	%xmm7, 80(%rcx)
	ret


	/* Size > 64 bytes and <= 96 bytes. 32-byte align between ensure
	   96-byte spacing between each.  */
# define ALIGNED_LARGE_LOOP_FWD(align_by);	\
	.p2align 5;	\
L(large_loop_fwd_ ## align_by):	\
	movaps	16(%rsi), %xmm0;	\
	movaps	32(%rsi), %xmm2;	\
	movaps	48(%rsi), %xmm3;	\
	movaps	64(%rsi), %xmm4;	\
	movaps	80(%rsi), %xmm5;	\
	movaps	%xmm5, %xmm6;	\
	palignr	$align_by, %xmm4, %xmm5;	\
	palignr	$align_by, %xmm3, %xmm4;	\
	palignr	$align_by, %xmm2, %xmm3;	\
	palignr	$align_by, %xmm0, %xmm2;	\
	palignr	$align_by, %xmm1, %xmm0;	\
	movaps	%xmm6, %xmm1;	\
	movntps	%xmm0, 16(%rdi);	\
	movntps	%xmm2, 32(%rdi);	\
	movntps	%xmm3, 48(%rdi);	\
	movntps	%xmm4, 64(%rdi);	\
	movntps	%xmm5, 80(%rdi);	\
	addq	$80, %rdi;	\
	addq	$80, %rsi;	\
	cmpq	%rdi, %rcx;	\
	ja	L(large_loop_fwd_ ## align_by);	\
	jmp	L(end_large_loop_fwd);

	/* Must be in descending order.  */
	ALIGNED_LARGE_LOOP_FWD (0xf)
	ALIGNED_LARGE_LOOP_FWD (0xe)
	ALIGNED_LARGE_LOOP_FWD (0xd)
	ALIGNED_LARGE_LOOP_FWD (0xc)
	ALIGNED_LARGE_LOOP_FWD (0xb)
	ALIGNED_LARGE_LOOP_FWD (0xa)
	ALIGNED_LARGE_LOOP_FWD (0x9)
	ALIGNED_LARGE_LOOP_FWD (0x8)
	ALIGNED_LARGE_LOOP_FWD (0x7)
	ALIGNED_LARGE_LOOP_FWD (0x6)
	ALIGNED_LARGE_LOOP_FWD (0x5)
	ALIGNED_LARGE_LOOP_FWD (0x4)
	ALIGNED_LARGE_LOOP_FWD (0x3)
	ALIGNED_LARGE_LOOP_FWD (0x2)
	ALIGNED_LARGE_LOOP_FWD (0x1)
```

这里使用 movntps 不再走缓存，防止直接挤占其他有效内容空间。但是最终收尾时还是可以走缓存的，于是我们见到 sfence ，这完全是速度考量下的保险。

最后也是相对特殊的，我们来看反向写：

```asm
.p2align 4,, 8
L(copy_backward):
	testq	%rcx, %rcx
	jz	L(nop)

	/* Preload tail.  */

	/* (%rsi) already loaded into xmm0.  */
	movups	16(%rsi), %xmm4
	movups	32(%rsi), %xmm5

	movq	%rdi, %r8               # <= 反向写的结束位置
	subq	%rdi, %rsi              # <= 计算偏移量
	leaq	-49(%rdi, %rdx), %rdi   # <= 计算目标内存结尾地址 -49
	andq	$-16, %rdi              # <= 对齐的目标内存结尾地址（也是循环初始目标地址）
	addq	%rdi, %rsi
	andq	$-16, %rsi              # <= 对齐的源内存结尾地址（也是循环初始源地址）

	movaps	48(%rsi), %xmm6


	leaq	L(loop_bkwd_start)(%rip), %r9
	andl	$0xf, %ecx
	sall	$6, %ecx
	addq	%r9, %rcx
	jmp	* %rcx
```

这一部分首先在三个向量寄存器（xmm0，xmm4，xmm5）存了源数据开头 48 比特数据，防止循环体结束时这部分头被提前覆盖掉。

计算目标内存结尾地址时 -49 使得在之后 andq 时取在 -60 ~ -49 的位置，保证（48(%rsi)）不会越界，至于（-16 ~ 0）部分可能的数据空缺，我们很快会看到使用程序开头定义的 xmm7 能够轻松（头尾）覆盖。

xmm6 中提前存上原本在源数据（对齐后）结尾的内容，准备开始循环体

```asm
.p2align 6
L(loop_bkwd_start):
L(loop_bkwd_0x0):
	movaps	32(%rsi), %xmm1
	movaps	16(%rsi), %xmm2
	movaps	0(%rsi), %xmm3
	movaps	%xmm1, 32(%rdi)
	movaps	%xmm2, 16(%rdi)
	movaps	%xmm3, 0(%rdi)
	subq	$48, %rdi
	subq	$48, %rsi
	cmpq	%rdi, %r8
	jb	L(loop_bkwd_0x0)
L(end_loop_bkwd):
	movups	%xmm7, -16(%r8, %rdx)   # <= 来源于整个函数开头
	movups	%xmm0, 0(%r8)
	movups	%xmm4, 16(%r8)
	movups	%xmm5, 32(%r8)

	ret


	/* Exactly 64 bytes if `jmp L(end_loop_bkwd)` is long encoding.
	   60 bytes otherwise.  */
# define ALIGNED_LOOP_BKWD(align_by);	\
	.p2align 6;	\
L(loop_bkwd_ ## align_by):	\
	movaps	32(%rsi), %xmm1;	\
	movaps	16(%rsi), %xmm2;	\
	movaps	0(%rsi), %xmm3;	\
	palignr	$align_by, %xmm1, %xmm6;	\
	palignr	$align_by, %xmm2, %xmm1;	\
	palignr	$align_by, %xmm3, %xmm2;	\
	movaps	%xmm6, 32(%rdi);	\
	movaps	%xmm1, 16(%rdi);	\
	movaps	%xmm2, 0(%rdi);	\
	subq	$48, %rdi;	\
	subq	$48, %rsi;	\
	movaps	%xmm3, %xmm6;	\
	cmpq	%rdi, %r8;	\
	jb	L(loop_bkwd_ ## align_by);	\
	jmp	L(end_loop_bkwd);

	/* Must be in descending order.  */
	ALIGNED_LOOP_BKWD (0xf)
	ALIGNED_LOOP_BKWD (0xe)
	ALIGNED_LOOP_BKWD (0xd)
	ALIGNED_LOOP_BKWD (0xc)
	ALIGNED_LOOP_BKWD (0xb)
	ALIGNED_LOOP_BKWD (0xa)
	ALIGNED_LOOP_BKWD (0x9)
	ALIGNED_LOOP_BKWD (0x8)
	ALIGNED_LOOP_BKWD (0x7)
	ALIGNED_LOOP_BKWD (0x6)
	ALIGNED_LOOP_BKWD (0x5)
	ALIGNED_LOOP_BKWD (0x4)
	ALIGNED_LOOP_BKWD (0x3)
	ALIGNED_LOOP_BKWD (0x2)
	ALIGNED_LOOP_BKWD (0x1)
END(MEMMOVE)

strong_alias (MEMMOVE, MEMCPY)
# if defined SHARED
strong_alias (MEMMOVE_CHK, MEMCPY_CHK)
# endif
#endif
```

这一部分与之前的正向代码相对来说没什么大变化，只是将目标地址和源地址由递增改为递减。最后补上开头存的 48 比特内存和结尾的 16 比特即可。

glibc 代码各种技巧无不用其极。大量使用分支比较，将需求要求分类并分别给出最快的达成方式（例如使用向量寄存器，非常多的利用头尾覆盖，尽量减少不必要的访存指令，利用内存对齐和跳转表），是一个非常精细并且有些“脆弱”的结构。脆弱不是说他的鲁棒性低，而是说这个程序只能优化一类机器，而且很有可能由于干扰出现错误，比如如果有新特性导致生成机器码多了一比特，就可能导致整个结构崩溃。另一方面，这也是对一类机器最快完成方式，这体现了 glibc 对用户态访存需求达成的极致优化，不仅速度快，也极致压缩可能占用的内存 （例如将正向长度过长的情况将对齐改为 5 而非 6）。glibc 使用代码体积和极小的启动延迟来应对各种场景的极限吞吐量，这是用户态程序优化的极致。


比较来说，Linux Kernel 追求稳健，稳定，内核态首先保证可靠，再保证性能；glibc 追求高效，用户态性能优先。两者是各自场景优化到极致的产物。