# transpose 4096*4096 matrix of 32-bit floating point numbers using x87
# at&t

.section .text
.globl matrix_transpose_blocking
.type matrix_transpose_blocking, @function
matrix_transpose_blocking:
    # rdi = src, rsi = dst
    push %rbp
    mov %rsp, %rbp
    push %r12
    push %r13
    push %r14

    mov $64, %r14                   # macro block size (64x64)
    xor %r12, %r12                  # outer row block index (0..63)

outer_row_loop:
    xor %r13, %r13                  # outer col block index (0..63)
outer_col_loop:
    xor %r8, %r8                    # inner row index (0..63)
inner_row_loop:
    xor %r9, %r9                    # inner col index (0..63)
inner_col_loop:
    # src addr = src + ((outer_i*64 + inner_i) * 16384) + ((outer_j*64 + inner_j) * 4)
    mov %r12, %rax
    shl $20, %rax                   # outer_i * 64 * 16384
    mov %r8, %rdx
    shl $14, %rdx                   # inner_i * 16384
    add %rdx, %rax
    mov %r13, %rdx
    shl $8, %rdx                    # outer_j * 64 * 4
    add %rdx, %rax
    mov %r9, %rdx
    shl $2, %rdx                    # inner_j * 4
    add %rdx, %rax
    lea (%rdi, %rax), %r10

    # dst addr = dst + ((outer_j*64 + inner_j) * 16384) + ((outer_i*64 + inner_i) * 4)
    mov %r13, %rax
    shl $20, %rax                   # outer_j * 64 * 16384
    mov %r9, %rdx
    shl $14, %rdx                   # inner_j * 16384
    add %rdx, %rax
    mov %r12, %rdx
    shl $8, %rdx                    # outer_i * 64 * 4
    add %rdx, %rax
    mov %r8, %rdx
    shl $2, %rdx                    # inner_i * 4
    add %rdx, %rax
    lea (%rsi, %rax), %r11

    # load/store using x87
    flds (%r10)
    fstps (%r11)

    inc %r9
    cmp %r14, %r9
    jl inner_col_loop
    inc %r8
    cmp %r14, %r8
    jl inner_row_loop
    inc %r13
    cmp %r14, %r13
    jl outer_col_loop
    inc %r12
    cmp %r14, %r12
    jl outer_row_loop

    pop %r14
    pop %r13
    pop %r12
    leave
    ret
