# Portable Compute Observability — Benchmark Report

Session: `20261108T174611Z-8d42c1ef`

**Completed:** 21 | **Failed:** 3 | **Skipped:** 6

## Backend execution

| Backend | Status | Wall time (ms) | Samples | Notes |
|---|---|---:|---:|---|
| tensor_nd_repeat_01 | ok | 16503.621625 | 9000 |  |
| tensor_nd_repeat_02 | ok | 1467.072208 | 9000 |  |
| tensor_nd_repeat_03 | ok | 1474.586625 | 9000 |  |
| rust_cpu_repeat_01 | ok | 7296.776667 | 120 |  |
| rust_cpu_repeat_02 | ok | 182.084375 | 120 |  |
| rust_cpu_repeat_03 | ok | 183.187167 | 120 |  |
| precision_repeat_01 | ok | 1532.764792 | 500 |  |
| precision_repeat_02 | ok | 224.534584 | 500 |  |
| precision_repeat_03 | ok | 237.87975 | 500 |  |
| metal_repeat_01 | ok | 1316.225417 | 400 |  |
| metal_repeat_02 | ok | 868.046458 | 400 |  |
| metal_repeat_03 | ok | 810.430041 | 400 |  |
| metal_tensor_repeat_01 | ok | 1109.513875 | 300 |  |
| metal_tensor_repeat_02 | ok | 920.544625 | 300 |  |
| metal_tensor_repeat_03 | ok | 894.939334 | 300 |  |
| metal_kernel_counters_repeat_01 | failed | 254.709834 | 0 | ary) 23 / func execute()->(UInt64,Double?,Double?) {  platforms/apple-silicon/swift-bridge/MetalKernelCounters.swift:37:47: error: incorrect argument labels in call (have '_:at:wit |
| metal_kernel_counters_repeat_02 | failed | 243.98675 | 0 | ary) 23 / func execute()->(UInt64,Double?,Double?) {  platforms/apple-silicon/swift-bridge/MetalKernelCounters.swift:37:47: error: incorrect argument labels in call (have '_:at:wit |
| metal_kernel_counters_repeat_03 | failed | 269.745542 | 0 | ary) 23 / func execute()->(UInt64,Double?,Double?) {  platforms/apple-silicon/swift-bridge/MetalKernelCounters.swift:37:47: error: incorrect argument labels in call (have '_:at:wit |
| wgpu_repeat_01 | ok | 18751.372542 | 100 |  |
| wgpu_repeat_02 | ok | 433.877125 | 100 |  |
| wgpu_repeat_03 | ok | 449.70975 | 100 |  |
| accelerate_repeat_01 | ok | 1450.035791 | 100 |  |
| accelerate_repeat_02 | ok | 632.868875 | 100 |  |
| accelerate_repeat_03 | ok | 614.472166 | 100 |  |
| mlx_repeat_01 | skipped | — | — | Missing executable: python |
| mlx_repeat_02 | skipped | — | — | Missing executable: python |
| mlx_repeat_03 | skipped | — | — | Missing executable: python |
| mlx_compute_repeat_01 | skipped | — | — | Missing executable: python |
| mlx_compute_repeat_02 | skipped | — | — | Missing executable: python |
| mlx_compute_repeat_03 | skipped | — | — | Missing executable: python |

## Kernel metrics (nanoseconds)

These are **not cross-backend speedups**: each backend may measure a different scope.

| Backend | Workload | Elements | Precision | Timing scope | N | Median ns | p95 ns | p99 ns |
|---|---|---:|---|---|---:|---:|---:|---:|
| tensor_nd_repeat_01 | add | 262144 | bf16 | elapsed_ns | 100 | 47626 | 58250 | 70542 |
| tensor_nd_repeat_01 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 47500 | 59958 | 66666 |
| tensor_nd_repeat_01 | add | 262144 | f32 | elapsed_ns | 100 | 47375 | 61417 | 68583 |
| tensor_nd_repeat_01 | add | 262144 | fp16 | elapsed_ns | 100 | 46666 | 58917 | 65875 |
| tensor_nd_repeat_01 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 47500 | 61000 | 72167 |
| tensor_nd_repeat_01 | add | 32768 | bf16 | elapsed_ns | 100 | 6250 | 8333 | 9292 |
| tensor_nd_repeat_01 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 5875 | 7542 | 9542 |
| tensor_nd_repeat_01 | add | 32768 | f32 | elapsed_ns | 100 | 5792 | 8250 | 11334 |
| tensor_nd_repeat_01 | add | 32768 | fp16 | elapsed_ns | 100 | 5583 | 8542 | 10541 |
| tensor_nd_repeat_01 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 5812 | 7417 | 8417 |
| tensor_nd_repeat_01 | add | 4096 | bf16 | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_01 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 667 | 750 | 833 |
| tensor_nd_repeat_01 | add | 4096 | f32 | elapsed_ns | 100 | 708 | 792 | 3667 |
| tensor_nd_repeat_01 | add | 4096 | fp16 | elapsed_ns | 100 | 625 | 750 | 4541 |
| tensor_nd_repeat_01 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_01 | add | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | add | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | add | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 167 |
| tensor_nd_repeat_01 | add | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 83 | 125 |
| tensor_nd_repeat_01 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | add | 64 | f32 | elapsed_ns | 100 | 42 | 84 | 166 |
| tensor_nd_repeat_01 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 42 | 125 |
| tensor_nd_repeat_01 | add | 8 | bf16 | elapsed_ns | 100 | 83 | 167 | 375 |
| tensor_nd_repeat_01 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 125 |
| tensor_nd_repeat_01 | add | 8 | f32 | elapsed_ns | 100 | 167 | 291 | 4458 |
| tensor_nd_repeat_01 | add | 8 | fp16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 765604 | 893208 | 907459 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 770542 | 895167 | 901416 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 767875 | 895875 | 907000 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 766208 | 893333 | 910125 |
| tensor_nd_repeat_01 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 769354 | 897750 | 911750 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 94480 | 104083 | 108166 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 110312 | 121458 | 126084 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 110312 | 121958 | 125584 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 96583 | 104709 | 112959 |
| tensor_nd_repeat_01 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 94271 | 104625 | 108291 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 14584 | 14792 | 20375 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 12167 | 12959 | 13000 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 14542 | 15000 | 20291 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 11792 | 15292 | 17250 |
| tensor_nd_repeat_01 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 12209 | 14459 | 17709 |
| tensor_nd_repeat_01 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1916 | 1959 | 2000 |
| tensor_nd_repeat_01 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1542 | 1584 | 1625 |
| tensor_nd_repeat_01 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1833 | 1917 | 1959 |
| tensor_nd_repeat_01 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1583 | 1917 | 2000 |
| tensor_nd_repeat_01 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1542 | 1666 | 1667 |
| tensor_nd_repeat_01 | dot | 8 | bf16 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | fp16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_01 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_01 | matmul | 64 | bf16 | elapsed_ns | 100 | 209 | 250 | 250 |
| tensor_nd_repeat_01 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 209 | 292 | 333 |
| tensor_nd_repeat_01 | matmul | 64 | f32 | elapsed_ns | 100 | 209 | 292 | 292 |
| tensor_nd_repeat_01 | matmul | 64 | fp16 | elapsed_ns | 100 | 209 | 291 | 542 |
| tensor_nd_repeat_01 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 208 | 250 | 375 |
| tensor_nd_repeat_01 | multiply | 262144 | bf16 | elapsed_ns | 100 | 47688 | 59250 | 67209 |
| tensor_nd_repeat_01 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 44542 | 60459 | 65500 |
| tensor_nd_repeat_01 | multiply | 262144 | f32 | elapsed_ns | 100 | 47521 | 58416 | 69041 |
| tensor_nd_repeat_01 | multiply | 262144 | fp16 | elapsed_ns | 100 | 48084 | 60250 | 63958 |
| tensor_nd_repeat_01 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 47042 | 58792 | 70750 |
| tensor_nd_repeat_01 | multiply | 32768 | bf16 | elapsed_ns | 100 | 5833 | 7459 | 9334 |
| tensor_nd_repeat_01 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5542 | 7833 | 9958 |
| tensor_nd_repeat_01 | multiply | 32768 | f32 | elapsed_ns | 100 | 5792 | 7292 | 10208 |
| tensor_nd_repeat_01 | multiply | 32768 | fp16 | elapsed_ns | 100 | 5520 | 7583 | 9166 |
| tensor_nd_repeat_01 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5666 | 8250 | 10167 |
| tensor_nd_repeat_01 | multiply | 4096 | bf16 | elapsed_ns | 100 | 667 | 750 | 792 |
| tensor_nd_repeat_01 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 667 | 709 |
| tensor_nd_repeat_01 | multiply | 4096 | f32 | elapsed_ns | 100 | 667 | 750 | 792 |
| tensor_nd_repeat_01 | multiply | 4096 | fp16 | elapsed_ns | 100 | 667 | 750 | 833 |
| tensor_nd_repeat_01 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 708 | 792 | 834 |
| tensor_nd_repeat_01 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_01 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 166 |
| tensor_nd_repeat_01 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 84 | 208 |
| tensor_nd_repeat_01 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | f32 | elapsed_ns | 100 | 42 | 84 | 583 |
| tensor_nd_repeat_01 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_01 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 262144 | bf16 | elapsed_ns | 100 | 44188 | 54167 | 59541 |
| tensor_nd_repeat_02 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 44167 | 49292 | 57709 |
| tensor_nd_repeat_02 | add | 262144 | f32 | elapsed_ns | 100 | 44250 | 52459 | 61625 |
| tensor_nd_repeat_02 | add | 262144 | fp16 | elapsed_ns | 100 | 43875 | 50333 | 58083 |
| tensor_nd_repeat_02 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 44104 | 49542 | 57167 |
| tensor_nd_repeat_02 | add | 32768 | bf16 | elapsed_ns | 100 | 5583 | 7459 | 8625 |
| tensor_nd_repeat_02 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 5584 | 6000 | 7625 |
| tensor_nd_repeat_02 | add | 32768 | f32 | elapsed_ns | 100 | 5583 | 6375 | 7333 |
| tensor_nd_repeat_02 | add | 32768 | fp16 | elapsed_ns | 100 | 5625 | 8083 | 9833 |
| tensor_nd_repeat_02 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 5917 | 10333 | 11417 |
| tensor_nd_repeat_02 | add | 4096 | bf16 | elapsed_ns | 100 | 625 | 708 | 792 |
| tensor_nd_repeat_02 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 625 | 708 | 709 |
| tensor_nd_repeat_02 | add | 4096 | f32 | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_02 | add | 4096 | fp16 | elapsed_ns | 100 | 584 | 667 | 709 |
| tensor_nd_repeat_02 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 750 |
| tensor_nd_repeat_02 | add | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 62 | 84 | 84 |
| tensor_nd_repeat_02 | add | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | add | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | add | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_02 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 42 | 84 |
| tensor_nd_repeat_02 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_02 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 125 |
| tensor_nd_repeat_02 | add | 8 | bf16 | elapsed_ns | 100 | 42 | 84 | 125 |
| tensor_nd_repeat_02 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | add | 8 | f32 | elapsed_ns | 100 | 83 | 208 | 4917 |
| tensor_nd_repeat_02 | add | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 747938 | 764959 | 779083 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 745562 | 777209 | 791209 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 746958 | 766250 | 778542 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 745521 | 765959 | 781708 |
| tensor_nd_repeat_02 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 748062 | 772167 | 777792 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 94646 | 98542 | 105000 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 93438 | 101625 | 108750 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 93250 | 96875 | 102833 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 93458 | 98958 | 108334 |
| tensor_nd_repeat_02 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 94250 | 97917 | 103958 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 12000 | 12542 | 12709 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 11875 | 12750 | 12792 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 11791 | 12500 | 12542 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 12000 | 12833 | 13000 |
| tensor_nd_repeat_02 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 12708 | 12792 | 12875 |
| tensor_nd_repeat_02 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1542 | 1666 | 1667 |
| tensor_nd_repeat_02 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1500 | 1584 | 1916 |
| tensor_nd_repeat_02 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1542 | 1666 | 1667 |
| tensor_nd_repeat_02 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1541 | 1584 | 1625 |
| tensor_nd_repeat_02 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1583 | 1584 | 1709 |
| tensor_nd_repeat_02 | dot | 8 | bf16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 375 |
| tensor_nd_repeat_02 | dot | 8 | fp16 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_02 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_02 | matmul | 64 | bf16 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_02 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_02 | matmul | 64 | f32 | elapsed_ns | 100 | 209 | 250 | 250 |
| tensor_nd_repeat_02 | matmul | 64 | fp16 | elapsed_ns | 100 | 208 | 250 | 291 |
| tensor_nd_repeat_02 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_02 | multiply | 262144 | bf16 | elapsed_ns | 100 | 43980 | 51458 | 55500 |
| tensor_nd_repeat_02 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 44000 | 49708 | 57125 |
| tensor_nd_repeat_02 | multiply | 262144 | f32 | elapsed_ns | 100 | 43938 | 48084 | 54958 |
| tensor_nd_repeat_02 | multiply | 262144 | fp16 | elapsed_ns | 100 | 44167 | 57375 | 64500 |
| tensor_nd_repeat_02 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 44083 | 49209 | 59834 |
| tensor_nd_repeat_02 | multiply | 32768 | bf16 | elapsed_ns | 100 | 5583 | 7625 | 8875 |
| tensor_nd_repeat_02 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5584 | 6958 | 8125 |
| tensor_nd_repeat_02 | multiply | 32768 | f32 | elapsed_ns | 100 | 5584 | 6334 | 7750 |
| tensor_nd_repeat_02 | multiply | 32768 | fp16 | elapsed_ns | 100 | 5583 | 6166 | 7416 |
| tensor_nd_repeat_02 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5583 | 6042 | 6792 |
| tensor_nd_repeat_02 | multiply | 4096 | bf16 | elapsed_ns | 100 | 625 | 708 | 708 |
| tensor_nd_repeat_02 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 667 | 750 | 792 |
| tensor_nd_repeat_02 | multiply | 4096 | f32 | elapsed_ns | 100 | 625 | 709 | 875 |
| tensor_nd_repeat_02 | multiply | 4096 | fp16 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_02 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 666 | 709 | 750 |
| tensor_nd_repeat_02 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_02 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_02 | multiply | 8 | f32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_02 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 83 | 83 |
| tensor_nd_repeat_02 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | add | 262144 | bf16 | elapsed_ns | 100 | 44250 | 51417 | 59666 |
| tensor_nd_repeat_03 | add | 262144 | bfp8_block32 | elapsed_ns | 100 | 44292 | 57333 | 63000 |
| tensor_nd_repeat_03 | add | 262144 | f32 | elapsed_ns | 100 | 44208 | 48041 | 52416 |
| tensor_nd_repeat_03 | add | 262144 | fp16 | elapsed_ns | 100 | 44250 | 56083 | 61042 |
| tensor_nd_repeat_03 | add | 262144 | int8_symmetric | elapsed_ns | 100 | 44334 | 55166 | 65208 |
| tensor_nd_repeat_03 | add | 32768 | bf16 | elapsed_ns | 100 | 5667 | 8834 | 9458 |
| tensor_nd_repeat_03 | add | 32768 | bfp8_block32 | elapsed_ns | 100 | 6042 | 7583 | 7875 |
| tensor_nd_repeat_03 | add | 32768 | f32 | elapsed_ns | 100 | 5625 | 6625 | 7708 |
| tensor_nd_repeat_03 | add | 32768 | fp16 | elapsed_ns | 100 | 6730 | 8625 | 9458 |
| tensor_nd_repeat_03 | add | 32768 | int8_symmetric | elapsed_ns | 100 | 6208 | 7417 | 8250 |
| tensor_nd_repeat_03 | add | 4096 | bf16 | elapsed_ns | 100 | 625 | 709 | 750 |
| tensor_nd_repeat_03 | add | 4096 | bfp8_block32 | elapsed_ns | 100 | 666 | 709 | 750 |
| tensor_nd_repeat_03 | add | 4096 | f32 | elapsed_ns | 100 | 666 | 750 | 750 |
| tensor_nd_repeat_03 | add | 4096 | fp16 | elapsed_ns | 100 | 625 | 708 | 792 |
| tensor_nd_repeat_03 | add | 4096 | int8_symmetric | elapsed_ns | 100 | 625 | 708 | 791 |
| tensor_nd_repeat_03 | add | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | add | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | add | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | add | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | add | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | add | 64 | bf16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 83 |
| tensor_nd_repeat_03 | add | 64 | f32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 64 | fp16 | elapsed_ns | 100 | 42 | 83 | 83 |
| tensor_nd_repeat_03 | add | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 125 |
| tensor_nd_repeat_03 | add | 8 | bf16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 8 | f32 | elapsed_ns | 100 | 83 | 208 | 2041 |
| tensor_nd_repeat_03 | add | 8 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | add | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | bf16 | elapsed_ns | 100 | 745896 | 769292 | 771083 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | bfp8_block32 | elapsed_ns | 100 | 745084 | 761875 | 791917 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | f32 | elapsed_ns | 100 | 745479 | 771834 | 773625 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | fp16 | elapsed_ns | 100 | 749479 | 771542 | 796209 |
| tensor_nd_repeat_03 | batched_matmul | 262144 | int8_symmetric | elapsed_ns | 100 | 745917 | 774041 | 779250 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | bf16 | elapsed_ns | 100 | 93542 | 97917 | 107250 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | bfp8_block32 | elapsed_ns | 100 | 93458 | 99375 | 101125 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | f32 | elapsed_ns | 100 | 96083 | 100125 | 105541 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | fp16 | elapsed_ns | 100 | 95896 | 100625 | 107875 |
| tensor_nd_repeat_03 | batched_matmul | 32768 | int8_symmetric | elapsed_ns | 100 | 95958 | 99042 | 100750 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | bf16 | elapsed_ns | 100 | 11750 | 11833 | 11875 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | bfp8_block32 | elapsed_ns | 100 | 11875 | 12625 | 12667 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | f32 | elapsed_ns | 100 | 12084 | 12250 | 12875 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | fp16 | elapsed_ns | 100 | 11938 | 12542 | 12625 |
| tensor_nd_repeat_03 | batched_matmul | 4096 | int8_symmetric | elapsed_ns | 100 | 12458 | 12584 | 12709 |
| tensor_nd_repeat_03 | batched_matmul | 512 | bf16 | elapsed_ns | 100 | 1542 | 1584 | 1958 |
| tensor_nd_repeat_03 | batched_matmul | 512 | bfp8_block32 | elapsed_ns | 100 | 1500 | 1584 | 1625 |
| tensor_nd_repeat_03 | batched_matmul | 512 | f32 | elapsed_ns | 100 | 1500 | 1583 | 1584 |
| tensor_nd_repeat_03 | batched_matmul | 512 | fp16 | elapsed_ns | 100 | 1583 | 1584 | 1625 |
| tensor_nd_repeat_03 | batched_matmul | 512 | int8_symmetric | elapsed_ns | 100 | 1542 | 1625 | 2625 |
| tensor_nd_repeat_03 | dot | 8 | bf16 | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | bfp8_block32 | elapsed_ns | 100 | 20 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | f32 | elapsed_ns | 100 | 41 | 42 | 375 |
| tensor_nd_repeat_03 | dot | 8 | fp16 | elapsed_ns | 100 | 41 | 42 | 42 |
| tensor_nd_repeat_03 | dot | 8 | int8_symmetric | elapsed_ns | 100 | 0 | 42 | 42 |
| tensor_nd_repeat_03 | matmul | 64 | bf16 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | bfp8_block32 | elapsed_ns | 100 | 209 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | f32 | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | matmul | 64 | fp16 | elapsed_ns | 100 | 209 | 250 | 291 |
| tensor_nd_repeat_03 | matmul | 64 | int8_symmetric | elapsed_ns | 100 | 208 | 250 | 250 |
| tensor_nd_repeat_03 | multiply | 262144 | bf16 | elapsed_ns | 100 | 44084 | 52833 | 56375 |
| tensor_nd_repeat_03 | multiply | 262144 | bfp8_block32 | elapsed_ns | 100 | 44104 | 56000 | 63166 |
| tensor_nd_repeat_03 | multiply | 262144 | f32 | elapsed_ns | 100 | 44208 | 50875 | 61167 |
| tensor_nd_repeat_03 | multiply | 262144 | fp16 | elapsed_ns | 100 | 44208 | 50667 | 54334 |
| tensor_nd_repeat_03 | multiply | 262144 | int8_symmetric | elapsed_ns | 100 | 44334 | 50083 | 50958 |
| tensor_nd_repeat_03 | multiply | 32768 | bf16 | elapsed_ns | 100 | 7583 | 11167 | 11333 |
| tensor_nd_repeat_03 | multiply | 32768 | bfp8_block32 | elapsed_ns | 100 | 5625 | 7375 | 9583 |
| tensor_nd_repeat_03 | multiply | 32768 | f32 | elapsed_ns | 100 | 6250 | 8333 | 17125 |
| tensor_nd_repeat_03 | multiply | 32768 | fp16 | elapsed_ns | 100 | 7146 | 10500 | 11166 |
| tensor_nd_repeat_03 | multiply | 32768 | int8_symmetric | elapsed_ns | 100 | 5625 | 8542 | 12834 |
| tensor_nd_repeat_03 | multiply | 4096 | bf16 | elapsed_ns | 100 | 667 | 709 | 750 |
| tensor_nd_repeat_03 | multiply | 4096 | bfp8_block32 | elapsed_ns | 100 | 667 | 709 | 750 |
| tensor_nd_repeat_03 | multiply | 4096 | f32 | elapsed_ns | 100 | 667 | 709 | 750 |
| tensor_nd_repeat_03 | multiply | 4096 | fp16 | elapsed_ns | 100 | 667 | 709 | 750 |
| tensor_nd_repeat_03 | multiply | 4096 | int8_symmetric | elapsed_ns | 100 | 667 | 750 | 791 |
| tensor_nd_repeat_03 | multiply | 512 | bf16 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | multiply | 512 | bfp8_block32 | elapsed_ns | 100 | 83 | 84 | 125 |
| tensor_nd_repeat_03 | multiply | 512 | f32 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 512 | fp16 | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 512 | int8_symmetric | elapsed_ns | 100 | 83 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | bf16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | bfp8_block32 | elapsed_ns | 100 | 42 | 42 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | fp16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 64 | int8_symmetric | elapsed_ns | 100 | 42 | 42 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | bf16 | elapsed_ns | 100 | 42 | 84 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | bfp8_block32 | elapsed_ns | 100 | 42 | 83 | 83 |
| tensor_nd_repeat_03 | multiply | 8 | f32 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | fp16 | elapsed_ns | 100 | 42 | 83 | 84 |
| tensor_nd_repeat_03 | multiply | 8 | int8_symmetric | elapsed_ns | 100 | 42 | 83 | 84 |
| rust_cpu_repeat_01 | copy | 1024 | unspecified | latency_ns | 15 | 125 | 125 | 125 |
| rust_cpu_repeat_01 | copy | 65536 | unspecified | latency_ns | 15 | 6333 | 6375 | 6375 |
| rust_cpu_repeat_01 | scale | 1024 | unspecified | latency_ns | 15 | 125 | 125 | 125 |
| rust_cpu_repeat_01 | scale | 65536 | unspecified | latency_ns | 15 | 7459 | 8917 | 8958 |
| rust_cpu_repeat_01 | triad | 1024 | unspecified | latency_ns | 15 | 166 | 167 | 167 |
| rust_cpu_repeat_01 | triad | 65536 | unspecified | latency_ns | 15 | 10250 | 10417 | 10625 |
| rust_cpu_repeat_01 | vector_add | 1024 | unspecified | latency_ns | 15 | 166 | 167 | 167 |
| rust_cpu_repeat_01 | vector_add | 65536 | unspecified | latency_ns | 15 | 16750 | 16834 | 17917 |
| rust_cpu_repeat_02 | copy | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_02 | copy | 65536 | unspecified | latency_ns | 15 | 5084 | 5250 | 5250 |
| rust_cpu_repeat_02 | scale | 1024 | unspecified | latency_ns | 15 | 42 | 84 | 84 |
| rust_cpu_repeat_02 | scale | 65536 | unspecified | latency_ns | 15 | 6208 | 6209 | 6250 |
| rust_cpu_repeat_02 | triad | 1024 | unspecified | latency_ns | 15 | 84 | 125 | 125 |
| rust_cpu_repeat_02 | triad | 65536 | unspecified | latency_ns | 15 | 8417 | 8583 | 8666 |
| rust_cpu_repeat_02 | vector_add | 1024 | unspecified | latency_ns | 15 | 84 | 125 | 125 |
| rust_cpu_repeat_02 | vector_add | 65536 | unspecified | latency_ns | 15 | 9209 | 9292 | 9333 |
| rust_cpu_repeat_03 | copy | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_03 | copy | 65536 | unspecified | latency_ns | 15 | 5083 | 5166 | 5167 |
| rust_cpu_repeat_03 | scale | 1024 | unspecified | latency_ns | 15 | 42 | 83 | 84 |
| rust_cpu_repeat_03 | scale | 65536 | unspecified | latency_ns | 15 | 5792 | 5833 | 5834 |
| rust_cpu_repeat_03 | triad | 1024 | unspecified | latency_ns | 15 | 83 | 125 | 125 |
| rust_cpu_repeat_03 | triad | 65536 | unspecified | latency_ns | 15 | 9042 | 9292 | 14375 |
| rust_cpu_repeat_03 | vector_add | 1024 | unspecified | latency_ns | 15 | 83 | 84 | 84 |
| rust_cpu_repeat_03 | vector_add | 65536 | unspecified | latency_ns | 15 | 10333 | 10500 | 10500 |
| precision_repeat_01 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 71917 | 81542 | 89292 |
| precision_repeat_01 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 50417 | 50709 | 53292 |
| precision_repeat_01 | vector_add | 65536 | f32 | elapsed_ns | 100 | 104958 | 126083 | 126167 |
| precision_repeat_01 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 61375 | 65917 | 66125 |
| precision_repeat_01 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 54250 | 54542 | 57375 |
| precision_repeat_02 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 57688 | 61500 | 67000 |
| precision_repeat_02 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 45791 | 45916 | 48625 |
| precision_repeat_02 | vector_add | 65536 | f32 | elapsed_ns | 100 | 70042 | 78458 | 80792 |
| precision_repeat_02 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 52333 | 54667 | 57250 |
| precision_repeat_02 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 50417 | 50625 | 53292 |
| precision_repeat_03 | vector_add | 65536 | bf16 | elapsed_ns | 100 | 61042 | 61792 | 64375 |
| precision_repeat_03 | vector_add | 65536 | bfp8_block32 | elapsed_ns | 100 | 45792 | 45875 | 48542 |
| precision_repeat_03 | vector_add | 65536 | f32 | elapsed_ns | 100 | 71916 | 81000 | 85250 |
| precision_repeat_03 | vector_add | 65536 | fp16 | elapsed_ns | 100 | 54458 | 55083 | 57416 |
| precision_repeat_03 | vector_add | 65536 | int8_symmetric | elapsed_ns | 100 | 50417 | 53250 | 56667 |
| metal_repeat_01 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 289104 | 321208 | 344834 |
| metal_repeat_01 | gather | 65536 | unspecified | gpu_command_ns | 100 | 18167 | 19125 | 19167 |
| metal_repeat_01 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 352938 | 450042 | 478917 |
| metal_repeat_01 | scale | 65536 | unspecified | gpu_command_ns | 100 | 13250 | 21458 | 21750 |
| metal_repeat_01 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 352312 | 447292 | 477208 |
| metal_repeat_01 | triad | 65536 | unspecified | gpu_command_ns | 100 | 26250 | 36750 | 36958 |
| metal_repeat_01 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 331980 | 363583 | 383625 |
| metal_repeat_01 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 18083 | 20125 | 28750 |
| metal_repeat_02 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 280459 | 311208 | 475541 |
| metal_repeat_02 | gather | 65536 | unspecified | gpu_command_ns | 100 | 18083 | 19375 | 31375 |
| metal_repeat_02 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 340000 | 458709 | 615417 |
| metal_repeat_02 | scale | 65536 | unspecified | gpu_command_ns | 100 | 13250 | 35000 | 184792 |
| metal_repeat_02 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 311583 | 372291 | 673291 |
| metal_repeat_02 | triad | 65536 | unspecified | gpu_command_ns | 100 | 26125 | 29500 | 57792 |
| metal_repeat_02 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 328374 | 424875 | 615583 |
| metal_repeat_02 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 19708 | 133333 | 247000 |
| metal_repeat_03 | gather | 65536 | unspecified | dispatch_completion_ns | 100 | 222792 | 247708 | 262458 |
| metal_repeat_03 | gather | 65536 | unspecified | gpu_command_ns | 100 | 15479 | 18875 | 19000 |
| metal_repeat_03 | scale | 65536 | unspecified | dispatch_completion_ns | 100 | 288375 | 310750 | 320042 |
| metal_repeat_03 | scale | 65536 | unspecified | gpu_command_ns | 100 | 11708 | 12125 | 12500 |
| metal_repeat_03 | triad | 65536 | unspecified | dispatch_completion_ns | 100 | 251688 | 337417 | 344917 |
| metal_repeat_03 | triad | 65536 | unspecified | gpu_command_ns | 100 | 16375 | 18125 | 18375 |
| metal_repeat_03 | vector_add | 65536 | unspecified | dispatch_completion_ns | 100 | 292666 | 308959 | 315041 |
| metal_repeat_03 | vector_add | 65536 | unspecified | gpu_command_ns | 100 | 17125 | 17917 | 18375 |
| metal_tensor_repeat_01 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 284812 | 329667 | 371083 |
| metal_tensor_repeat_01 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 3250 | 4125 | 5750 |
| metal_tensor_repeat_01 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 404396 | 462792 | 490625 |
| metal_tensor_repeat_01 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 48396 | 53375 | 53500 |
| metal_tensor_repeat_01 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 358334 | 383208 | 419166 |
| metal_tensor_repeat_01 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39917 | 40875 | 42042 |
| metal_tensor_repeat_02 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 258333 | 299833 | 330250 |
| metal_tensor_repeat_02 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 2833 | 4042 | 4083 |
| metal_tensor_repeat_02 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 384938 | 446250 | 458708 |
| metal_tensor_repeat_02 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 46084 | 53625 | 54000 |
| metal_tensor_repeat_02 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 352500 | 375583 | 413875 |
| metal_tensor_repeat_02 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39958 | 40500 | 41375 |
| metal_tensor_repeat_03 | dot_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 256646 | 315084 | 337583 |
| metal_tensor_repeat_03 | dot_f32 | 4096 | fp32 | gpu_command_ns | 100 | 3125 | 4125 | 4125 |
| metal_tensor_repeat_03 | gemm_f16 | 4096 | fp16 | dispatch_completion_ns | 100 | 375333 | 434291 | 485000 |
| metal_tensor_repeat_03 | gemm_f16 | 4096 | fp16 | gpu_command_ns | 100 | 43938 | 50000 | 50625 |
| metal_tensor_repeat_03 | gemm_f32 | 4096 | fp32 | dispatch_completion_ns | 100 | 344458 | 399667 | 452208 |
| metal_tensor_repeat_03 | gemm_f32 | 4096 | fp32 | gpu_command_ns | 100 | 39875 | 41208 | 42500 |
| wgpu_repeat_01 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1286604 | 1292959 | 1296041 |
| wgpu_repeat_02 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1291000 | 1316833 | 1329375 |
| wgpu_repeat_03 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 1287562 | 2549417 | 2611833 |
| accelerate_repeat_01 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 7083 | 7458 | 10084 |
| accelerate_repeat_02 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 5250 | 5292 | 5334 |
| accelerate_repeat_03 | vector_add | 65536 | unspecified | elapsed_ns | 100 | 4917 | 5250 | 5375 |

## Electricity, GPU, CPU and RAM telemetry

See `resources.jsonl`, `resource_summary.json`, `apple_power_components.csv` (when available), `thermal.jsonl` (when available), and `telemetry_capabilities.json`.
Missing or unauthorized sensors are **unavailable**, not zero. External calibrated power CSV, when supplied, gives whole-process joules including overhead, **not kernel-only joules**.
Apple powermetrics values are estimated component power and receipt-time stamped; they are not integrated into kernel-specific energy.

## Reproduction and artifacts

See `repeat_summary.csv` for independent repeated-run summary.

See `environment.json` for hardware, compiler and Git revision; `runs.jsonl` for backend diagnostics; `raw/` for archived CSV samples.
No backend speedup or energy-efficiency ranking is claimed without matched timing scopes and calibrated attribution.
