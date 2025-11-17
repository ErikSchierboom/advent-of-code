use crate::utils::solve;

mod day01;
mod utils;

const LATEST_DAY: u8 = 1;

fn solve_day(day: u8) {
    match day {
        1 => solve(day, day01::part_1, day01::part_2),
        _ => panic!("Unimplemented day")
    }
}

fn main() {
    match std::env::args().nth(1) {
        Some(arg) => solve_day(arg.parse::<u8>().unwrap()),
        None => (1..=LATEST_DAY).for_each(solve_day),
    }
}
