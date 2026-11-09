use std::{env, process};
use deferred_model::{trace, Workload};
fn main() {
    let args: Vec<String> = env::args().collect();
    let mode = args.get(1).map(String::as_str).unwrap_or("smoke");
    if mode == "smoke" || mode == "cpu-test" {
        let counts = trace(0xC0FFEE, 4096, 100);
        for count in &counts { Workload { capacity: 4096, selected: *count }.validate().expect("valid trace"); }
        println!("CPU validation passed: {} deterministic counts; CUDA benchmark not executed", counts.len());
    } else {
        eprintln!("CUDA benchmark mode '{mode}' is not implemented yet; no GPU measurements were produced");
        process::exit(3);
    }
}
