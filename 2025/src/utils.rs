use std::fmt::{Display};
use std::fs;
use std::time::{Duration, SystemTime};

pub fn read_input(day: u8) -> String {
    let path = format!("{}/input/day{day:02}.txt", env!("CARGO_MANIFEST_DIR"));
    fs::read_to_string(path).unwrap()
}

pub fn timed<F: FnOnce() -> T, T>(f: F) -> (T, Duration) {
    let start = SystemTime::now();
    let result = f();
    let duration = SystemTime::now().duration_since(start).unwrap();
    (result, duration)
}

pub fn solve<F1, F2, T1, T2>(day: u8, part_1: F1, part_2: F2)
where
    F1: FnOnce(&str) -> T1,
    F2: FnOnce(&str) -> T2,
    T1: Display,
    T2: Display,
{
    let input = read_input(day);
    let (part_1, part_1_time) = timed(|| part_1(&input));
    let (part_2, part_2_time) = timed(|| part_2(&input));

    println!("[Day {day}]");
    println!("  Part 1: {} ({} ms)", part_1, part_1_time.as_millis());
    println!("  Part 2: {} ({} ms)", part_2, part_2_time.as_millis());
}
