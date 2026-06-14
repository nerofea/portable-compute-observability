


portable-compute-observability/

observability/instrumentation/

├── browser/

├── wasm/

├── webgpu/

├── cuda/

├── vulkan/

├── metal/

├── opencl/

├── directx/

├── oneapi/

├── level_zero/

├── webnn/

├── barretenberg/

├── aztec/

├── starknet/

├── zksync/

├── scroll/

├── polygon_zkevm/

├── onnxruntime/

├── tensorrt/

├── tvm/

├── iree/

├── openvino/

└── artifacts/

├── timestamps/

├── events/

├── markers/

├── spans/

├── annotations/

├── trace_emitters/

└── counter_emitters/



observability/collectors/

├── perfetto/

├── opentelemetry/

├── nvml/

├── dcgm/

├── cupti/

├── nsight_systems/

├── nsight_compute/

├── rocprofiler/

├── rocm_smi/

├── intel_gpa/

├── vtune/

├── gpuvis/

├── ebpf/

├── perf/

├── ftrace/

├── atrace/

└── artifacts/

├── trace_collectors/

├── counter_collectors/

├── metric_collectors/

├── log_collectors/

└── profile_collectors/ 

observability/telemetry/

├── schemas/

│ ├── proof.yaml

│ ├── gpu.yaml

│ ├── runtime.yaml

│ ├── network.yaml

│ ├── compiler.yaml

│ └── distributed.yaml

├── normalization/

├── conventions/

├── taxonomy/

├── proof_events/

├── msm_events/

├── dispatch_events/

├── gpu_counters/

├── runtime_metrics/

└── inference_records/



engines/

├── correlation/

├── root_cause/

├── optimization/

├── prediction/

├── causality/

├── discovery/

├── symbolic_regression/

├── anomaly_detection/

├── optimization_discovery/

├── bottleneck_detection/

├── workload_characterization/

├── compiler_analysis/

├── proof_analysis/

├── runtime_analysis/

└── libraries/

├── pytorch/

├── jax/

├── xgboost/

├── lightgbm/

├── pysr/

├── sympy/

├── dowhy/

└── networkx/ 

models/

├── gpu/

├── cpu/

├── memory/

├── execution/

├── scheduler/ 

├── proof/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── ptx/

│   ├── python/

│   ├── javascript/

│   ├── typescript/

│   ├── wit/

│   ├── webidl/

│   ├── wgsl/

│   ├── hlsl/

│   ├── msl/

│   ├── spirv/

│   ├── glsl/

│   ├── opencl_c/

│   ├── kotlin/

│   ├── java/

│   ├── swift/

│   ├── objective_c/

│   ├── powershell/

│   ├── bash/

│   ├── zig/

│   ├── ebpf/

│   ├── sql/

│   ├── json/

│   ├── yaml/

│   ├── json_schema/

│   ├── protobuf/

│   └── schemas/

│

├── msm/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── ptx/

│   ├── python/

│   ├── wgsl/

│   ├── hlsl/

│   ├── msl/

│   ├── spirv/

│   ├── glsl/

│   ├── opencl_c/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── ntt/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── ptx/

│   ├── python/

│   ├── wgsl/

│   ├── hlsl/

│   ├── msl/

│   ├── spirv/

│   ├── glsl/

│   ├── opencl_c/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── fft/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── ptx/

│   ├── python/

│   ├── wgsl/

│   ├── hlsl/

│   ├── msl/

│   ├── spirv/

│   ├── glsl/

│   ├── opencl_c/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── dispatch/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── javascript/

│   ├── typescript/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── kernel/

│   ├── rust/

│   ├── cpp/

│   ├── cuda/

│   ├── ptx/

│   ├── wgsl/

│   ├── hlsl/

│   ├── msl/

│   ├── spirv/

│   ├── glsl/

│   ├── opencl_c/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── counter/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── sql/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── trace/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── sql/

│   ├── json/

│   ├── yaml/

│   ├── json_schema/

│   ├── protobuf/

│   └── schemas/

│

├── node/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── sql/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── cluster/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── sql/

│   ├── bash/

│   ├── powershell/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── inference/

│   ├── rust/

│   ├── python/

│   ├── cpp/

│   ├── javascript/

│   ├── typescript/

│   ├── onnx/

│   ├── sql/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── runtime/

│   ├── rust/

│   ├── cpp/

│   ├── javascript/

│   ├── typescript/

│   ├── wit/

│   ├── webidl/

│   ├── wasm/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── compiler/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── llvm/

│   ├── spirv/

│   ├── ptx/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/

│

├── distributed/

│   ├── rust/

│   ├── cpp/

│   ├── python/

│   ├── sql/

│   ├── bash/

│   ├── powershell/

│   ├── ebpf/

│   ├── json/

│   ├── yaml/

│   ├── protobuf/

│   └── schemas/



models/schemas/


├── proof/

│   └── proof.schema.yaml

├── msm/

│   └── msm.schema.yaml

├── ntt/

│   └── ntt.schema.yaml

├── fft/

