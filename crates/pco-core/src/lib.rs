//! Portable benchmark contracts and deterministic data generation.
#[derive(Debug, Clone, Copy)]
pub enum Workload { VectorAdd, Reduction, Copy }
impl Workload {
    pub fn as_str(self) -> &'static str {
        match self { Self::VectorAdd => "vector_add", Self::Reduction => "reduction", Self::Copy => "copy" }
    }
}
#[derive(Debug, Clone)]
pub struct Measurement {
    pub workload: &'static str,
    pub backend: &'static str,
    pub elements: usize,
    pub sample_ns: u128,
    pub bytes_logical: usize,
    pub checksum: f64,
}
pub fn deterministic_inputs(n: usize) -> (Vec<f32>, Vec<f32>) {
    let a = (0..n).map(|i| ((i % 997) as f32) * 0.001).collect();
    let b = (0..n).map(|i| ((i % 991) as f32) * 0.002).collect();
    (a,b)
}
pub fn approx_equal(actual: f64, expected: f64, atol: f64, rtol: f64) -> bool {
    (actual - expected).abs() <= atol + rtol * expected.abs()
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn reproducible() { assert_eq!(deterministic_inputs(100), deterministic_inputs(100)); }
    #[test] fn tolerance() { assert!(approx_equal(1.00001, 1.0, 0.0001, 0.0)); }
}
