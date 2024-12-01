use std::fs;

pub fn read_input(day: u32) -> String {
    let path = format!("input/day{:02}.txt", day);
    fs::read_to_string(path).unwrap()
}
