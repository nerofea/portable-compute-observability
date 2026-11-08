# Portable Compute Observability — Benchmark Report

Session: `20261108T180738Z-bea5173f`

**Completed:** 27 | **Failed:** 0 | **Skipped:** 3

## Backend execution

| Backend | Status | Wall time (ms) | Samples | Notes |
|---|---|---:|---:|---|
| tensor_nd_repeat_01 | ok | 1639.406417 | 9000 |  |
| tensor_nd_repeat_02 | ok | 1464.162625 | 9000 |  |
| tensor_nd_repeat_03 | ok | 1466.92825 | 9000 |  |
| rust_cpu_repeat_01 | ok | 300.910667 | 120 |  |
| rust_cpu_repeat_02 | ok | 180.327166 | 120 |  |
| rust_cpu_repeat_03 | ok | 175.232584 | 120 |  |
| precision_repeat_01 | ok | 424.924458 | 500 |  |
| precision_repeat_02 | ok | 217.223208 | 500 |  |
| precision_repeat_03 | ok | 217.635791 | 500 |  |
| metal_repeat_01 | ok | 966.185208 | 400 |  |
| metal_repeat_02 | ok | 877.962458 | 400 |  |
| metal_repeat_03 | ok | 854.595 | 400 |  |
| metal_tensor_repeat_01 | ok | 1082.498292 | 300 |  |
| metal_tensor_repeat_02 | ok | 941.222083 | 300 |  |
| metal_tensor_repeat_03 | ok | 944.347417 | 300 |  |
| metal_kernel_counters_repeat_01 | ok | 891.302167 | 100 |  |
| metal_kernel_counters_repeat_02 | ok | 711.520042 | 100 |  |
| metal_kernel_counters_repeat_03 | ok | 703.66725 | 100 |  |
| wgpu_repeat_01 | ok | 601.553125 | 100 |  |
| wgpu_repeat_02 | ok | 418.0405 | 100 |  |
| wgpu_repeat_03 | ok | 408.501 | 100 |  |
| accelerate_repeat_01 | ok | 772.324333 | 100 |  |
| accelerate_repeat_02 | ok | 630.12725 | 100 |  |
| accelerate_repeat_03 | ok | 607.464417 | 100 |  |
| mlx_repeat_01 | ok | 525.834666 | 100 |  |
| mlx_repeat_02 | ok | 169.74875 | 100 |  |
| mlx_repeat_03 | ok | 165.996375 | 100 |  |
| mlx_compute_repeat_01 | skipped | — | — | Missing executable: python |
| mlx_compute_repeat_02 | skipped | — | — | Missing executable: python |
| mlx_compute_repeat_03 | skipped | — | — | Missing executable: python |

## Kernel metrics (nanoseconds)

These are **not cross-backend speedups**: each backend may measure a different scope.

