// a shell to test the time consumption of matrix multiplication
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <immintrin.h>

void matrix_mul_c(float *A, float *B, float *C);

int main() {
    int n = 4096;
    srand((unsigned int)time(NULL));

    float *A = (float *)_mm_malloc(n * n * sizeof(float), 32);
    float *B = (float *)_mm_malloc(n * n * sizeof(float), 32);
    float *C = (float *)_mm_malloc(n * n * sizeof(float), 32);

    // Initialize A and B with some values
    for (int i = 0; i < n * n; i++) {
        A[i] = rand() / (float)RAND_MAX; // or any other value
        B[i] = rand() / (float)RAND_MAX; // or any other value
    }

    clock_t start = clock();
    matrix_mul_c(A, B, C);
    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Time taken for matrix multiplication: %f seconds\n", time_spent);

    _mm_free(A);
    _mm_free(B);
    _mm_free(C);
    
    return 0;
}