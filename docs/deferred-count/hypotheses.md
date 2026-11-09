# Deferred-count research hypotheses

All thresholds are proposed acceptance criteria, not findings.

- **H1**: Deferred execution improves host-readback end-to-end p99 by >=20% in qualifying regimes.
- **H2**: Dense-count GPU execution overhead stays within 10% of immediate-size baseline.
- **H3**: Locate sparse-count crossover where deferred execution loses to bucketed/immediate controls.
- **H4**: Evaluate public CUB tuning controls for reducing sparse-count penalties.
- **H5**: Compare one deferred graph with a 16-graph bucket ladder, including memory and capture costs.
- **H6**: Measure Rust FFI overhead and test <1 microsecond median target.
- **H7**: Separate host submission/graph replay gains from GPU work inflation.

Report confidence intervals and explicitly reject/qualify unsupported hypotheses.
