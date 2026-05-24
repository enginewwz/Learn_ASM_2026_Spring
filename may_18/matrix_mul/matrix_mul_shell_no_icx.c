// a shell to test the time consumption of matrix multiplication
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <immintrin.h>

void matrix_mul_c_gcc(float *A, float *B, float *C);
// void matrix_mul_c_icx(float *A, float *B, float *C);
void matrix_mul_c_blockings(float *A, float *B, float *C);
void matrix_mul_c_with_transpose(float *A, float *B, float *C);
void matrix_mul_avx2(float *A, float *B, float *C);
double matrix_mul_shell_4python(void);

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

    double time_gcc, time_blockings, time_transpose, time_avx2, time_python;// , time_icx

    clock_t start = clock();
    matrix_mul_c_gcc(A, B, C);
    clock_t end = clock();

    time_gcc = (double)(end - start) / CLOCKS_PER_SEC;

    // start = clock();
    // matrix_mul_c_icx(A, B, C);
    // end = clock();

    // time_icx = (double)(end - start) / CLOCKS_PER_SEC;

    start = clock();
    matrix_mul_c_blockings(A, B, C);
    end = clock();

    time_blockings = (double)(end - start) / CLOCKS_PER_SEC;

    start = clock();
    matrix_mul_c_with_transpose(A, B, C);
    end = clock();

    time_transpose = (double)(end - start) / CLOCKS_PER_SEC;

    start = clock();
    matrix_mul_avx2(A, B, C);
    end = clock();

    time_avx2 = (double)(end - start) / CLOCKS_PER_SEC;

    time_python = matrix_mul_shell_4python();

    printf("Time taken by matrix multiplication implementations:\n");
    printf("--------------------------------------------------------------------\n");
    printf("Implementation\t|\tTime     \t|\tAcceleration Rate\n");
    printf("python        \t|\t%10f s\t|\t %10f x\n", time_python, time_python / time_python);
    printf("gcc           \t|\t%10f s\t|\t %10f x\n", time_gcc, time_python / time_gcc);
    printf("blockings     \t|\t%10f s\t|\t %10f x\n", time_blockings, time_python / time_blockings);
    printf("transpose     \t|\t%10f s\t|\t %10f x\n", time_transpose, time_python / time_transpose);
    // printf("icx           \t|\t%10f s\t|\t %10f x\n", time_icx, time_python / time_icx);
    printf("avx2          \t|\t%10f s\t|\t %10f x\n", time_avx2, time_python / time_avx2);
    printf("--------------------------------------------------------------------\n");
    
    _mm_free(A);
    _mm_free(B);
    _mm_free(C);
    
    return 0;
}