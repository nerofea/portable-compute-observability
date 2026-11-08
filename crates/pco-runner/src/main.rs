use std::{env,fs::{self,File},io::{BufWriter,Write},hint::black_box,time::Instant};
use pco_core::{deterministic_inputs,approx_equal};
use pco_statistics::quantile;

fn main() -> Result<(),Box<dyn std::error::Error>> {
    let args:Vec<String> = env::args().collect();
    if args.get(1).map(String::as_str) != Some("run") {
        eprintln!("Usage: cargo run --release -p pco-runner -- run [--suite apple-m5-smoke|apple-m5-baseline]");
        return Ok(());
    }
    let suite = args.windows(2).find(|w|w[0]=="--suite").map(|w|w[1].as_str()).unwrap_or("apple-m5-smoke");
    let (sizes,repeats) = match suite {
        "apple-m5-smoke" => (vec![1024,65536], 15),
        "apple-m5-baseline" => (vec![1024,16384,65536,262144,1048576,4194304], 50),
        _ => return Err(format!("unknown suite: {suite}").into())
    };
    fs::create_dir_all("results/raw")?;
    let path = format!("results/raw/{suite}-cpu.csv");
    let mut writer = BufWriter::new(File::create(&path)?);
    writeln!(writer,"suite,workload,backend,elements,iteration,latency_ns,logical_bytes,checksum")?;
    for n in sizes {
        let (a,b) = deterministic_inputs(n);
        let mut out = vec![0f32;n];
        let expected: f64 = a.iter().zip(&b).map(|(&x,&y)|(x+y) as f64).sum();
        let mut samples = Vec::new();
        for i in 0..(repeats+10) {
            let t=Instant::now();
            pco_cpu::vector_add(black_box(&a),black_box(&b),black_box(&mut out));
            black_box(&out);
            let ns=t.elapsed().as_nanos();
            let checksum:f64=out.iter().map(|&x|x as f64).sum();
            if !approx_equal(checksum,expected,1e-3,1e-6) { return Err("correctness failure".into()); }
            if i>=10 {
                samples.push(ns as f64);
                writeln!(writer,"{suite},vector_add,rust_cpu,{n},{},{ns},{},{}",i-10,n*12,checksum)?;
            }
        }
        println!("vector_add n={n} median_ns={:.0} p95_ns={:.0}",quantile(&samples,0.5).unwrap(),quantile(&samples,0.95).unwrap());
    }
    writer.flush()?;
    println!("Saved {path}");
    Ok(())
}
