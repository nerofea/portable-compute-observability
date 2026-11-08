#include <metal_stdlib>
using namespace metal;
kernel void pco_gemm_f32(device const float *a [[buffer(0)]],
 device const float *b [[buffer(1)]],device float *c [[buffer(2)]],
 constant uint &n [[buffer(3)]],uint2 gid [[thread_position_in_grid]]) {
 if(gid.x>=n||gid.y>=n)return;
 float sum=0.0f;
 for(uint k=0;k<n;k++)sum=fma(a[gid.y*n+k],b[k*n+gid.x],sum);
 c[gid.y*n+gid.x]=sum;
}
kernel void pco_gemm_f16(device const half *a [[buffer(0)]],
 device const half *b [[buffer(1)]],device float *c [[buffer(2)]],
 constant uint &n [[buffer(3)]],uint2 gid [[thread_position_in_grid]]) {
 if(gid.x>=n||gid.y>=n)return;
 float sum=0.0f;
 for(uint k=0;k<n;k++)sum=fma(float(a[gid.y*n+k]),float(b[k*n+gid.x]),sum);
 c[gid.y*n+gid.x]=sum;
}
kernel void pco_dot_partial(device const float *a [[buffer(0)]],
 device const float *b [[buffer(1)]],device float *partial [[buffer(2)]],
 constant uint &n [[buffer(3)]],uint tid [[thread_position_in_grid]]) {
 if(tid>=n)return;
 partial[tid]=a[tid]*b[tid];
}
