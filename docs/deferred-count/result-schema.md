# Planned JSONL result schema v1

Each measured sample must include: schema_version, experiment, run_id, git_sha, gpu_name, compute_capability, driver_version, cuda_version, cccl_version, policy, workload, capacity, selected, seed, repetition, iteration, cpu_wall_ns, gpu_elapsed_ns, correctness_pass, and status.

Status distinguishes measured, skipped, failed and unsupported. Never write fake samples to satisfy a parser. Store immutable runs under results/deferred-count/<run-id>/ and keep generated data out of Git by default.
