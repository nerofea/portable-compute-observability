//! CPU reference kernels. Output is consumed by the runner to prevent elimination.
pub fn vector_add(a: &[f32], b: &[f32], out: &mut [f32]) {
    assert_eq!(a.len(), b.len());
    assert_eq!(a.len(), out.len());
    for ((x,y), z) in a.iter().zip(b).zip(out.iter_mut()) { *z = *x + *y; }
}
pub fn reduction(a: &[f32]) -> f64 { a.iter().map(|&x| x as f64).sum() }
pub fn copy(a: &[f32], out: &mut [f32]) { out.copy_from_slice(a); }
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn add_correct() {
        let mut out = [0.0; 2];
        vector_add(&[1.,2.], &[3.,4.], &mut out);
        assert_eq!(out, [4.,6.]);
    }
}
