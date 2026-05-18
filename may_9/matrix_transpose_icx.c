// use icx to optimize the matrix transpose function
// compile with: icx -O3 -xHost -fp-model=fast -qopt-zmm-usage=high -qopenmp -fimf-precision=low

#include <stdlib.h>

void matrix_transpose_icx(float* __restrict__ A, float* __restrict__ B) {
    #pragma omp parallel for
    for (int i = 0; i < 4096; i++) {
        for (int j = 0; j < 4096; j++) {
            B[j * 4096 + i] = A[i * 4096 + j];
        }
    }
}