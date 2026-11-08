//! Explicit *software* numerical representations for controlled accuracy experiments.
//! These are not claims of native FP16/BF16/FP8 GPU execution.
pub fn bf16_bits(x: f32) -> u16 {
    let bits = x.to_bits();
    if x.is_nan() { return ((bits >> 16) as u16) | 0x0040; }
    let rounded = bits.wrapping_add(0x7fff + ((bits >> 16) & 1));
    (rounded >> 16) as u16
}
pub fn from_bf16(bits: u16) -> f32 { f32::from_bits((bits as u32) << 16) }
pub fn fp16_bits(x: f32) -> u16 {
    let bits = x.to_bits();
    let sign = ((bits >> 16) & 0x8000) as u16;
    let exponent = ((bits >> 23) & 0xff) as i32;
    let fraction = bits & 0x7fffff;
    if exponent == 255 {
        return sign | 0x7c00 | if fraction == 0 { 0 } else { ((fraction >> 13) as u16) | 0x0200 };
    }
    let e = exponent - 127 + 15;
    if e >= 31 { return sign | 0x7c00; }
    if e <= 0 {
        if e < -10 { return sign; }
        let mantissa = fraction | 0x800000;
        let shift = (14 - e) as u32;
        let base = mantissa >> shift;
        let remainder = mantissa & ((1u32 << shift) - 1);
        let half = 1u32 << (shift - 1);
        return sign | (base + u32::from(remainder > half || (remainder == half && (base & 1) == 1))) as u16;
    }
    let base = fraction >> 13;
    let remainder = fraction & 0x1fff;
    let rounded = base + u32::from(remainder > 0x1000 || (remainder == 0x1000 && (base & 1) == 1));
    (sign | ((e as u16) << 10)).wrapping_add(rounded as u16)
}
pub fn from_fp16(bits: u16) -> f32 {
    let sign = ((bits as u32) & 0x8000) << 16;
    let exp = ((bits >> 10) & 31) as i32;
    let mantissa = (bits & 1023) as u32;
    if exp == 31 { return f32::from_bits(sign | 0x7f800000 | (mantissa << 13)); }
    if exp == 0 {
        if mantissa == 0 { return f32::from_bits(sign); }
        let mut m = mantissa;
        let mut e = -14;
        while m < 1024 { m <<= 1; e -= 1; }
        return f32::from_bits(sign | (((e + 127) as u32) << 23) | ((m & 1023) << 13));
    }
    f32::from_bits(sign | (((exp - 15 + 127) as u32) << 23) | (mantissa << 13))
}
#[derive(Clone, Copy, Debug)]
pub enum Format { F32, BF16, F16, Int8, Bfp8 }
impl Format {
    pub fn name(self) -> &'static str {
        match self { Self::F32=>"f32", Self::BF16=>"bf16", Self::F16=>"fp16", Self::Int8=>"int8_symmetric", Self::Bfp8=>"bfp8_block32" }
    }
    pub fn parse(s: &str) -> Option<Self> {
        match s { "f32"=>Some(Self::F32),"bf16"=>Some(Self::BF16),"fp16"=>Some(Self::F16),"int8"=>Some(Self::Int8),"bfp8"=>Some(Self::Bfp8),_=>None }
    }
}
pub fn quantize(values: &[f32], format: Format) -> Vec<f32> {
    match format {
        Format::F32 => values.to_vec(),
        Format::BF16 => values.iter().map(|&x| from_bf16(bf16_bits(x))).collect(),
        Format::F16 => values.iter().map(|&x| from_fp16(fp16_bits(x))).collect(),
        Format::Int8 => {
            let peak = values.iter().fold(0f32, |m,&x| m.max(x.abs()));
            let scale = if peak == 0.0 { 1.0 } else { peak / 127.0 };
            values.iter().map(|&x| (x / scale).round().clamp(-127.0,127.0) * scale).collect()
        }
        Format::Bfp8 => {
            let mut out = Vec::with_capacity(values.len());
            for block in values.chunks(32) {
                let peak = block.iter().fold(0f32, |m,&x| m.max(x.abs()));
                let exponent = if peak == 0.0 { 0 } else { peak.log2().ceil() as i32 };
                let scale = 2f32.powi(exponent - 7);
                out.extend(block.iter().map(|&x| (x / scale).round().clamp(-127.0,127.0) * scale));
            }
            out
        }
    }
}
pub fn error_metrics(actual: &[f32], reference: &[f32]) -> (f64,f64) {
    assert_eq!(actual.len(), reference.len());
    let mut squared = 0f64;
    let mut max_abs = 0f64;
    for (&a,&b) in actual.iter().zip(reference) {
        let error = (a as f64 - b as f64).abs();
        squared += error*error;
        max_abs = max_abs.max(error);
    }
    ((squared / actual.len().max(1) as f64).sqrt(), max_abs)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn bf16_roundtrip() {
        for x in [0., -0., 1., -2., 0.1, 100.] { assert!((from_bf16(bf16_bits(x))-x).abs() < .5); }
    }
    #[test] fn fp16_known_values() {
        for (x,bits) in [(0.,0),(1.,0x3c00),(-2.,0xc000),(65504.,0x7bff),(0.00006103515625,0x0400)] {
            assert_eq!(fp16_bits(x),bits);
            assert_eq!(from_fp16(bits),x);
        }
        assert!(from_fp16(fp16_bits(f32::NAN)).is_nan());
        assert_eq!(fp16_bits(f32::INFINITY),0x7c00);
    }
    #[test] fn block_and_int8() {
        let x = vec![0.0,1.0,-1.0,0.125];
        for format in [Format::Int8,Format::Bfp8] {
            let y = quantize(&x,format);
            assert_eq!(y.len(),x.len());
            assert!(error_metrics(&y,&x).0 < 0.02);
        }
    }
}
