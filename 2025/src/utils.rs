use std::fs;

pub fn read_input(day: u8) -> String {
    let path = format!("{}/input/day{day:02}.txt", env!("CARGO_MANIFEST_DIR"));
    fs::read_to_string(path).unwrap()
}
