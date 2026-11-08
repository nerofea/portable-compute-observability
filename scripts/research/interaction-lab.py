#!/usr/bin/env python3
"""Reproducible multi-factor computation research. Python 3.9+, standard library only.
Measures complete runner process (including startup) separately from its kernel CSV.
Power is optional, externally sampled and never silently invented.
"""
import argparse, csv, hashlib, json, math, os, pathlib, platform, random, statistics, subprocess, sys, time
from datetime import datetime, timezone

ROOT = pathlib.Path(__file__).resolve().parents[2]
RESULTS = ROOT / "results" / "research"
def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""): h.update(block)
    return h.hexdigest()
def run(cmd, env=None):
    p = subprocess.run(cmd, cwd=ROOT, env=env, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(f"{cmd}: exit={p.returncode}\n{p.stdout[-2000:]}\n{p.stderr[-2000:]}")
    return p.stdout
def percentile(xs, q):
    if not xs: return None
    s = sorted(xs); pos = (len(s) - 1) * q; lo = int(pos); hi = min(lo + 1, len(s) - 1)
    return s[lo] * (hi - pos) + s[hi] * (pos - lo)
def bootstrap_median_ci(xs, seed=17, reps=1000):
    if not xs: return [None, None]
    rng = random.Random(seed)
    vals = [statistics.median([xs[rng.randrange(len(xs))] for _ in xs]) for _ in range(reps)]
    return [percentile(vals, .025), percentile(vals, .975)]
def load_power_csv(path):
    """Strict external CSV contract: unix_ns,power_watts,source. Samples must have monotonic timestamps."""
    if not path: return []
    with open(path, newline="") as f: rows = list(csv.DictReader(f))
    result = []
    for r in rows:
        ns, watts = int(r["unix_ns"]), float(r["power_watts"])
        if ns <= 0 or not math.isfinite(watts) or watts < 0: raise ValueError("Invalid power sample")
        if result and ns <= result[-1][0]: raise ValueError("Power samples must be strictly increasing")
        result.append((ns, watts, r.get("source", "external")))
    return result
def energy_in_window(samples, start, end):
    """Trapezoidal integration; require samples bracketing both boundaries.
    This is whole-window energy, not isolated kernel energy.
    """
    if len(samples) < 2 or start < samples[0][0] or end > samples[-1][0] or end <= start:
        return None
    def interp(t):
        for i in range(1, len(samples)):
            x0, p0, _ = samples[i-1]; x1, p1, _ = samples[i]
            if x0 <= t <= x1: return p0 + (p1-p0) * (t-x0)/(x1-x0)
        return None
    points = [(start, interp(start))] + [(x,p) for x,p,_ in samples if start < x < end] + [(end,interp(end))]
    return sum((b[0]-a[0])*1e-9*(a[1]+b[1])/2 for a,b in zip(points,points[1:]))
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="experiments/research/interaction-matrix.json")
    parser.add_argument("--power-csv", help="Optional external sensor CSV: unix_ns,power_watts,source")
    parser.add_argument("--limit", type=int, default=0, help="Run at most N new trials")
    args = parser.parse_args()
    cfg = json.loads((ROOT / args.config).read_text())
    assert cfg["schema"] == 1
    seed = int(cfg["seed"])
    cases = []
    for flags in cfg["compiler_flags"]:
        for algorithm in cfg["algorithms"]:
            for n in cfg["sizes"]:
                for repeat in range(cfg["repeats"]):
                    cases.append(dict(flags=flags, algorithm=algorithm, size=n, repeat=repeat))
    random.Random(seed).shuffle(cases)
    RESULTS.mkdir(parents=True, exist_ok=True)
    session = RESULTS / cfg["name"]
    session.mkdir(parents=True, exist_ok=True)
    state_path = session / "trials.jsonl"
    completed = {}
    if state_path.exists():
        for line in state_path.read_text().splitlines():
            record = json.loads(line)
            completed[record["case_id"]] = record
    power = load_power_csv(args.power_csv)
    toolchain = run(["rustc", "-Vv"]).strip()
    git_sha = run(["git", "rev-parse", "HEAD"]).strip()
    metadata = dict(config=cfg, git_sha=git_sha, toolchain=toolchain, system=platform.platform(),
                    machine=platform.machine(), python=sys.version, power_source=args.power_csv,
                    timing_scopes=["kernel_only", "process_wall"])
    (session / "metadata.json").write_text(json.dumps(metadata, indent=2))
    built = {}
    new = 0
    for case in cases:
        key = hashlib.sha256(json.dumps(case,sort_keys=True).encode()).hexdigest()[:20]
        if key in completed: continue
        if args.limit and new >= args.limit: break
        flags = case["flags"]
        if flags not in built:
            target = session / ("target-" + hashlib.sha256(flags.encode()).hexdigest()[:12])
            env = os.environ.copy()
            env["RUSTFLAGS"] = flags
            env["CARGO_TARGET_DIR"] = str(target)
            run(["cargo", "build", "--release", "-p", "pco-runner"], env)
            binary = target / "release" / ("pco-runner.exe" if os.name == "nt" else "pco-runner")
            built[flags] = (binary, sha256(binary))
        binary, binary_hash = built[flags]
        manifest = session / f"manifest-{key}.toml"
        manifest.write_text(
            f'name = "research-{key}"\nbackend = "rust_cpu"\n'
            f'workloads = ["{case["algorithm"]}"]\nsizes = [{case["size"]}]\n'
            f'warmup_iterations = {cfg["warmups"]}\nmeasured_iterations = {cfg["samples"]}\nvalidation = true\n'
        )
        before = {p.resolve() for p in (ROOT / "results" / "raw").glob(f"research-{key}-*.csv")}
        start_ns = time.time_ns()
        output = run([str(binary), "run", "--manifest", str(manifest)])
        end_ns = time.time_ns()
        after = {p.resolve() for p in (ROOT / "results" / "raw").glob(f"research-{key}-*.csv")}
        created = sorted(after - before)
        if len(created) != 1: raise RuntimeError(f"Expected one raw CSV for {key}, got {created}")
        with open(created[0], newline="") as f: rows = list(csv.DictReader(f))
        ns = [int(row["latency_ns"]) for row in rows]
        if len(ns) != cfg["samples"]: raise RuntimeError("Sample count mismatch")
        joules = energy_in_window(power, start_ns, end_ns) if power else None
        record = dict(case_id=key, **case, backend="rust_cpu", numeric_format="f32",
                      algorithm_family="memory_vector", hardware=platform.machine(),
                      compiler="rustc", compiler_flags=flags, binary_sha256=binary_hash,
                      git_sha=git_sha, start_unix_ns=start_ns, end_unix_ns=end_ns,
                      process_wall_ms=(end_ns-start_ns)/1e6,
                      median_kernel_ms=statistics.median(ns)/1e6,
                      p95_kernel_ms=percentile(ns,.95)/1e6,
                      median_ci95_ms=[v/1e6 for v in bootstrap_median_ci(ns, seed+case["repeat"])],
                      raw_csv=str(created[0].relative_to(ROOT)), samples=len(ns),
                      total_process_energy_joules=joules,
                      power_source=power[0][2] if joules is not None else None,
                      validation="pass", runner_stdout=output.strip()[-500:])
        with open(state_path, "a") as f:
            f.write(json.dumps(record, sort_keys=True) + "\n")
            f.flush()
            os.fsync(f.fileno())
        new += 1
        print(f'{new} {case["algorithm"]} n={case["size"]} flags={flags!r}: {record["median_kernel_ms"]:.4f} ms; energy={joules}')
    rows = [json.loads(line) for line in state_path.read_text().splitlines()] if state_path.exists() else []
    with open(session / "summary.csv", "w", newline="") as f:
        cols = ["case_id","algorithm","size","flags","repeat","backend","numeric_format","median_kernel_ms","p95_kernel_ms","process_wall_ms","total_process_energy_joules","power_source","validation"]
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
        for r in rows: w.writerow({k:r.get(k) for k in cols})
    print(f"Completed {len(rows)}/{len(cases)} trials. Summary: {session/'summary.csv'}")
if __name__ == "__main__": main()
