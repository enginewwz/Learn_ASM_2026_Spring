# transpose 4096*4096 matrix of 32-bit floating point numbers using x87
# at&t

.section .text
.globl matrix_transpose_naive
.type matrix_transpose_naive, @function
matrix_transpose_naive:
    # rdi = src, rsi = dst
    push %rbp
    mov %rsp, %rbp

    mov $4096, %rcx                 # number of rows/columns
    xor %r8, %r8                    # row index i

row_loop:
    xor %r9, %r9                    # column index j
col_loop:
    # src addr = src + (i * 16384) + (j * 4)
    mov %r8, %rax
    shl $14, %rax                   # i * 16384
    mov %r9, %rdx
    shl $2, %rdx                    # j * 4
    lea (%rdi, %rax), %r10
    add %rdx, %r10

    # dst addr = dst + (j * 16384) + (i * 4)
    mov %r9, %rax
    shl $14, %rax                   # j * 16384
    mov %r8, %rdx
    shl $2, %rdx                    # i * 4
    lea (%rsi, %rax), %r11
    add %rdx, %r11

    # load/store using x87
    flds (%r10)
    fstps (%r11)

    inc %r9
    cmp %rcx, %r9
    jl col_loop
    inc %r8
    cmp %rcx, %r8
    jl row_loop

    leave
    ret
