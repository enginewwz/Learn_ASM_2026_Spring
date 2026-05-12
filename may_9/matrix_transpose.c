#define _POSIX_C_SOURCE 199309L
# include <stdio.h>
# include <time.h>

void matrix_transpose_avx2(float *A, float *B);
void matrix_transpose_avx2_blocking(float *A, float *B);
void matrix_transpose_sse(float *A, float *B);
void matrix_transpose_naive(float *A, float *B);
void matrix_transpose_blocking(float *A, float *B);

double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
}

// Transpose a float matrix A of size 4096 * 4096 and store the result in B

int main() {
    static float A[4096][4096] __attribute__((aligned(32)));
    static float B[4096][4096] __attribute__((aligned(32)));
    static float C[4096][4096] __attribute__((aligned(32)));
    static float D[4096][4096] __attribute__((aligned(32)));
    static float E[4096][4096] __attribute__((aligned(32)));
    static float F[4096][4096] __attribute__((aligned(32)));

    struct timespec start, end;

    double avx2_minimum_time = 1000.0; // Initialize to a large value
    double avx2_blocking_minimum_time = 1000.0; // Initialize to a large value
    double sse_minimum_time = 1000.0; // Initialize to a large value
    double naive_minimum_time = 1000.0; // Initialize to a large value
    double blocking_minimum_time = 1000.0; // Initialize to a large value
    // Initialize A with some values
    for (int i = 0; i < 4096; i++) {
        for (int j = 0; j < 4096; j++) {
            A[i][j] = (float)(i * 4096 + j + 0.5);
        }
    }

    for (int i = 0; i < 3; i++) 
    {
        for (int i = 0; i < 4096; i++) {
            for (int j = 0; j < 4096; j++) {
                B[i][j] = (float)0.0; // Clear B before each run
                C[i][j] = (float)0.0; // Clear C before each run
                D[i][j] = (float)0.0; // Clear D before each run
                E[i][j] = (float)0.0; // Clear E before each run
                F[i][j] = (float)0.0; // Clear F before each run
            }
        }

        clock_gettime(CLOCK_MONOTONIC, &start);
        // Call the naive transpose function
        matrix_transpose_naive(&A[0][0], &E[0][0]);

        clock_gettime(CLOCK_MONOTONIC, &end);

        if (get_time_diff(start, end) < naive_minimum_time) 
            naive_minimum_time = get_time_diff(start, end);

        clock_gettime(CLOCK_MONOTONIC, &start);
        // Call the blocking transpose function
        matrix_transpose_blocking(&A[0][0], &F[0][0]); 

        clock_gettime(CLOCK_MONOTONIC, &end);

        if (get_time_diff(start, end) < blocking_minimum_time) 
            blocking_minimum_time = get_time_diff(start, end);

        clock_gettime(CLOCK_MONOTONIC, &start);
        // Call the transpose function
        matrix_transpose_sse(&A[0][0], &D[0][0]);

        clock_gettime(CLOCK_MONOTONIC, &end);

        if (get_time_diff(start, end) < sse_minimum_time) 
            sse_minimum_time = get_time_diff(start, end);

        clock_gettime(CLOCK_MONOTONIC, &start);
        // Call the transpose function
        matrix_transpose_avx2(&A[0][0], &B[0][0]);

        clock_gettime(CLOCK_MONOTONIC, &end);

        if (get_time_diff(start, end) < avx2_minimum_time) 
            avx2_minimum_time = get_time_diff(start, end);

        clock_gettime(CLOCK_MONOTONIC, &start);
        // Call the blocking transpose function
        matrix_transpose_avx2_blocking(&A[0][0], &C[0][0]);

        clock_gettime(CLOCK_MONOTONIC, &end);

        if (get_time_diff(start, end) < avx2_blocking_minimum_time) 
            avx2_blocking_minimum_time = get_time_diff(start, end);
    }

    double avx2_accelerate_rate = naive_minimum_time / avx2_minimum_time;
    double avx2_blocking_accelerate_rate = naive_minimum_time / avx2_blocking_minimum_time;
    double sse_accelerate_rate = naive_minimum_time / sse_minimum_time;
    double blocking_accelerate_rate = naive_minimum_time / blocking_minimum_time;
    double naive_accelerate_rate = 1.0; // Naive is the baseline

    printf("Matrix Transpose Performance (Minimum Time over 3 runs):\n");
    printf("--------------------------------------------------------\n");
    printf("Approach\t\t|Time (ms)\t|Accelerate Rate\n");
    printf("Naive\t\t\t|%.3f ms\t|%.2fx\n", naive_minimum_time, naive_accelerate_rate);
    printf("Blocking Transpose\t|%.3f ms\t|%.2fx\n", blocking_minimum_time, blocking_accelerate_rate);
    printf("SSE Transpose\t\t|%.3f ms\t|%.2fx\n", sse_minimum_time, sse_accelerate_rate);
    printf("AVX2 Transpose\t\t|%.3f ms\t|%.2fx\n", avx2_minimum_time, avx2_accelerate_rate);
    printf("AVX2 Blocking Transpose\t|%.3f ms\t|%.2fx\n", avx2_blocking_minimum_time, avx2_blocking_accelerate_rate);
    printf("--------------------------------------------------------\n\n\n");
    printf("Naive Transposed Matrix verification\n");
    // print a 5x5 block of the transposed matrix E to verify correctness
    for (int i = 4000; i < 4005; i++) {
        for (int j = 1200; j < 1205; j++) {
            printf("%.1f ", E[i][j]);
        }
        printf("\n");
    }

    printf("Blocking Transposed Matrix verification\n");
    // print a 5x5 block of the transposed matrix F to verify correctness
    for (int i = 4000; i < 4005; i++) {
        for (int j = 1200; j < 1205; j++) {
            printf("%.1f ", F[i][j]);
        }
        printf("\n");
    }

    printf("SSE Transposed Matrix verification\n");
    // print a 5x5 block of the transposed matrix D to verify correctness
    for (int i = 4000; i < 4005; i++) {
        for (int j = 1200; j < 1205; j++) {
            printf("%.1f ", D[i][j]);
        }
        printf("\n");
    }

    printf("AVX2 Transposed Matrix verification\n");
    // print a 5x5 block of the transposed matrix B to verify correctness
    for (int i = 4000; i < 4005; i++) {
        for (int j = 1200; j < 1205; j++) {
            printf("%.1f ", B[i][j]);
        }
        printf("\n");
    }

    printf("AVX2 Blocking Transposed Matrix verification\n");
    // print a 5x5 block of the transposed matrix C to verify correctness
    for (int i = 4000; i < 4005; i++) {
        for (int j = 1200; j < 1205; j++) {
            printf("%.1f ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}