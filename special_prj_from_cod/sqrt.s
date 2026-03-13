# since i've not learnt sufficient asm knowledge; the following code widely assisted ai-agent.

.intel_syntax noprefix

.section .data
    .align 16
    x:          .float 2.0
    y0:         .float 1.0
    half:       .float 0.5
    eps:        .float 0.00001
    res:        .float 0.0
    # Use a constant for the mask to avoid alignment issues in some environments
    mask_val:   .long 0x7FFFFFFF

.section .text
    .globl _start

_start:
    # 1. Load data
    movss xmm0, [x]                 
    movss xmm1, [y0]                
    movss xmm2, [half]              
    movss xmm3, [eps]               
    movss xmm6, [mask_val]          # Pre-load the mask to xmm6

iter_loop:
    movss xmm4, xmm1                

    # 3. yn_next = 0.5 * (yn + x/yn)
    movss xmm5, xmm0                
    divss xmm5, xmm1                
    addss xmm5, xmm1                
    mulss xmm1, xmm5                

    # 4. Convergence check
    movss xmm5, xmm1                
    subss xmm5, xmm4                
    
    # Absolute value using the pre-loaded mask
    andps xmm5, xmm6  
    
    ucomiss xmm5, xmm3              
    jae iter_loop                   

    # 5. Store result
    movss [res], xmm1

    # Exit (Linux x86-64 syscall)
    mov rax, 60                     
    xor rdi, rdi                    
    syscall
