//! CUDA C ABI integration boundary. GPU calls are deliberately not linked yet.
#[repr(C)]
#[derive(Debug, Clone, Copy)]
pub struct DcResult { pub status: i32, pub elapsed_ms: f32, pub selected: u64 }
pub const DC_NOT_IMPLEMENTED: i32 = -2;
pub fn cuda_available() -> bool { false }
