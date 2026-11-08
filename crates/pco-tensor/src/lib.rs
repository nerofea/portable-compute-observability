//! Contiguous row-major tensors, explicit shape checks, CPU reference math.
#[derive(Clone,Debug)]
pub struct Tensor { pub shape:Vec<usize>, pub data:Vec<f32> }
pub fn elements(shape:&[usize])->Result<usize,String>{
 if shape.is_empty() || shape.len()>8 || shape.iter().any(|&x|x==0){return Err("rank must be 1..8 and dimensions positive".into())}
 shape.iter().try_fold(1usize,|a,&b|a.checked_mul(b).ok_or_else(||"shape overflow".to_string()))
}
impl Tensor {
 pub fn new(shape:Vec<usize>,data:Vec<f32>)->Result<Self,String>{
  if elements(&shape)?!=data.len(){return Err("shape/data length mismatch".into())}
  Ok(Self{shape,data})
 }
 pub fn deterministic(shape:Vec<usize>)->Result<Self,String>{
  let n=elements(&shape)?;Self::new(shape,(0..n).map(|i|((i*17%251) as f32-125.)/127.).collect())
 }
 pub fn strides(&self)->Vec<usize>{
  let mut s=vec![1;self.shape.len()];
  for i in (0..self.shape.len()-1).rev(){s[i]=s[i+1]*self.shape[i+1];}s
 }
 pub fn index(&self,coords:&[usize])->Result<usize,String>{
  if coords.len()!=self.shape.len()||coords.iter().zip(&self.shape).any(|(&i,&n)|i>=n){return Err("index out of bounds".into())}
  Ok(coords.iter().zip(self.strides()).map(|(&i,s)|i*s).sum())
 }
 pub fn add(&self,rhs:&Self)->Result<Self,String>{
  if self.shape!=rhs.shape{return Err("shape mismatch".into())}
  Self::new(self.shape.clone(),self.data.iter().zip(&rhs.data).map(|(&a,&b)|a+b).collect())
 }
 pub fn multiply(&self,rhs:&Self)->Result<Self,String>{
  if self.shape!=rhs.shape{return Err("shape mismatch".into())}
  Self::new(self.shape.clone(),self.data.iter().zip(&rhs.data).map(|(&a,&b)|a*b).collect())
 }
 pub fn sum(&self)->f64{self.data.iter().map(|&v|v as f64).sum()}
 pub fn dot(&self,rhs:&Self)->Result<f64,String>{
  if self.shape.len()!=1||rhs.shape!=self.shape{return Err("dot requires equal vectors".into())}
  Ok(self.data.iter().zip(&rhs.data).map(|(&a,&b)|a as f64*b as f64).sum())
 }
 pub fn matmul(&self,rhs:&Self)->Result<Self,String>{
  if self.shape.len()!=2||rhs.shape.len()!=2||self.shape[1]!=rhs.shape[0]{return Err("matmul requires [m,k] x [k,n]".into())}
  let (m,k,n)=(self.shape[0],self.shape[1],rhs.shape[1]);
  let mut out=vec![0f32;m*n];
  for i in 0..m {for j in 0..n {
   let mut acc=0f32;for p in 0..k{acc+=self.data[i*k+p]*rhs.data[p*n+j];}
   out[i*n+j]=acc;
  }}
  Self::new(vec![m,n],out)
 }
 pub fn batched_matmul(&self,rhs:&Self)->Result<Self,String>{
  if self.shape.len()<3||self.shape!=rhs.shape{return Err("batched matmul requires matching square matrices and batch dimensions".into())}
  let rank=self.shape.len();let n=self.shape[rank-1];
  if self.shape[rank-2]!=n{return Err("square matrices required".into())}
  let batches=elements(&self.shape[..rank-2])?;
  let mut out=vec![0f32;self.data.len()];
  for b in 0..batches {
   let off=b*n*n;
   for i in 0..n {for j in 0..n {
    let mut acc=0f32;for k in 0..n {acc+=self.data[off+i*n+k]*rhs.data[off+k*n+j];}
    out[off+i*n+j]=acc;
   }}
  }
  Self::new(self.shape.clone(),out)
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test] fn rank_six_index(){let t=Tensor::deterministic(vec![2,2,2,2,2,2]).unwrap();assert_eq!(t.index(&[1,0,0,0,0,0]).unwrap(),32);assert_eq!(t.strides(),vec![32,16,8,4,2,1]);}
 #[test] fn rank_eight(){assert_eq!(elements(&[2,2,2,2,2,2,2,2]).unwrap(),256);}
 #[test] fn math(){let a=Tensor::new(vec![2,2],vec![1.,2.,3.,4.]).unwrap();let b=Tensor::new(vec![2,2],vec![5.,6.,7.,8.]).unwrap();assert_eq!(a.matmul(&b).unwrap().data,vec![19.,22.,43.,50.]);assert_eq!(a.add(&b).unwrap().data,vec![6.,8.,10.,12.]);}
 #[test] fn batch(){let a=Tensor::new(vec![2,2,2],vec![1.,0.,0.,1.,2.,0.,0.,2.]).unwrap();assert_eq!(a.batched_matmul(&a).unwrap().data,vec![1.,0.,0.,1.,4.,0.,0.,4.]);}
 #[test] fn invalid(){assert!(Tensor::new(vec![2,2],vec![0.]).is_err());assert!(elements(&[usize::MAX,2]).is_err());}
}
