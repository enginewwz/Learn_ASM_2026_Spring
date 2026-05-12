# transpose 4096*4096 matrix of 32-bit floating point numbers using AVX2 instructions (blocking 8*8)
# at&t

.section .text
.globl matrix_transpose_avx2
.type matrix_transpose_avx2, @function
matrix_transpose_avx2:
    # rdi = src, rsi = dst
    push %rbp
    mov %rsp, %rbp

    mov $512, %rcx                  # number of blocks (rows and columns)
    xor %r8, %r8                    # block row index

block_row_loop:
    xor %r9, %r9                    # reset block column index
block_col_loop:
    # calculate the starting addresses of the current block in src and dst
    mov %r8, %rax
    shl $17, %rax                   # row block offset in bytes
    mov %r9, %rdx
    shl $5, %rdx                    # column block offset in bytes
    lea (%rdi, %rax), %r10
    add %rdx, %r10                  # src block start address

    mov %r9, %rax
    shl $17, %rax                   # row block offset in bytes
    mov %r8, %rdx
    shl $5, %rdx                    # column block offset in bytes
    lea (%rsi, %rax), %r11
    add %rdx, %r11                  # dst block start address

    # transpose the 8x8 block
    # load 8 rows of the block into ymm registers
    vmovups (%r10), %ymm0
    vmovups 16384(%r10), %ymm1
    vmovups 32768(%r10), %ymm2
    vmovups 49152(%r10), %ymm3
    vmovups 65536(%r10), %ymm4
    vmovups 81920(%r10), %ymm5
    vmovups 98304(%r10), %ymm6
    vmovups 114688(%r10), %ymm7

    # transpose the 8x8 block using unpack and shuffle instructions
    vunpcklps %ymm1, %ymm0, %ymm8
    vunpckhps %ymm1, %ymm0, %ymm9
    vunpcklps %ymm3, %ymm2, %ymm10
    vunpckhps %ymm3, %ymm2, %ymm11
    vunpcklps %ymm5, %ymm4, %ymm12
    vunpckhps %ymm5, %ymm4, %ymm13
    vunpcklps %ymm7, %ymm6, %ymm14
    vunpckhps %ymm7, %ymm6, %ymm15

    vunpcklpd %ymm10, %ymm8, %ymm0
    vunpckhpd %ymm10, %ymm8, %ymm1
    vunpcklpd %ymm11, %ymm9, %ymm2
    vunpckhpd %ymm11, %ymm9, %ymm3
    vunpcklpd %ymm14, %ymm12, %ymm4
    vunpckhpd %ymm14, %ymm12, %ymm5
    vunpcklpd %ymm15, %ymm13, %ymm6
    vunpckhpd %ymm15, %ymm13, %ymm7

    vperm2f128 $0x20, %ymm4, %ymm0, %ymm8
    vperm2f128 $0x31, %ymm4, %ymm0, %ymm12
    vperm2f128 $0x20, %ymm5, %ymm1, %ymm9
    vperm2f128 $0x31, %ymm5, %ymm1, %ymm13
    vperm2f128 $0x20, %ymm6, %ymm2, %ymm10
    vperm2f128 $0x31, %ymm6, %ymm2, %ymm14
    vperm2f128 $0x20, %ymm7, %ymm3, %ymm11
    vperm2f128 $0x31, %ymm7, %ymm3, %ymm15

    # store the transposed block back to dst
    vmovntps %ymm8, (%r11)
    vmovntps %ymm9, 16384(%r11)
    vmovntps %ymm10, 32768(%r11)
    vmovntps %ymm11, 49152(%r11)
    vmovntps %ymm12, 65536(%r11)
    vmovntps %ymm13, 81920(%r11)
    vmovntps %ymm14, 98304(%r11)
    vmovntps %ymm15, 114688(%r11)

    inc %r9                        # move to the next block column
    cmp %rcx, %r9
    jl block_col_loop
    inc %r8                        # move to the next block row
    cmp %rcx, %r8
    jl block_row_loop

    # return
    leave
    ret
