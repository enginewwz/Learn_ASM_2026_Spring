> **代码引用说明**
> - **来源**：开源项目 [FFmpeg](https://ffmpeg.org/) (`libavcodec/x86/fdct.c`)
> - **许可协议**：GNU LGPL v2.1
> - **版权所有**：Copyright (c) FFmpeg Developers
> - **分析用途**：本段代码仅用于学术分析，展示 FFmpeg 使用内联汇编利用 SIMD 指令集在离散余弦变换（DCT）中的优化。

```c
/* Adapted from FFmpeg libavcodec. All rights reserved by FFmpeg developers. */
static av_always_inline void fdct_row_sse2(const int16_t *in, int16_t *out)
{
    __asm__ volatile(
#define FDCT_ROW_SSE2_H1(i,t)                    \
        "movq      " #i "(%0), %%xmm2      \n\t" \
        "movq      " #i "+8(%0), %%xmm0    \n\t" \
        "movdqa    " #t "+32(%1), %%xmm3   \n\t" \
        "movdqa    " #t "+48(%1), %%xmm7   \n\t" \
        "movdqa    " #t "(%1), %%xmm4      \n\t" \
        "movdqa    " #t "+16(%1), %%xmm5   \n\t"

#define FDCT_ROW_SSE2_H2(i,t)                    \
        "movq      " #i "(%0), %%xmm2      \n\t" \
        "movq      " #i "+8(%0), %%xmm0    \n\t" \
        "movdqa    " #t "+32(%1), %%xmm3   \n\t" \
        "movdqa    " #t "+48(%1), %%xmm7   \n\t"

#define FDCT_ROW_SSE2(i)                      \
        "movq      %%xmm2, %%xmm1       \n\t" \
        "pshuflw   $27, %%xmm0, %%xmm0  \n\t" \
        "paddsw    %%xmm0, %%xmm1       \n\t" \
        "psubsw    %%xmm0, %%xmm2       \n\t" \
        "punpckldq %%xmm2, %%xmm1       \n\t" \
        "pshufd    $78, %%xmm1, %%xmm2  \n\t" \
        "pmaddwd   %%xmm2, %%xmm3       \n\t" \
        "pmaddwd   %%xmm1, %%xmm7       \n\t" \
        "pmaddwd   %%xmm5, %%xmm2       \n\t" \
        "pmaddwd   %%xmm4, %%xmm1       \n\t" \
        "paddd     %%xmm7, %%xmm3       \n\t" \
        "paddd     %%xmm2, %%xmm1       \n\t" \
        "paddd     %%xmm6, %%xmm3       \n\t" \
        "paddd     %%xmm6, %%xmm1       \n\t" \
        "psrad     %3, %%xmm3           \n\t" \
        "psrad     %3, %%xmm1           \n\t" \
        "packssdw  %%xmm3, %%xmm1       \n\t" \
        "movdqa    %%xmm1, " #i "(%4)   \n\t"

        "movdqa    (%2), %%xmm6         \n\t"
        FDCT_ROW_SSE2_H1(0,0)
        FDCT_ROW_SSE2(0)
        FDCT_ROW_SSE2_H2(64,0)
        FDCT_ROW_SSE2(64)

        FDCT_ROW_SSE2_H1(16,64)
        FDCT_ROW_SSE2(16)
        FDCT_ROW_SSE2_H2(112,64)
        FDCT_ROW_SSE2(112)

        FDCT_ROW_SSE2_H1(32,128)
        FDCT_ROW_SSE2(32)
        FDCT_ROW_SSE2_H2(96,128)
        FDCT_ROW_SSE2(96)

        FDCT_ROW_SSE2_H1(48,192)
        FDCT_ROW_SSE2(48)
        FDCT_ROW_SSE2_H2(80,192)
        FDCT_ROW_SSE2(80)
        :
        : "r" (in), "r" (tab_frw_01234567_sse2.tab_frw_01234567_sse2),
          "r" (fdct_r_row_sse2.fdct_r_row_sse2), "i" (SHIFT_FRW_ROW), "r" (out)
          XMM_CLOBBERS_ONLY("%xmm0", "%xmm1", "%xmm2", "%xmm3",
                            "%xmm4", "%xmm5", "%xmm6", "%xmm7")
    );
}
```

这段代码主要使用SSE2指令集对输入数据进行离散余弦变换（DCT）。通过内联汇编，FFmpeg开发者利用SIMD指令实现了高效的数据处理。具体如下：

主要内联函数结构使用宏定义加调用宏定义避免了代码重复，提高了代码的可读性和维护性。宏定义中使用了多种SSE2指令，如`movq`, `movdqa`, `pshuflw`, `paddsw`, `psubsw`, `punpckldq`, `pshufd`, `pmaddwd`, `paddd`, `psrad`, 和`packssdw`，这些指令分别用于数据加载、数据重排、加减运算、乘加运算、位移和打包等操作。

主函数开头使用`static av_always_inline`修饰，表明这是一个内联函数，编译器会尽可能将其内联展开以提高性能。内联汇编内部使用% + 数字完成传参，并强制使用%%xmmn寄存器进行数据处理。函数有输出但是注意到没有返回值字段，这是因为输出是通过内存地址传递的，函数直接将结果写入指定的内存位置。对应输入字段的`"r" (out)`。另一方面改写内存并且使用了全部向量寄存器，使用了`XMM_CLOBBERS_ONLY`宏（内含看似缺失的引号）来声明"memory"和"xmm"寄存器内容破坏。

对于其他传参，`"r" (in)`和`"r" (tab_frw_01234567_sse2.tab_frw_01234567_sse2)`分别传递输入数据和预定义的SSE2余弦系数表，`"r" (fdct_r_row_sse2.fdct_r_row_sse2)`传递SSE2余弦修正常量块，`"i" (SHIFT_FRW_ROW)`传递一个立即数常量用于位移操作。

这样，FFmpeg通过内联汇编实现了高效的DCT计算，利用SSE2指令集显著提升了性能，适用于视频编码等需要大量DCT计算的场景。

汇编代码如下：(我在里面做了对应的注释)

```asm
	.type	fdct_row_sse2, @function
fdct_row_sse2:
.LFB0:
	.cfi_startproc
	endbr64
	leaq	tab_frw_01234567_sse2(%rip), %rax	# 加载预定义的SSE2余弦系数表地址到rax寄存器
	leaq	fdct_r_row_sse2(%rip), %rdx			# 加载SSE2余弦修正常量块地址到rdx寄存器
#APP											# 内联汇编开始
# 173 "fdct_row_sse2.c" 1
	movdqa    (%rdx), %xmm6         			# "movdqa    (%2), %%xmm6         \n\t"
	movq      0(%rdi), %xmm2      				# FDCT_ROW_SSE2_H1(0,0)
	movq      0+8(%rdi), %xmm0    
	movdqa    0+32(%rax), %xmm3   
	movdqa    0+48(%rax), %xmm7   
	movdqa    0(%rax), %xmm4      
	movdqa    0+16(%rax), %xmm5   
	movq      %xmm2, %xmm1						# FDCT_ROW_SSE2(0)       
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 0(%rsi)   
	movq      64(%rdi), %xmm2      				# FDCT_ROW_SSE2_H2(64,0)
	movq      64+8(%rdi), %xmm0    
	movdqa    0+32(%rax), %xmm3   
	movdqa    0+48(%rax), %xmm7   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(64)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 64(%rsi)   
	movq      16(%rdi), %xmm2      				# FDCT_ROW_SSE2_H1(16,64)
	movq      16+8(%rdi), %xmm0    
	movdqa    64+32(%rax), %xmm3   
	movdqa    64+48(%rax), %xmm7   
	movdqa    64(%rax), %xmm4      
	movdqa    64+16(%rax), %xmm5   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(16)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 16(%rsi)   
	movq      112(%rdi), %xmm2      			# FDCT_ROW_SSE2_H2(112,64)
	movq      112+8(%rdi), %xmm0    
	movdqa    64+32(%rax), %xmm3   
	movdqa    64+48(%rax), %xmm7   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(112)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 112(%rsi)   
	movq      32(%rdi), %xmm2      				# FDCT_ROW_SSE2_H1(32,128)
	movq      32+8(%rdi), %xmm0    
	movdqa    128+32(%rax), %xmm3   
	movdqa    128+48(%rax), %xmm7   
	movdqa    128(%rax), %xmm4      
	movdqa    128+16(%rax), %xmm5   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(32)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 32(%rsi)   
	movq      96(%rdi), %xmm2      				# FDCT_ROW_SSE2_H2(96,128)
	movq      96+8(%rdi), %xmm0    
	movdqa    128+32(%rax), %xmm3   
	movdqa    128+48(%rax), %xmm7   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(96)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 96(%rsi)   
	movq      48(%rdi), %xmm2      				# FDCT_ROW_SSE2_H1(48,192)
	movq      48+8(%rdi), %xmm0    
	movdqa    192+32(%rax), %xmm3   
	movdqa    192+48(%rax), %xmm7   
	movdqa    192(%rax), %xmm4      
	movdqa    192+16(%rax), %xmm5   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(48)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 48(%rsi)   
	movq      80(%rdi), %xmm2      				# FDCT_ROW_SSE2_H2(80,192)
	movq      80+8(%rdi), %xmm0    
	movdqa    192+32(%rax), %xmm3   
	movdqa    192+48(%rax), %xmm7   
	movq      %xmm2, %xmm1       				# FDCT_ROW_SSE2(80)
	pshuflw   $27, %xmm0, %xmm0  
	paddsw    %xmm0, %xmm1       
	psubsw    %xmm0, %xmm2       
	punpckldq %xmm2, %xmm1       
	pshufd    $78, %xmm1, %xmm2  
	pmaddwd   %xmm2, %xmm3       
	pmaddwd   %xmm1, %xmm7       
	pmaddwd   %xmm5, %xmm2       
	pmaddwd   %xmm4, %xmm1       
	paddd     %xmm7, %xmm3       
	paddd     %xmm2, %xmm1       
	paddd     %xmm6, %xmm3       
	paddd     %xmm6, %xmm1       
	psrad     $17, %xmm3           
	psrad     $17, %xmm1           
	packssdw  %xmm3, %xmm1       
	movdqa    %xmm1, 80(%rsi)   
	
# 0 "" 2
#NO_APP											# 内联汇编结束
	ret
	.cfi_endproc
```

由于只是简单编译了代码，汇编文件中没有体现colbber的内容。