| Backend | Workload | Elements | Precision | Timing scope | N | Median ns | p95 ns | p99 ns |
|---|---|---:|---|---|---:|---:|---:|---:|
| tensor_nd_repeat_01 | add | 262144 | bf16 | elapsed_ns | 100 | 44084 | 49667 | 53291 |
| tensor_nd_repeat_01 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 44042 | 49417 | 51458 |
| tensor_nd_repeat_01 | add | 262144 | f32 | elapsed_ns | 100 | 44250 | 47042 | 59791 |
| tensor_nd_repeat_01 | add | 262144 | fp16 | elapsed_ns | 100 | 44125 | 54042 | 59583 |
| tensor_nd_repeat_01 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 44209 | 47083 | 51959 |
| tensor_nd_repeat_01 | add | 32768 | bf16 | elapsed_ns | 100 | 5583 | 7083 | 7625 |
| tensor_nd_repeat_01 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 5625 | 6333 | 7334 |
| tensor_nd_repeat_01 | add | 32768 | f32 | elapsed_ns | 100 | 5583 | 6292 | 8500 |
| tensor_nd_repeat_01 | add | 32768 | fp16 | elapsed_ns | 100 | 5584 | 6041 | 6709 |
| tensor_nd_repeat_01 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 5625 | 5958 | 7000 |
| tensor_nd_repeat_01 | add | 4096 | bf16 | elapsed_ns | 100 | 584 | 666 | 708 |
| tensor_nd_repeat_01 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_01 | add | 4096 | f32 | elapsed_ns | 100 | 584 | 708 | 1042 |
| tensor_nd_repeat_01 | add | 4096 | fp16 | elapsed_ns | 100 | 584 | 667 | 709 |
| tensor_nd_repeat_01 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 584 | 667 | 709 |
| tensor_nd_repeat_01 | add | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | add | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | add | 512 | fp16 | elapsed_ns | 100 | 42 | 84 | 125 |
| tensor_nd_repeat_01 | add | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 42 | 42 |
| tensor_nd_repeat_01 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | add | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 42 | 84 |
| tensor_nd_repeat_01 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 42 | 42 |
| tensor_nd_repeat_01 | add | 8 | bf16 | elapsed_ns | 100 | 83 | 84 | 166 |
| tensor_nd_repeat_01 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | add | 8 | f32 | elapsed_ns | 100 | 84 | 208 | 2542 |
| tensor_nd_repeat_01 | add | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_01 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 745375 | 759291 | 763292 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 742666 | 758708 | 764041 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 745146 | 773292 | 799750 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 745104 | 762917 | 777458 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 743458 | 753458 | 767375 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 95875 | 98875 | 102542 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 94250 | 94542 | 99000 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 98833 | 102084 | 112084 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 93375 | 97333 | 103000 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 94250 | 97416 | 105209 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 11833 | 11875 | 11917 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 12500 | 13833 | 13875 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 11730 | 11792 | 11833 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 11833 | 13834 | 14084 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 13792 | 13834 | 13917 |
| tensor_nd_repeat_01 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1500 | 1500 | 1500 |
| tensor_nd_repeat_01 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1500 | 1542 | 1625 |
| tensor_nd_repeat_01 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1500 | 1500 | 1542 |
| tensor_nd_repeat_01 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1500 | 1500 | 1500 |
| tensor_nd_repeat_01 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1500 | 1500 | 1583 |
| tensor_nd_repeat_01 | dot | 8 | bf16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | fp16 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_01 | matmul | 64 | bf16 | elapsed_ns | 100 | 208 | 209 | 250 |
| tensor_nd_repeat_01 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_01 | matmul | 64 | f32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_01 | matmul | 64 | fp16 | elapsed_ns | 100 | 208 | 209 | 209 |
| tensor_nd_repeat_01 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 208 | 250 | 333 |
| tensor_nd_repeat_01 | multiply | 262144 | bf16 | elapsed_ns | 100 | 44208 | 52291 | 58375 |
| tensor_nd_repeat_01 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 44209 | 53875 | 56958 |
| tensor_nd_repeat_01 | multiply | 262144 | f32 | elapsed_ns | 100 | 44084 | 49084 | 59208 |
| tensor_nd_repeat_01 | multiply | 262144 | fp16 | elapsed_ns | 100 | 44041 | 49916 | 62750 |
| tensor_nd_repeat_01 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 44083 | 53417 | 59750 |
| tensor_nd_repeat_01 | multiply | 32768 | bf16 | elapsed_ns | 100 | 5584 | 6208 | 8416 |
| tensor_nd_repeat_01 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5625 | 8375 | 9292 |
| tensor_nd_repeat_01 | multiply | 32768 | f32 | elapsed_ns | 100 | 5625 | 7792 | 8375 |
| tensor_nd_repeat_01 | multiply | 32768 | fp16 | elapsed_ns | 100 | 5584 | 6875 | 7917 |
| tensor_nd_repeat_01 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5584 | 6083 | 6875 |
| tensor_nd_repeat_01 | multiply | 4096 | bf16 | elapsed_ns | 100 | 666 | 750 | 750 |
| tensor_nd_repeat_01 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 708 | 792 |
| tensor_nd_repeat_01 | multiply | 4096 | f32 | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_01 | multiply | 4096 | fp16 | elapsed_ns | 100 | 625 | 708 | 917 |
| tensor_nd_repeat_01 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_01 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 42 |
| tensor_nd_repeat_01 | multiply | 8 | f32 | elapsed_ns | 100 | 83 | 84 | 542 |
| tensor_nd_repeat_01 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 262144 | bf16 | elapsed_ns | 100 | 44000 | 50667 | 59666 |
| tensor_nd_repeat_02 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 43916 | 50958 | 61959 |
| tensor_nd_repeat_02 | add | 262144 | f32 | elapsed_ns | 100 | 44000 | 47417 | 49084 |
| tensor_nd_repeat_02 | add | 262144 | fp16 | elapsed_ns | 100 | 44000 | 49209 | 52291 |
| tensor_nd_repeat_02 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 44000 | 53792 | 61583 |
| tensor_nd_repeat_02 | add | 32768 | bf16 | elapsed_ns | 100 | 5583 | 6250 | 7583 |
| tensor_nd_repeat_02 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 5583 | 8625 | 10041 |
| tensor_nd_repeat_02 | add | 32768 | f32 | elapsed_ns | 100 | 5542 | 6167 | 8416 |
| tensor_nd_repeat_02 | add | 32768 | fp16 | elapsed_ns | 100 | 5583 | 6208 | 8958 |
| tensor_nd_repeat_02 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 5583 | 5667 | 6417 |
| tensor_nd_repeat_02 | add | 4096 | bf16 | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_02 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_02 | add | 4096 | f32 | elapsed_ns | 100 | 625 | 667 | 750 |
| tensor_nd_repeat_02 | add | 4096 | fp16 | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_02 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_02 | add | 512 | bf16 | elapsed_ns | 100 | 42 | 84 | 125 |
| tensor_nd_repeat_02 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_02 | add | 512 | f32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | add | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_02 | add | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_02 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 83 |
| tensor_nd_repeat_02 | add | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_02 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 8 | bf16 | elapsed_ns | 100 | 42 | 84 | 125 |
| tensor_nd_repeat_02 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 8 | f32 | elapsed_ns | 100 | 83 | 583 | 2333 |
| tensor_nd_repeat_02 | add | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 765042 | 788708 | 790000 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 751896 | 790208 | 798334 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 765188 | 788750 | 793375 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 765042 | 791333 | 796209 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 745291 | 787917 | 792167 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 98125 | 112083 | 121792 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 95500 | 98666 | 100834 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 95250 | 98625 | 104375 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 98520 | 101875 | 107791 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 96250 | 99792 | 104916 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 11750 | 12041 | 12042 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 12041 | 12083 | 12334 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 11750 | 12042 | 12209 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 11959 | 12000 | 12042 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 12000 | 12083 | 12125 |
| tensor_nd_repeat_02 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1459 | 1583 | 1584 |
| tensor_nd_repeat_02 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1541 | 1583 | 1667 |
| tensor_nd_repeat_02 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1541 | 1584 | 1625 |
| tensor_nd_repeat_02 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1459 | 1500 | 1500 |
| tensor_nd_repeat_02 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1459 | 1500 | 1541 |
| tensor_nd_repeat_02 | dot | 8 | bf16 | elapsed_ns | 100 | 20 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 417 |
| tensor_nd_repeat_02 | dot | 8 | fp16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_02 | matmul | 64 | bf16 | elapsed_ns | 100 | 209 | 250 | 250 |
| tensor_nd_repeat_02 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 209 | 250 | 375 |
| tensor_nd_repeat_02 | matmul | 64 | f32 | elapsed_ns | 100 | 208 | 250 | 334 |
| tensor_nd_repeat_02 | matmul | 64 | fp16 | elapsed_ns | 100 | 250 | 250 | 291 |
| tensor_nd_repeat_02 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 250 | 250 | 250 |
| tensor_nd_repeat_02 | multiply | 262144 | bf16 | elapsed_ns | 100 | 44062 | 52000 | 61750 |
| tensor_nd_repeat_02 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 44042 | 53792 | 57916 |
| tensor_nd_repeat_02 | multiply | 262144 | f32 | elapsed_ns | 100 | 51124 | 59375 | 72917 |
| tensor_nd_repeat_02 | multiply | 262144 | fp16 | elapsed_ns | 100 | 44125 | 55375 | 57041 |
| tensor_nd_repeat_02 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 43938 | 54833 | 61583 |
| tensor_nd_repeat_02 | multiply | 32768 | bf16 | elapsed_ns | 100 | 7584 | 9458 | 12833 |
| tensor_nd_repeat_02 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5542 | 6084 | 7292 |
| tensor_nd_repeat_02 | multiply | 32768 | f32 | elapsed_ns | 100 | 5583 | 5667 | 7333 |
| tensor_nd_repeat_02 | multiply | 32768 | fp16 | elapsed_ns | 100 | 5542 | 8542 | 9125 |
| tensor_nd_repeat_02 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5542 | 7125 | 9166 |
| tensor_nd_repeat_02 | multiply | 4096 | bf16 | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_02 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_02 | multiply | 4096 | f32 | elapsed_ns | 100 | 625 | 667 | 709 |
| tensor_nd_repeat_02 | multiply | 4096 | fp16 | elapsed_ns | 100 | 625 | 667 | 709 |
| tensor_nd_repeat_02 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 708 |
| tensor_nd_repeat_02 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_02 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 62 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 42 |
| tensor_nd_repeat_02 | multiply | 8 | f32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | add | 262144 | bf16 | elapsed_ns | 100 | 44083 | 49166 | 55208 |
| tensor_nd_repeat_03 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 44062 | 48750 | 53916 |
| tensor_nd_repeat_03 | add | 262144 | f32 | elapsed_ns | 100 | 44104 | 49584 | 57916 |
| tensor_nd_repeat_03 | add | 262144 | fp16 | elapsed_ns | 100 | 43875 | 50042 | 55625 |
| tensor_nd_repeat_03 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 44084 | 52500 | 59916 |
| tensor_nd_repeat_03 | add | 32768 | bf16 | elapsed_ns | 100 | 5417 | 6500 | 7500 |
| tensor_nd_repeat_03 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 5417 | 5958 | 7083 |
| tensor_nd_repeat_03 | add | 32768 | f32 | elapsed_ns | 100 | 5417 | 5542 | 6583 |
| tensor_nd_repeat_03 | add | 32768 | fp16 | elapsed_ns | 100 | 5500 | 6000 | 8250 |
| tensor_nd_repeat_03 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 5458 | 6000 | 7167 |
| tensor_nd_repeat_03 | add | 4096 | bf16 | elapsed_ns | 100 | 666 | 708 | 750 |
| tensor_nd_repeat_03 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 604 | 667 | 708 |
| tensor_nd_repeat_03 | add | 4096 | f32 | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_03 | add | 4096 | fp16 | elapsed_ns | 100 | 625 | 667 | 708 |
| tensor_nd_repeat_03 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 792 |
| tensor_nd_repeat_03 | add | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | add | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | add | 512 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 512 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_03 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 125 |
| tensor_nd_repeat_03 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | add | 8 | bf16 | elapsed_ns | 100 | 42 | 125 | 541 |
| tensor_nd_repeat_03 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 8 | f32 | elapsed_ns | 100 | 84 | 209 | 2333 |
| tensor_nd_repeat_03 | add | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 768771 | 796000 | 801500 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 763250 | 788750 | 792625 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 771958 | 795917 | 803250 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 760625 | 795375 | 797084 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 759438 | 787500 | 796209 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 98750 | 101917 | 102667 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 95334 | 102041 | 105417 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 95083 | 98292 | 106542 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 98792 | 101125 | 102000 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 98958 | 99458 | 105041 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 12438 | 13084 | 14209 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 12000 | 12458 | 12500 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 11959 | 12083 | 12125 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 12459 | 12791 | 14292 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 12500 | 12542 | 12666 |
| tensor_nd_repeat_03 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1500 | 1500 | 1625 |
| tensor_nd_repeat_03 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1542 | 1625 | 1667 |
| tensor_nd_repeat_03 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1500 | 1542 | 1542 |
| tensor_nd_repeat_03 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1500 | 1541 | 1542 |
| tensor_nd_repeat_03 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1500 | 1500 | 1625 |
| tensor_nd_repeat_03 | dot | 8 | bf16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 375 |
| tensor_nd_repeat_03 | dot | 8 | fp16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | matmul | 64 | bf16 | elapsed_ns | 100 | 209 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | f32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | fp16 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 208 | 250 | 292 |
| tensor_nd_repeat_03 | multiply | 262144 | bf16 | elapsed_ns | 100 | 44000 | 49667 | 55500 |
| tensor_nd_repeat_03 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 43834 | 55292 | 58291 |
| tensor_nd_repeat_03 | multiply | 262144 | f32 | elapsed_ns | 100 | 43833 | 46625 | 52125 |
| tensor_nd_repeat_03 | multiply | 262144 | fp16 | elapsed_ns | 100 | 44083 | 55167 | 60875 |
| tensor_nd_repeat_03 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 44000 | 49375 | 58084 |
| tensor_nd_repeat_03 | multiply | 32768 | bf16 | elapsed_ns | 100 | 5417 | 5917 | 6791 |
| tensor_nd_repeat_03 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5459 | 5958 | 6292 |
| tensor_nd_repeat_03 | multiply | 32768 | f32 | elapsed_ns | 100 | 5417 | 6916 | 8125 |
| tensor_nd_repeat_03 | multiply | 32768 | fp16 | elapsed_ns | 100 | 5458 | 6000 | 7333 |
| tensor_nd_repeat_03 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5459 | 6916 | 7875 |
| tensor_nd_repeat_03 | multiply | 4096 | bf16 | elapsed_ns | 100 | 584 | 667 | 667 |
| tensor_nd_repeat_03 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_03 | multiply | 4096 | f32 | elapsed_ns | 100 | 584 | 667 | 709 |
| tensor_nd_repeat_03 | multiply | 4096 | fp16 | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_03 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_03 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_03 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_03 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_03 | multiply | 8 | f32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| rust_cpu_repeat_01 | copy | 1024 | unspecified | latency_ns | 15 | 125 | 125 | 125 |
| rust_cpu_repeat_01 | copy | 65536 | unspecified | latency_ns | 15 | 7416 | 7417 | 7459 |
| rust_cpu_repeat_01 | scale | 1024 | unspecified | latency_ns | 15 | 125 | 125 | 125 |
| rust_cpu_repeat_01 | scale | 65536 | unspecified | latency_ns | 15 | 8333 | 8584 | 8916 |
| rust_cpu_repeat_01 | triad | 1024 | unspecified | latency_ns | 15 | 125 | 167 | 167 |
| rust_cpu_repeat_01 | triad | 65536 | unspecified | latency_ns | 15 | 11500 | 12042 | 12167 |
| rust_cpu_repeat_01 | vector_add | 1024 | unspecified | latency_ns | 15 | 125 | 125 | 167 |
| rust_cpu_repeat_01 | vector_add | 65536 | unspecified | latency_ns | 15 | 13375 | 13666 | 13667 |
| rust_cpu_repeat_02 | copy | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_02 | copy | 65536 | unspecified | latency_ns | 15 | 5084 | 5125 | 5125 |
| rust_cpu_repeat_02 | scale | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_02 | scale | 65536 | unspecified | latency_ns | 15 | 5834 | 5875 | 5875 |
| rust_cpu_repeat_02 | triad | 1024 | unspecified | latency_ns | 15 | 83 | 125 | 125 |
| rust_cpu_repeat_02 | triad | 65536 | unspecified | latency_ns | 15 | 8208 | 9041 | 9208 |
| rust_cpu_repeat_02 | vector_add | 1024 | unspecified | latency_ns | 15 | 84 | 125 | 208 |
| rust_cpu_repeat_02 | vector_add | 65536 | unspecified | latency_ns | 15 | 9167 | 10459 | 10500 |
| rust_cpu_repeat_03 | copy | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_03 | copy | 65536 | unspecified | latency_ns | 15 | 5084 | 5750 | 5791 |
| rust_cpu_repeat_03 | scale | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_03 | scale | 65536 | unspecified | latency_ns | 15 | 5667 | 5750 | 5750 |
| rust_cpu_repeat_03 | triad | 1024 | unspecified | latency_ns | 15 | 83 | 125 | 125 |
| rust_cpu_repeat_03 | triad | 65536 | unspecified | latency_ns | 15 | 9042 | 9125 | 9209 |
| rust_cpu_repeat_03 | vector_add | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_03 | vector_add | 65536 | unspecified | latency_ns | 15 | 10333 | 10416 | 10500 |
| precision_repeat_01 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 80250 | 81042 | 86834 |
| precision_repeat_01 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 50417 | 50542 | 55625 |
| precision_repeat_01 | vector_add | 65536 | f32 | elapsed_ns | 100 | 104958 | 125958 | 126083 |
| precision_repeat_01 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 61416 | 66000 | 66042 |
| precision_repeat_01 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 54333 | 54625 | 57417 |
| precision_repeat_02 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 54771 | 58125 | 61208 |
| precision_repeat_02 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 45792 | 49500 | 51250 |
| precision_repeat_02 | vector_add | 65536 | f32 | elapsed_ns | 100 | 65980 | 72375 | 75417 |
| precision_repeat_02 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 52292 | 55209 | 59625 |
| precision_repeat_02 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 48438 | 51792 | 55000 |
| precision_repeat_03 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 57667 | 61500 | 62750 |
| precision_repeat_03 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 45792 | 46000 | 48667 |
| precision_repeat_03 | vector_add | 65536 | f32 | elapsed_ns | 100 | 66188 | 72000 | 78875 |
| precision_repeat_03 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 52292 | 54542 | 57458 |
| precision_repeat_03 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 50375 | 50541 | 53709 |
| metal_repeat_01 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 223937 | 254834 | 258500 |
| metal_repeat_01 | gather | 65536 | unspecified | gpu_command_ns | 100 | 17521 | 21750 | 22375 |
| metal_repeat_01 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 291062 | 307000 | 311708 |
| metal_repeat_01 | scale | 65536 | unspecified | gpu_command_ns | 100 | 11583 | 11875 | 12375 |
| metal_repeat_01 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 293416 | 310875 | 316959 |
| metal_repeat_01 | triad | 65536 | unspecified | gpu_command_ns | 100 | 17792 | 18250 | 18458 |
| metal_repeat_01 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 293396 | 311625 | 320750 |
| metal_repeat_01 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 17958 | 18917 | 45917 |
| metal_repeat_02 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 286459 | 318834 | 428417 |
| metal_repeat_02 | gather | 65536 | unspecified | gpu_command_ns | 100 | 18250 | 19125 | 19708 |
| metal_repeat_02 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 328396 | 412708 | 440875 |
| metal_repeat_02 | scale | 65536 | unspecified | gpu_command_ns | 100 | 13250 | 21250 | 21625 |
| metal_repeat_02 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 297604 | 364459 | 412584 |
| metal_repeat_02 | triad | 65536 | unspecified | gpu_command_ns | 100 | 26125 | 29125 | 32500 |
| metal_repeat_02 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 314229 | 542209 | 623542 |
| metal_repeat_02 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 19750 | 34417 | 38250 |
| metal_repeat_03 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 288770 | 307666 | 316084 |
| metal_repeat_03 | gather | 65536 | unspecified | gpu_command_ns | 100 | 18438 | 19250 | 19875 |
| metal_repeat_03 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 336042 | 381125 | 422209 |
| metal_repeat_03 | scale | 65536 | unspecified | gpu_command_ns | 100 | 13250 | 13375 | 17375 |
| metal_repeat_03 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 306500 | 364125 | 395583 |
| metal_repeat_03 | triad | 65536 | unspecified | gpu_command_ns | 100 | 25500 | 26250 | 33375 |
| metal_repeat_03 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 327980 | 355666 | 368167 |
| metal_repeat_03 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 18083 | 19833 | 28708 |
| metal_tensor_repeat_01 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 329980 | 384166 | 402667 |
| metal_tensor_repeat_01 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 3000 | 3583 | 3625 |
| metal_tensor_repeat_01 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 445667 | 524083 | 571000 |
| metal_tensor_repeat_01 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 53500 | 54708 | 54750 |
| metal_tensor_repeat_01 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 420271 | 481209 | 489500 |
| metal_tensor_repeat_01 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39750 | 42250 | 44958 |
| metal_tensor_repeat_02 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 272354 | 319250 | 354416 |
| metal_tensor_repeat_02 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 3292 | 4208 | 4375 |
| metal_tensor_repeat_02 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 370646 | 465625 | 486666 |
| metal_tensor_repeat_02 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 45125 | 52125 | 60708 |
| metal_tensor_repeat_02 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 342729 | 397292 | 450917 |
| metal_tensor_repeat_02 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39938 | 42500 | 50375 |
| metal_tensor_repeat_03 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 282479 | 383750 | 455084 |
| metal_tensor_repeat_03 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 3333 | 6000 | 7458 |
| metal_tensor_repeat_03 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 372542 | 435458 | 477625 |
| metal_tensor_repeat_03 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 45250 | 51750 | 59750 |
| metal_tensor_repeat_03 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 335583 | 391125 | 439625 |
| metal_tensor_repeat_03 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39625 | 42750 | 51250 |
| metal_kernel_counters_repeat_01 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 467542 | 524042 | 563000 |
| metal_kernel_counters_repeat_01 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 36750 | 38917 | 41292 |
| metal_kernel_counters_repeat_02 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 306916 | 367958 | 498125 |
| metal_kernel_counters_repeat_02 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 18083 | 28792 | 42375 |
| metal_kernel_counters_repeat_03 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 327688 | 360708 | 403416 |
| metal_kernel_counters_repeat_03 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 18083 | 19875 | 28750 |
| wgpu_repeat_01 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1300729 | 1352500 | 1362416 |
| wgpu_repeat_02 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1293270 | 1315500 | 1324750 |
| wgpu_repeat_03 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1287021 | 1312167 | 1380875 |
| accelerate_repeat_01 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 7125 | 8417 | 10750 |
| accelerate_repeat_02 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 4916 | 4959 | 7500 |
| accelerate_repeat_03 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 4917 | 7500 | 11083 |
| mlx_repeat_01 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 321876 | 571791 | 966792 |
| mlx_repeat_02 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 339938 | 415792 | 444875 |
| mlx_repeat_03 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 340376 | 379125 | 426791 |

## Electricity, GPU, CPU and RAM telemetry

See `resources.jsonl`, `resource_summary.json`, `apple_power_components.csv` (when available), `thermal.jsonl` (when available), and `telemetry_capabilities.json`.
Missing or unauthorized sensors are **unavailable**, not zero. External calibrated power CSV, when supplied, gives whole-process joules including overhead, **not kernel-only joules**.
Apple powermetrics values are estimated component power and receipt-time stamped; they are not integrated into kernel-specific energy.

## Reproduction and artifacts

See `repeat_summary.csv` for independent repeated-run summary.

See `environment.json` for hardware, compiler and Git revision; `runs.jsonl` for backend diagnostics; `raw/` for archived CSV samples.
No backend speedup or energy-efficiency ranking is claimed without matched timing scopes and calibrated attribution.
