//! Portable memory kernels; callers own allocation and timing boundaries.
use std::hint::black_box;
pub fn stream_copy(input: &[f32], output: &mut [f32]) {
    output.copy_from_slice(input);
}
pub fn stream_scale(input: &[f32], output: &mut [f32], scale: f32) {
    assert_eq!(input.len(),output.len());
    for (o,x) in output.iter_mut().zip(input) { *o = *x * scale; }
}
pub fn stream_triad(a: &[f32], b: &[f32], output: &mut [f32], scale: f32) {
    assert_eq!(a.len(),b.len()); assert_eq!(a.len(),output.len());
    for ((o,x),y) in output.iter_mut().zip(a).zip(b) { *o = *x + scale * *y; }
}
/// Dependent pointer chasing. Permutation must be valid; return final index.
pub fn pointer_chase(next: &[usize], steps: usize) -> usize {
    let mut idx=0;
    for _ in 0..steps { idx=black_box(next[idx]); }
    idx
}
pub fn ring_permutation(n: usize, stride: usize) -> Vec<usize> {
    assert!(n>0 && stride>0);
    // A single cycle if stride and n are coprime.
    assert_eq!(gcd(n,stride),1,"stride must be coprime to n");
    (0..n).map(|i|(i+stride)%n).collect()
}
fn gcd(mut a:usize,mut b:usize)->usize { while b!=0 { let r=a%b;a=b;b=r; } a }
#[repr(C)]
#[derive(Clone,Copy,Default)]
pub struct ParticleAoS { pub x:f32,pub y:f32,pub z:f32,pub mass:f32 }
pub struct ParticleSoA { pub x:Vec<f32>,pub y:Vec<f32>,pub z:Vec<f32>,pub mass:Vec<f32> }
impl From<&[ParticleAoS]> for ParticleSoA {
    fn from(v:&[ParticleAoS])->Self {
        Self { x:v.iter().map(|p|p.x).collect(),y:v.iter().map(|p|p.y).collect(),
            z:v.iter().map(|p|p.z).collect(),mass:v.iter().map(|p|p.mass).collect() }
    }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test] fn memory_correctness() {
   let a=[1.,2.];let b=[3.,4.];let mut out=[0.;2];
   stream_copy(&a,&mut out);assert_eq!(out,a);
   stream_scale(&a,&mut out,2.);assert_eq!(out,[2.,4.]);
   stream_triad(&a,&b,&mut out,2.);assert_eq!(out,[7.,10.]);
   assert_eq!(pointer_chase(&ring_permutation(7,3),7),0);
 }
}
