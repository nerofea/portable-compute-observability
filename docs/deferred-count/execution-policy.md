# Execution policy design

Input: capacity, device-produced selected count, dtype, operation, graph availability, validated upper bound, workload profile.

Policies:

1. Immediate: known count passed directly to CUB.
2. Readback: GPU-produced count synchronized to host before launch.
3. Deferred: GPU count consumed by deferred CUB API in captured graph.
4. Bucketed: pre-captured capacity ladder, selected only when upper-bound information is available without an unaccounted synchronization.
5. Padded: process max capacity as negative control.

Safety: validate count on device before use; ensure a safe gated path for invalid counts. Measure producer, selection, graph-capture amortization and memory costs. A policy decision must never assume a host-known count for free.
