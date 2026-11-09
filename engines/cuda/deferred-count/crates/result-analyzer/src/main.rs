use std::{env, fs, process};
fn main() {
    let path = env::args().nth(1).unwrap_or_default();
    if path.is_empty() { eprintln!("usage: result-analyzer <existing-jsonl-file>"); process::exit(2); }
    match fs::read_to_string(&path) {
        Ok(contents) => println!("Read {} nonempty result records (schema/statistical validation pending)", contents.lines().filter(|l| !l.trim().is_empty()).count()),
        Err(e) => { eprintln!("cannot read results: {e}"); process::exit(1); }
    }
}
