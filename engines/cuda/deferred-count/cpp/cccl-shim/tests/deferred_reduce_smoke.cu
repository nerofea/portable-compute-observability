#include <cub/device/device_reduce.cuh>
#include <cuda/argument>
#include <cuda/std/functional>
#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <initializer_list>

#define CHECK(x) do { auto e = (x); if (e != cudaSuccess) { \
  fprintf(stderr, "%s\n", cudaGetErrorString(e)); exit(1); \
} } while (0)

__global__ void set_count(int* count, int n) {
  if (threadIdx.x == 0) *count = n;
}

__global__ void fill(int* input, int n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) input[i] = 1;
}

int main() {
  constexpr int N = 1024;
  int *input, *output, *count;
  CHECK(cudaMalloc((void**)&input, N * sizeof(int)));
  CHECK(cudaMalloc((void**)&output, sizeof(int)));
  CHECK(cudaMalloc((void**)&count, sizeof(int)));

  fill<<<4, 256>>>(input, N);
  CHECK(cudaGetLastError());

  for (int n : {1024, 513, 1}) {
    set_count<<<1, 1>>>(count, n);
    CHECK(cudaGetLastError());

    CHECK(cub::DeviceReduce::Reduce(
      input, output, cuda::args::deferred{count},
      cuda::std::plus<>{}, 0
    ));

    CHECK(cudaDeviceSynchronize());

    int result = 0;
    CHECK(cudaMemcpy(&result, output, sizeof(int),
                     cudaMemcpyDeviceToHost));
    printf("count=%d result=%d expected=%d\n", n, result, n);
    if (result != n) return 1;
  }

  CHECK(cudaFree(input));
  CHECK(cudaFree(output));
  CHECK(cudaFree(count));
  puts("PASS: deferred reduction GPU smoke test");
  return 0;
}
