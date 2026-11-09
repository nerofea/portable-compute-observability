#include "deferred_count.h"

#include <cub/device/device_reduce.cuh>
#include <cuda/argument>
#include <cuda/std/functional>
#include <cuda_runtime.h>

#include <cstdint>
#include <limits>

__global__ void dc_fill(int* input, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) input[i] = 1;
}

__global__ void dc_set_count(int* count, int n) {
    if (blockIdx.x == 0 && threadIdx.x == 0)
        *count = n;
}

extern "C" int32_t dc_run(
    uint64_t capacity,
    uint64_t selected,
    dc_result* result
) {
    if (!result || capacity == 0 || selected > capacity ||
        capacity > static_cast<uint64_t>(INT32_MAX))
        return -1;

    result->status = -2;
    result->elapsed_ms = 0.0f;
    result->selected = selected;

    int* input = nullptr;
    int* output = nullptr;
    int* device_count = nullptr;

    cudaEvent_t start = nullptr;
    cudaEvent_t stop = nullptr;
    cudaError_t error = cudaSuccess;

    float elapsed = 0.0f;
    int actual = -1;

#define DC_CHECK(expr) do { \
    error = (expr); \
    if (error != cudaSuccess) goto cleanup; \
} while (0)

    DC_CHECK(cudaMalloc(
        reinterpret_cast<void**>(&input),
        capacity * sizeof(int)));

    DC_CHECK(cudaMalloc(
        reinterpret_cast<void**>(&output),
        sizeof(int)));

    DC_CHECK(cudaMalloc(
        reinterpret_cast<void**>(&device_count),
        sizeof(int)));

    dc_fill<<<
        (static_cast<int64_t>(capacity) + 255) / 256,
        256
    >>>(input, static_cast<int>(capacity));

    DC_CHECK(cudaGetLastError());

    dc_set_count<<<1, 1>>>(
        device_count, static_cast<int>(selected));

    DC_CHECK(cudaGetLastError());

    DC_CHECK(cudaEventCreate(&start));
    DC_CHECK(cudaEventCreate(&stop));

    DC_CHECK(cudaEventRecord(start));

    DC_CHECK(cub::DeviceReduce::Reduce(
        input,
        output,
        cuda::args::deferred{device_count},
        cuda::std::plus<>{},
        0
    ));

    DC_CHECK(cudaEventRecord(stop));
    DC_CHECK(cudaEventSynchronize(stop));
    DC_CHECK(cudaEventElapsedTime(
        &elapsed, start, stop));

    DC_CHECK(cudaMemcpy(
        &actual,
        output,
        sizeof(int),
        cudaMemcpyDeviceToHost));

    if (actual != static_cast<int>(selected)) {
        result->status = -3;
        goto cleanup;
    }

    result->status = 0;
    result->elapsed_ms = elapsed;

cleanup:
    if (error != cudaSuccess)
        result->status = static_cast<int32_t>(error);

    if (start) cudaEventDestroy(start);
    if (stop) cudaEventDestroy(stop);
    if (input) cudaFree(input);
    if (output) cudaFree(output);
    if (device_count) cudaFree(device_count);

#undef DC_CHECK

    return result->status;
}
