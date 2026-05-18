// matrix_mul_c.c
// a function to multiply 4096x4096 matrices using C

#include <stdlib.h>
#include <immintrin.h>

// transpose B to improve cache performance

void matrix_transpose_avx2(float *B, float *B_transposed);

void matrix_mul_c(float * __restrict__ A, float * __restrict__ B, float * __restrict__ C) {
    // Transpose B
    float *B_transposed = (float *)_mm_malloc(4096 * 4096 * sizeof(float), 32);
    matrix_transpose_avx2(B, B_transposed);

    for (int i = 0; i < 4096; i++) {
        for (int j = 0; j < 4096; j++) {
            C[i * 4096 + j] = 0;
            for (int k = 0; k < 4096; k++) {
                C[i * 4096 + j] += A[i * 4096 + k] * B_transposed[j * 4096 + k];
            }
        }
    }

    _mm_free(B_transposed);
}
