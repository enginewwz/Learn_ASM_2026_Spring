import time
import numpy as np

# main function to test the matrix multiplication
if __name__ == "__main__":
    size = 4096

    A_np = np.zeros((size, size), dtype=np.int64)
    B_np = np.zeros((size, size), dtype=np.int64)

    start_time = time.perf_counter()
    _ = A_np @ B_np
    end_time = time.perf_counter()
    time_taken = end_time - start_time
    # print(f"NumPy time taken: {time_taken:.6f} seconds")