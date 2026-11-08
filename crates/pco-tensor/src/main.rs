use std::{env,fs::{self,File},io::Write,hint::black_box,time::{Instant,SystemTime,UNIX_EPOCH}};
use pco_tensor::Tensor;
use pco_precision::{Format,quantize,error_metrics};
fn main()->Result<(),Box<dyn std::error::Error>>{
 let args:Vec<String>=env::args().collect();
 let side:usize=args.get(1).map(|s|s.parse()).transpose()?.unwrap_or(16);
 let warmups:usize=args.get(2).map(|s|s.parse()).transpose()?.unwrap_or(10);
 let samples:usize=args.get(3).map(|s|s.parse()).transpose()?.unwrap_or(30);
 if side==0||side>128||warmups>10000||samples==0||samples>10000{return Err("invalid size/warmups/samples".into())}
 fs::create_dir_all("results/raw")?;
 let path=format!("results/raw/tensor-{}.csv",SystemTime::now().duration_since(UNIX_EPOCH)?.as_nanos());
 let mut f=File::create(&path)?;
 writeln!(f,"backend,workload,rank,shape,format,arithmetic,accumulation,elements,iteration,elapsed_ns,rmse_vs_f32,max_abs_error,validation")?;
 let formats=[Format::F32,Format::BF16,Format::F16,Format::Int8,Format::Bfp8];
 for rank in 1..=6 {
  let shape=vec![side;rank];
  let n=shape.iter().product::<usize>();
  if n>262144{continue}
  let a=Tensor::deterministic(shape.clone())?;
  let b=Tensor::new(shape.clone(),a.data.iter().rev().copied().collect())?;
  let operations:Vec<&str>=if rank==1{vec!["add","multiply","dot"]}else if rank==2{vec!["add","multiply","matmul"]}else{vec!["add","multiply","batched_matmul"]};
  for operation in operations {
   let reference:Vec<f32>=match operation {
    "add"=>a.add(&b)?.data,"multiply"=>a.multiply(&b)?.data,
    "dot"=>vec![a.dot(&b)? as f32],"matmul"=>a.matmul(&b)?.data,
    "batched_matmul"=>{if rank>2 && side<=16{a.batched_matmul(&b)?.data}else{continue}},
    _=>unreachable!()
   };
   for format in formats {
    let aq=Tensor::new(shape.clone(),quantize(&a.data,format))?;
    let bq=Tensor::new(shape.clone(),quantize(&b.data,format))?;
    for iter in 0..warmups+samples {
     let start=Instant::now();
     let result:Vec<f32>=match operation {
      "add"=>aq.add(&bq)?.data,"multiply"=>aq.multiply(&bq)?.data,
      "dot"=>vec![aq.dot(&bq)? as f32],"matmul"=>aq.matmul(&bq)?.data,
      "batched_matmul"=>aq.batched_matmul(&bq)?.data,_=>unreachable!()
     };
     black_box(&result);
     let ns=start.elapsed().as_nanos();
     if iter>=warmups{
      let (rmse,max)=error_metrics(&result,&reference);
      writeln!(f,"rust_cpu,{operation},{rank},{},{},software_quantized,f32,{n},{},{ns},{rmse},{max},pass",shape.iter().map(|x|x.to_string()).collect::<Vec<_>>().join("x"),format.name(),iter-warmups)?;
     }
    }
   }
  }
 }
 println!("Saved {path}; reduced formats quantize storage in software; CPU math is f32.");
 Ok(())
}