│   └── fft.schema.yaml

├── dispatch/

│   └── dispatch.schema.yaml

├── kernel/

│   └── kernel.schema.yaml

├── counter/

│   └── counter.schema.yaml

├── trace/

│   └── trace.schema.yaml

├── node/

│   └── node.schema.yaml

├── cluster/

│   └── cluster.schema.yaml

├── inference/

│   └── inference.schema.yaml

├── runtime/

│   └── runtime.schema.yaml

├── compiler/

│   └── compiler.schema.yaml

├── distributed/

│   └── distributed.schema.yaml

└── schemas/

    ├── Proof/

    │   └── proof.yaml

    ├── Dispatch/

    │   └── dispatch.yaml

    ├── GPUCounter/

    │   └── gpu_counter.yaml

    ├── TraceEvent/

    │   └── trace_event.yaml

    ├── RuntimeMetric/

    │   └── runtime_metric.yaml

    └── InferenceRecord/

        └── inference_record.yaml└── schemas/

├── Proof/

├── Dispatch/

├── GPUCounter/

├── TraceEvent/

├── RuntimeMetric/

└── InferenceRecord/



workbenches/

└── consoles/

    ├── gpu_profiler/gpu_counters 

    ├── proving_profiler/

    ├── browser_profiler/

    ├── wasm_profiler/

    └── runtime_profiler/



integrations/internal_engine/

├── symbolic_regression/

├── proof_optimization/

├── msm/

├── fft/

├── ntt/

├── causal_analysis/

├── compiler_observability/

├── proving_observability/

├── runtime_observability/

├── distributed_observability/



benchmarks/

├── cryptography/

│ ├── msm/

│ ├── fft/

│ ├── ntt/

│ ├── sumcheck/

│ ├── fri/

│ ├── plonk/

│ ├── polynomial_commitments/

│ ├── witness_generation/

│ ├── proof_generation/

│ └── verification/

│

├── ai/
| ├── ml/
| ├── regressional_modelling/
│ ├── attention/

│ ├── transformer/

│ └── inference/

│

└── hardware/

├── bandwidth/

├── occupancy/

├── latency/

├── cache/

├── power/

└── thermals/



datasets/



├── raw/

│   ├── gpu_traces/

│   ├── proof_traces/

│   ├── runtime_metrics/

│   ├── benchmark_results/

│   ├── counter_dumps/

│   ├── perfetto/

│   ├── nvml/

│   ├── dcgm/

│   ├── cupti/

│   ├── rocprofiler/

│   ├── vtune/

│   ├── opentelemetry/

│   └── logs/

│

├── normalized/

│   ├── gpu/

│   ├── proving/

│   ├── runtime/

│   ├── compiler/

│   ├── distributed/

│   └── ai/

│

├── features/

│   ├── msm/

│   ├── fft/

│   ├── ntt/

│   ├── sumcheck/

│   ├── commitments/

│   ├── witness_generation/

│   ├── proof_generation/

│   ├── verification/

│   ├── occupancy/

│   ├── bandwidth/

│   ├── cache_misses/

│   ├── register_pressure/

│   ├── divergence/

│   └── latency/

│

├── training/

│   ├── symbolic_regression/

│   ├── anomaly_detection/

│   ├── bottleneck_detection/

│   ├── prediction/

│   ├── optimization_discovery/

│   └── causality/

│

├── derived/

│   ├── equations/

│   ├── correlations/

│   ├── causality/

│   ├── optimization_candidates/

│   ├── bottlenecks/

│   ├── regressions/

│   ├── forecasts/

│   └── recommendations/

│

├── experiments/

│   ├── msm_window_sizing/

│   ├── bucket_strategies/

│   ├── fft_layouts/

│   ├── ntt_layouts/

│   ├── memory_layouts/

│   ├── workgroup_sizes/

│   ├── dispatch_strategies/

│   └── scheduler_variants/

│

├── observations/

│   ├── proofs/

│   ├── kernels/

│   ├── dispatches/

│   ├── runtimes/

│   ├── compilers/

│   ├── drivers/

│   ├── browsers/

│   └── devices/

│

├── hardware/

│   ├── nvidia/

│   ├── amd/

│   ├── intel/

│   ├── apple/

│   ├── adreno/

│   ├── mali/

│   └── fpga/



docs/

├── architecture/

├── taxonomy/

├── terminology/

├── capabilities/

├── integrations/

├── compiler_observability/

├── proving_observability/

├── runtime_observability/

├── distributed_observability/

├── hardware_catalog/

│ ├── nvidia/

│ ├── amd/

│ ├── intel/

│ ├── apple/

│ ├── adreno/

│ ├── mali/

│ └── fpga/

│

├── vision.md

├── repository-layout.md

├── telemetry-schema.md

├── compute-taxonomy.md

├── observability-taxonomy.md

├── compiler-observability.md

└── proof-system-observability.md 

 

mission.md

cryptography_compute_taxonomymd

observability_layers.md

compiler-observability.md

strategy.md  

ecosystem.md

docs/



