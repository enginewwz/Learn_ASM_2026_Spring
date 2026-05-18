// matrix_mul_c.c
// a function to multiply 4096x4096 matrices using C

void matrix_mul_c(float * __restrict__ A, float * __restrict__ B, float * __restrict__ C) {
    for (int i = 0; i < 4096; i++) {
        for (int j = 0; j < 4096; j++) {
            C[i * 4096 + j] = 0;
            for (int k = 0; k < 4096; k++) {
                C[i * 4096 + j] += A[i * 4096 + k] * B[k * 4096 + j];
            }
        }
    }
}