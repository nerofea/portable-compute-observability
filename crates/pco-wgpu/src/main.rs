//! Portable wgpu/WGSL vector addition. Reports dispatch+readback wall time, not GPU kernel time.
use std::{env,error::Error,fs::{self,File},io::Write,time::{Instant,SystemTime,UNIX_EPOCH}};
use wgpu::util::DeviceExt;
const SHADER:&str=r#"
struct Params { n:u32, }
@group(0) @binding(0) var<storage,read> a:array<f32>;
@group(0) @binding(1) var<storage,read> b:array<f32>;
@group(0) @binding(2) var<storage,read_write> output:array<f32>;
@group(0) @binding(3) var<uniform> params:Params;
@compute @workgroup_size(256)
fn main(@builtin(global_invocation_id) gid:vec3<u32>) {
 if(gid.x<params.n){output[gid.x]=a[gid.x]+b[gid.x];}
}
"#;
fn main()->Result<(),Box<dyn Error>>{pollster::block_on(run())}
async fn run()->Result<(),Box<dyn Error>>{
 let args:Vec<String>=env::args().collect();
 let n:usize=args.get(1).map(|s|s.parse()).transpose()?.unwrap_or(65536);
 let warmups:usize=args.get(2).map(|s|s.parse()).transpose()?.unwrap_or(10);
 let samples:usize=args.get(3).map(|s|s.parse()).transpose()?.unwrap_or(30);
 if n==0||n>16_777_216||samples==0||samples>10000||warmups>10000{return Err("invalid experiment size".into());}
 let instance=wgpu::Instance::default();
 let adapter=instance.request_adapter(&wgpu::RequestAdapterOptions{power_preference:wgpu::PowerPreference::HighPerformance,compatible_surface:None,force_fallback_adapter:false}).await.ok_or("No GPU adapter")?;
 let info=adapter.get_info();
 let (device,queue)=adapter.request_device(&wgpu::DeviceDescriptor{label:Some("pco-wgpu"),required_features:wgpu::Features::empty(),required_limits:wgpu::Limits::default(),memory_hints:wgpu::MemoryHints::Performance},None).await?;
 let a:Vec<f32>=(0..n).map(|i|(i%997) as f32*0.001).collect();
 let b:Vec<f32>=(0..n).map(|i|(i%991) as f32*0.002).collect();
 let byte_size=(n*4) as u64;
 let input=|label:&str,values:&[f32]|device.create_buffer_init(&wgpu::util::BufferInitDescriptor{label:Some(label),contents:bytemuck::cast_slice(values),usage:wgpu::BufferUsages::STORAGE});
 let ab=input("a",&a);let bb=input("b",&b);
 let output=device.create_buffer(&wgpu::BufferDescriptor{label:Some("output"),size:byte_size,usage:wgpu::BufferUsages::STORAGE|wgpu::BufferUsages::COPY_SRC,mapped_at_creation:false});
 let staging=device.create_buffer(&wgpu::BufferDescriptor{label:Some("staging"),size:byte_size,usage:wgpu::BufferUsages::MAP_READ|wgpu::BufferUsages::COPY_DST,mapped_at_creation:false});
 let params=device.create_buffer_init(&wgpu::util::BufferInitDescriptor{label:Some("n"),contents:bytemuck::bytes_of(&(n as u32)),usage:wgpu::BufferUsages::UNIFORM});
 let shader=device.create_shader_module(wgpu::ShaderModuleDescriptor{label:Some("vector_add"),source:wgpu::ShaderSource::Wgsl(SHADER.into())});
 let layout=device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor{label:None,entries:&[
 (0,wgpu::BufferBindingType::Storage{read_only:true}),(1,wgpu::BufferBindingType::Storage{read_only:true}),(2,wgpu::BufferBindingType::Storage{read_only:false}),(3,wgpu::BufferBindingType::Uniform)
 ].map(|(binding,ty)|wgpu::BindGroupLayoutEntry{binding,visibility:wgpu::ShaderStages::COMPUTE,ty:wgpu::BindingType::Buffer{ty,has_dynamic_offset:false,min_binding_size:None},count:None})});
 let group=device.create_bind_group(&wgpu::BindGroupDescriptor{label:None,layout:&layout,entries:&[
 wgpu::BindGroupEntry{binding:0,resource:ab.as_entire_binding()},wgpu::BindGroupEntry{binding:1,resource:bb.as_entire_binding()},wgpu::BindGroupEntry{binding:2,resource:output.as_entire_binding()},wgpu::BindGroupEntry{binding:3,resource:params.as_entire_binding()}]});
 let pipeline_layout=device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor{label:None,bind_group_layouts:&[&layout],push_constant_ranges:&[]});
 let pipeline=device.create_compute_pipeline(&wgpu::ComputePipelineDescriptor{label:None,layout:Some(&pipeline_layout),module:&shader,entry_point:Some("main"),compilation_options:wgpu::PipelineCompilationOptions::default(),cache:None});
 fs::create_dir_all("results/raw")?;
 let stamp=SystemTime::now().duration_since(UNIX_EPOCH)?.as_nanos();
 let path=format!("results/raw/wgpu-{stamp}.csv");let mut file=File::create(&path)?;
 writeln!(file,"backend,workload,elements,iteration,elapsed_ns,timing_scope,validation")?;
 for iteration in 0..(warmups+samples){
  let mut encoder=device.create_command_encoder(&wgpu::CommandEncoderDescriptor{label:None});
  {let mut pass=encoder.begin_compute_pass(&wgpu::ComputePassDescriptor{label:None,timestamp_writes:None});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups((n as u32+255)/256,1,1);}
  encoder.copy_buffer_to_buffer(&output,0,&staging,0,byte_size);
  let start=Instant::now();queue.submit(Some(encoder.finish()));
  let slice=staging.slice(..);let (sender,receiver)=std::sync::mpsc::channel();
  slice.map_async(wgpu::MapMode::Read,move|result|{let _=sender.send(result);});
  device.poll(wgpu::Maintain::Wait);receiver.recv()??;
  let elapsed=start.elapsed().as_nanos();
  {let data=slice.get_mapped_range();let values:&[f32]=bytemuck::cast_slice(&data);
   if values.iter().zip(a.iter().zip(&b)).any(|(&v,(&x,&y))|(v-(x+y)).abs()>1e-5+(x+y).abs()*1e-5){return Err("GPU validation mismatch".into());}}
  staging.unmap();
  if iteration>=warmups{writeln!(file,"wgpu,vector_add,{n},{},{elapsed},submit_readback_wall,pass",iteration-warmups)?;}
 }
 println!("Adapter: {} ({:?})",info.name,info.backend);println!("Saved {path}");Ok(())
}
