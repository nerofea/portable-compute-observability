use std::{env,fs::{self,File},io::{BufWriter,Write},hint::black_box,time::{Instant,SystemTime,UNIX_EPOCH}};
use pco_core::deterministic_inputs;
use pco_precision::{error_metrics,quantize,Format};
fn main()->Result<(),Box<dyn std::error::Error>> {
    let args:Vec<String>=env::args().collect();
    let n=args.get(1).map(|s|s.parse::<usize>()).transpose()?.unwrap_or(65536);
    let samples=args.get(2).map(|s|s.parse::<usize>()).transpose()?.unwrap_or(30);
    if n==0 || n>16_777_216 || samples==0 || samples>10000 {return Err("invalid n or samples".into());}
    let (a,b)=deterministic_inputs(n);
    let reference:Vec<f32>=a.iter().zip(&b).map(|(x,y)|x+y).collect();
    fs::create_dir_all("results/raw")?;
    let stamp=SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs();
    let path=format!("results/raw/precision-{stamp}.csv");
    let mut writer=BufWriter::new(File::create(&path)?);
    writeln!(writer,"format,implementation,backend,operation,elements,iteration,elapsed_ns,rmse_vs_f32,max_abs_error")?;
    for format in [Format::F32,Format::BF16,Format::F16,Format::Int8,Format::Bfp8] {
        let aq=quantize(&a,format);
        let bq=quantize(&b,format);
        let mut output=vec![0f32;n];
        for iteration in 0..(samples+10) {
            let start=Instant::now();
            for i in 0..n {output[i]=black_box(aq[i])+black_box(bq[i]);}
            black_box(&output);
            let ns=start.elapsed().as_nanos();
            let (rmse,max_abs)=error_metrics(&output,&reference);
            if iteration>=10 {
                writeln!(writer,"{},software_emulation,rust_cpu,vector_add,{n},{},{ns},{rmse},{max_abs}",format.name(),iteration-10)?;
            }
        }
    }
    writer.flush()?;
    println!("Saved {path}; all reduced formats are software-quantized and computed in f32, NOT native reduced-precision arithmetic.");
    Ok(())
}
