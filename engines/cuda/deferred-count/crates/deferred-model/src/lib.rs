//! Shared policy and workload contracts; no GPU timing is simulated.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Policy { Immediate, Readback, Deferred, Bucketed, Padded }
impl Policy {
    pub fn parse(value: &str) -> Option<Self> {
        match value { "immediate" => Some(Self::Immediate), "readback" => Some(Self::Readback), "deferred" => Some(Self::Deferred), "bucketed" => Some(Self::Bucketed), "padded" => Some(Self::Padded), _ => None }
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Workload { pub capacity: u64, pub selected: u64 }
impl Workload {
    pub fn validate(self) -> Result<(), &'static str> {
        if self.selected > self.capacity { Err("selected count exceeds capacity") } else { Ok(()) }
    }
}
/// Deterministic integer-only count trace for reproducible tests.
pub fn trace(seed: u64, capacity: u64, samples: usize) -> Vec<u64> {
    let mut state = seed;
    (0..samples).map(|_| { state ^= state << 13; state ^= state >> 7; state ^= state << 17; if capacity == u64::MAX { state } else { state % (capacity + 1) } }).collect()
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn count_bounds() { assert!(Workload { capacity: 8, selected: 9 }.validate().is_err()); }
    #[test] fn trace_reproducible() { assert_eq!(trace(7, 128, 100), trace(7, 128, 100)); }
    #[test] fn parse_policy() { assert_eq!(Policy::parse("deferred"), Some(Policy::Deferred)); }
}
