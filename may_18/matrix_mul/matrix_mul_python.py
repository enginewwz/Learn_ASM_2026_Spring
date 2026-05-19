# matrix multiplication in Python
def matrix_multiply_naive(A, B):
    if not A or not B or len(A[0]) != len(B):
        raise ValueError("Incompatible matrix dimensions")

    result = [[0 for _ in range(len(B[0]))] for _ in range(len(A))]
    for i in range(len(A)):
        for j in range(len(B[0])):
            for k in range(len(B)):
                result[i][j] += A[i][k] * B[k][j]
    return result

import time
import numpy as np

# main function to test the matrix multiplication
if __name__ == "__main__":
    size = 4096

    # # Example matrices
    # A = [[0 for _ in range(size)] for _ in range(size)]
    # B = [[0 for _ in range(size)] for _ in range(size)]

    # start_time = time.perf_counter()
    # _ = matrix_multiply_naive(A, B)
    # end_time = time.perf_counter()
    # print(f"Naive time taken: {end_time - start_time:.6f} seconds")

    A_np = np.zeros((size, size), dtype=np.int64)
    B_np = np.zeros((size, size), dtype=np.int64)

    start_time = time.perf_counter()
    _ = A_np @ B_np
    end_time = time.perf_counter()
    print(f"NumPy time taken: {end_time - start_time:.6f} seconds")