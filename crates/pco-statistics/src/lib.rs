//! Basic descriptive statistics; preserve raw samples for later uncertainty analysis.
pub fn quantile(samples: &[f64], q: f64) -> Option<f64> {
    if samples.is_empty() || !(0.0..=1.0).contains(&q) { return None; }
    let mut sorted = samples.to_vec();
    sorted.sort_by(f64::total_cmp);
    let pos = q * (sorted.len()-1) as f64;
    let lo = pos.floor() as usize;
    let hi = pos.ceil() as usize;
    Some(sorted[lo] + (sorted[hi]-sorted[lo]) * (pos-lo as f64))
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn median() { assert_eq!(quantile(&[3.,1.,2.],0.5), Some(2.)); }
}
