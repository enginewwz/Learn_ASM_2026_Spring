// matrix multiplication with blocking
// a function to multiply 4096x4096 matrices using C

void matrix_mul_c_blockings(float * __restrict__ A, float * __restrict__ B, float * __restrict__ C) {
    int block_size = 64; // block size for blocking
    for (int i = 0; i < 4096; i += block_size) {
        for (int j = 0; j < 4096; j += block_size) {
            for (int k = 0; k < 4096; k += block_size) {
                // multiply the blocks
                for (int ii = i; ii < i + block_size && ii < 4096; ii++) {
                    int ii_4096 = ii * 4096; // precompute for better cache performance
                    for (int jj = j; jj < j + block_size && jj < 4096; jj++) {
                        float sum = 0;
                        for (int kk = k; kk < k + block_size && kk < 4096; kk++) {
                            sum += A[ii_4096 + kk] * B[kk * 4096 + jj];
                        }
                        C[ii_4096 + jj] += sum;
                    }
                }
            }
        }
    }
}