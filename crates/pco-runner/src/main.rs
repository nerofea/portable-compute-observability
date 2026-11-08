use std::{env,fs::{self,File},io::{BufWriter,Write},hint::black_box,path::Path,time::{Instant,SystemTime,UNIX_EPOCH}};
use pco_core::{deterministic_inputs,approx_equal};
use pco_statistics::quantile;
use serde::{Deserialize,Serialize};

#[derive(Deserialize,Serialize,Debug)]
#[serde(deny_unknown_fields)]
struct Experiment {
 name:String, backend:String, workloads:Vec<String>, sizes:Vec<usize>,
 warmup_iterations:usize, measured_iterations:usize, validation:bool,
}
fn main()->Result<(),Box<dyn std::error::Error>> {
 let args:Vec<String>=env::args().collect();
 if args.get(1).map(String::as_str)!=Some("run") {
  eprintln!("Usage: cargo run --release -p pco-runner -- run --suite apple-m5-smoke|apple-m5-baseline [--manifest path]");
  return Ok(());
 }
 let suite=args.windows(2).find(|w|w[0]=="--suite").map(|w|w[1].as_str()).unwrap_or("apple-m5-smoke");
 let path=args.windows(2).find(|w|w[0]=="--manifest").map(|w|w[1].clone())
  .unwrap_or_else(||format!("experiments/apple-m5/{}.toml",suite.strip_prefix("apple-m5-").unwrap_or(suite)));
 let experiment:Experiment=toml::from_str(&fs::read_to_string(&path)?)?;
 if experiment.backend!="rust_cpu" { return Err("only rust_cpu is currently supported by the Rust runner".into()); }
 if experiment.sizes.is_empty() || experiment.measured_iterations==0 {return Err("empty sizes or zero iterations".into());}
 if experiment.sizes.iter().any(|&n|n==0 || n>16_777_216) {return Err("size out of supported range (1..=16777216)".into());}
 fs::create_dir_all("results/raw")?;
 let stamp=SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs();
 let output=format!("results/raw/{}-{stamp}.csv",experiment.name);
 let mut writer=BufWriter::new(File::create(&output)?);
 writeln!(writer,"suite,workload,backend,elements,iteration,latency_ns,logical_bytes,checksum")?;
 let metadata=serde_json::json!({"experiment":experiment,"timestamp_unix":stamp,"os":env::consts::OS,"arch":env::consts::ARCH,"timing_scope":"kernel_only","units":"nanoseconds","power_source":null});
 fs::write(format!("{output}.json"),serde_json::to_vec_pretty(&metadata)?)?;
 for &n in &experiment.sizes {
  let (a,b)=deterministic_inputs(n);let mut out=vec![0f32;n];
  for workload in &experiment.workloads {
   let expected:Vec<f32>=match workload.as_str() {
    "vector_add"=>a.iter().zip(&b).map(|(x,y)|x+y).collect(),
    "copy"=>a.clone(),
    "scale"=>a.iter().map(|x|x*2.0).collect(),
    "triad"=>a.iter().zip(&b).map(|(x,y)|x+2.0*y).collect(),
    _=>return Err(format!("unsupported workload: {workload}").into())
   };
   let bytes=match workload.as_str() {"vector_add"|"triad"=>n*12,_=>n*8};
   let mut samples=Vec::with_capacity(experiment.measured_iterations);
   for i in 0..(experiment.warmup_iterations+experiment.measured_iterations) {
    let start=Instant::now();
    match workload.as_str() {
     "vector_add"=>pco_cpu::vector_add(black_box(&a),black_box(&b),black_box(&mut out)),
     "copy"=>pco_memory::stream_copy(black_box(&a),black_box(&mut out)),
     "scale"=>pco_memory::stream_scale(black_box(&a),black_box(&mut out),black_box(2.0)),
     "triad"=>pco_memory::stream_triad(black_box(&a),black_box(&b),black_box(&mut out),black_box(2.0)),
     _=>unreachable!()
    }
    black_box(&out);
    let elapsed=start.elapsed().as_nanos();
    if experiment.validation && out.iter().zip(&expected).any(|(&actual,&want)|!approx_equal(actual as f64,want as f64,1e-6,1e-5)) {
     return Err(format!("elementwise validation failed: {workload}, n={n}").into());
    }
    if i>=experiment.warmup_iterations {
     let checksum:f64=out.iter().map(|&x|x as f64).sum();
     samples.push(elapsed as f64);
     writeln!(writer,"{},{workload},rust_cpu,{n},{},{elapsed},{bytes},{checksum}",experiment.name,i-experiment.warmup_iterations)?;
    }
   }
   println!("{workload} n={n} median_ns={:.0} p95_ns={:.0} p99_ns={:.0}",quantile(&samples,0.5).unwrap(),quantile(&samples,0.95).unwrap(),quantile(&samples,0.99).unwrap());
  }
 }
 writer.flush()?;println!("Saved {output}");Ok(())
}
