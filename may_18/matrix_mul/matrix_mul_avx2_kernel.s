# use 8 ymm registers to multiply 8 * %rdi matrix with %rdi * 8 matrix, and store the result in 8*8 matrix
# at&t, x86-64 assembly, avx2 instructions

    .text
    .global matrix_mul_avx2_kernel
    .type matrix_mul_avx2_kernel, @function
matrix_mul_avx2_kernel:
    # rdi: loop count for k
    # rsi: pointer to packed A (8 floats per k)
    # rdx: pointer to packed B (8 floats per k)
    # rcx: pointer to C (row-major)
    # r8: ldc (leading dimension of C, in bytes)

    # 8 ymm registers for C (one row per ymm)
    vxorps %ymm0, %ymm0, %ymm0
    vxorps %ymm1, %ymm1, %ymm1
    vxorps %ymm2, %ymm2, %ymm2
    vxorps %ymm3, %ymm3, %ymm3
    vxorps %ymm4, %ymm4, %ymm4
    vxorps %ymm5, %ymm5, %ymm5
    vxorps %ymm6, %ymm6, %ymm6
    vxorps %ymm7, %ymm7, %ymm7

    test %rdi, %rdi
    jz done

    # loop over k
loop_k:
    # load packed B into ymm8 (8 floats)
    vmovups (%rdx), %ymm8

    # broadcast A elements and multiply-add to C
    vbroadcastss 0(%rsi), %ymm15        # A[0][k]
    vfmadd231ps %ymm15, %ymm8, %ymm0

    vbroadcastss 4(%rsi), %ymm15        # A[1][k]
    vfmadd231ps %ymm15, %ymm8, %ymm1

    vbroadcastss 8(%rsi), %ymm15        # A[2][k]
    vfmadd231ps %ymm15, %ymm8, %ymm2

    vbroadcastss 12(%rsi), %ymm15       # A[3][k]
    vfmadd231ps %ymm15, %ymm8, %ymm3

    vbroadcastss 16(%rsi), %ymm15       # A[4][k]
    vfmadd231ps %ymm15, %ymm8, %ymm4

    vbroadcastss 20(%rsi), %ymm15       # A[5][k]
    vfmadd231ps %ymm15, %ymm8, %ymm5

    vbroadcastss 24(%rsi), %ymm15       # A[6][k]
    vfmadd231ps %ymm15, %ymm8, %ymm6

    vbroadcastss 28(%rsi), %ymm15       # A[7][k]
    vfmadd231ps %ymm15, %ymm8, %ymm7

    # increment pointers
    add $32, %rsi         # move to next k of A (8 floats)
    add $32, %rdx         # move to next k of B (8 floats)
    dec %rdi
    jnz loop_k

    # store results back to C && add to existing values in C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm0, %ymm0
    vmovups %ymm0, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm1, %ymm1
    vmovups %ymm1, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm2, %ymm2
    vmovups %ymm2, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm3, %ymm3
    vmovups %ymm3, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm4, %ymm4
    vmovups %ymm4, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm5, %ymm5
    vmovups %ymm5, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm6, %ymm6
    vmovups %ymm6, (%rcx)

    add %r8, %rcx         # move to next row of C
    vmovups (%rcx), %ymm15
    vaddps %ymm15, %ymm7, %ymm7
    vmovups %ymm7, (%rcx)

done:
    ret

.section .note.GNU-stack,"",@progbits
