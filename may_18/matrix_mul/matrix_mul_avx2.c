// 4096*4096 matrix multiplication using AVX2 intrinsics
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N 4096

// asm kernel for matrix multiplication
// 8*k pA multiply k*8 pB, accumulate into 8*8 C, with ldc leading dimension of C
extern void matrix_mul_avx2_kernel(int k, float *pA, float *pB, float *C, int ldc_bytes);

// kc pB size for tiny pack
#define KC 256

// mc pA size for packing
#define MC 512

// nc pB size for packing
#define NC 2048

#define MR 8
#define NR 8

#define ldc_bytes N * sizeof(float)

void pack_A(float* A, float* packA) {
    int ptr = 0;
    for (int i = 0; i < MC; i += MR) {
        for (int p = 0; p < KC; p++) {
            for (int i0 = 0; i0 < MR; i0++) {
                packA[ptr++] = A[(i + i0) * N + p];
            }
        }
    }
}

void pack_B_avx2(float* B, float* packB) {
    int ptr = 0;
    for (int j = 0; j < NC; j += NR) {
        for (int p = 0; p < KC; p++) {
            __m256 b_vec = _mm256_loadu_ps(&B[p * N + j]);
            _mm256_store_ps(&packB[ptr], b_vec);
            ptr += 8;
        }
    }
}

void matrix_mul_avx2(float * __restrict__ A, float * __restrict__ B, float * __restrict__ C) {

    memset(C, 0, N * N * sizeof(float));

    float* packed_A = (float*)aligned_alloc(32, MC * KC * sizeof(float));
    float* packed_B = (float*)aligned_alloc(32, KC * NC * sizeof(float));

    // Loop 1: NC (2048)
    for (int j = 0; j < N; j += NC) {

        // Loop 2: KC (256)
        for (int p = 0; p < N; p += KC) {
            
            pack_B_avx2(&B[p * N + j], packed_B);

            // Loop 3: MC (512)
            for (int i = 0; i < N; i += MC) {
                
                pack_A(&A[i * N + p], packed_A);

                for (int jr = 0; jr < NC; jr += NR) {
                    
                    for (int ir = 0; ir < MC; ir += MR) {
                        
                        float* pA = packed_A + ir * KC;
                        float* pB = packed_B + jr * KC;
                        float* pC = &C[(i + ir) * N + (j + jr)];

                        matrix_mul_avx2_kernel(KC, pA, pB, pC, ldc_bytes);
                    }
                }
            }
        }
    }

    free(packed_A);
    free(packed_B);
}