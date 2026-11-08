#include <metal_stdlib>
using namespace metal;

kernel void pco_vector_add(device const float *a [[buffer(0)]],
                           device const float *b [[buffer(1)]],
                           device float *out [[buffer(2)]],
                           constant uint &n [[buffer(3)]],
                           uint gid [[thread_position_in_grid]]) {
    if (gid < n) out[gid] = a[gid] + b[gid];
}
kernel void pco_scale(device const float *a [[buffer(0)]],
                      device float *out [[buffer(1)]],
                      constant float &factor [[buffer(2)]],
                      constant uint &n [[buffer(3)]],
                      uint gid [[thread_position_in_grid]]) {
    if (gid < n) out[gid] = a[gid] * factor;
}
kernel void pco_triad(device const float *a [[buffer(0)]],
                      device const float *b [[buffer(1)]],
                      device float *out [[buffer(2)]],
                      constant float &factor [[buffer(3)]],
                      constant uint &n [[buffer(4)]],
                      uint gid [[thread_position_in_grid]]) {
    if (gid < n) out[gid] = a[gid] + factor * b[gid];
}
kernel void pco_strided_gather(device const float *a [[buffer(0)]],
                               device float *out [[buffer(1)]],
                               constant uint &stride [[buffer(2)]],
                               constant uint &n [[buffer(3)]],
                               uint gid [[thread_position_in_grid]]) {
    if (gid < n) out[gid] = a[(ulong(gid) * stride) % n];
}
