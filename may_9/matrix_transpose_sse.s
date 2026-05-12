# transpose 4096*4096 matrix of 32-bit floating point numbers using sse instructions (blocking 4*4)
# at&t

.section .text
.globl matrix_transpose_sse
.type matrix_transpose_sse, @function
matrix_transpose_sse:
    # rdi = src, rsi = dst
    push %rbp
    mov %rsp, %rbp

    mov $1024, %rcx                 # number of 4x4 blocks per row/column
    xor %r8, %r8                    # block row index

block_row_loop:
    xor %r9, %r9                    # reset block column index
block_col_loop:
    # calculate the starting addresses of the current block in src and dst
    mov %r8, %rax
    shl $16, %rax                   # row block offset in bytes (4 rows * 16384)
    mov %r9, %rdx
    shl $4, %rdx                    # column block offset in bytes (4 cols * 4)
    lea (%rdi, %rax), %r10
    add %rdx, %r10                  # src block start address

    mov %r9, %rax
    shl $16, %rax                   # row block offset in bytes (4 rows * 16384)
    mov %r8, %rdx
    shl $4, %rdx                    # column block offset in bytes (4 cols * 4)
    lea (%rsi, %rax), %r11
    add %rdx, %r11                  # dst block start address

    # transpose the 4x4 block
    # load 4 rows of the block into xmm registers
    movups (%r10), %xmm0
    movups 16384(%r10), %xmm1
    movups 32768(%r10), %xmm2
    movups 49152(%r10), %xmm3

    # transpose the 4x4 block using unpack and shuffle instructions
    movaps %xmm0, %xmm4
    movaps %xmm1, %xmm5
    movaps %xmm2, %xmm6
    movaps %xmm3, %xmm7
    unpcklps %xmm5, %xmm4           # t0: a0 b0 a1 b1
    unpckhps %xmm5, %xmm0           # t1: a2 b2 a3 b3
    unpcklps %xmm7, %xmm6           # t2: c0 d0 c1 d1
    unpckhps %xmm7, %xmm2           # t3: c2 d2 c3 d3

    movaps %xmm0, %xmm5             # t1 copy
    movaps %xmm0, %xmm7             # t1 copy
    shufps $0x44, %xmm6, %xmm4      # out0: a0 b0 c0 d0
    shufps $0xEE, %xmm6, %xmm0      # out1: a1 b1 c1 d1
    shufps $0x44, %xmm2, %xmm5      # out2: a2 b2 c2 d2
    shufps $0xEE, %xmm2, %xmm7      # out3: a3 b3 c3 d3

    # store the transposed block back to dst
    movups %xmm4, (%r11)
    movups %xmm0, 16384(%r11)
    movups %xmm5, 32768(%r11)
    movups %xmm7, 49152(%r11)

    inc %r9                        # move to the next block column
    cmp %rcx, %r9
    jl block_col_loop
    inc %r8                        # move to the next block row
    cmp %rcx, %r8
    jl block_row_loop

    # return
    leave
    ret
