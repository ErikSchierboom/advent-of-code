use aoc_2025::utils::read_input;
use itertools::Itertools;
use std::ops::{Add, Mul};

const DAY: u8 = 6;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> u64 {
    solve(input, parse_numbers_horizontally)
}

fn part_2(input: &str) -> u64 {
    solve(input, parse_numbers_vertically)
}

fn solve<F: Fn(Vec<&[u8]>) -> Vec<u64>>(input: &str, parse_numbers: F) -> u64 {
    let lines: Vec<&[u8]> = input.lines().map(|line| line.as_bytes()).collect();
    let (operators_line, number_lines) = lines.split_last().unwrap();

    operators_line
        .iter()
        .positions(|c| *c != b' ')
        .merge(vec![operators_line.len() + 1])
        .tuple_windows()
        .map(|(from, to)| {
            parse_numbers(number_lines.iter().map(|line| &line[from..to - 1]).collect())
                .into_iter()
                .reduce(if operators_line[from] == b'*' { u64::mul } else { u64::add })
                .unwrap()
        })
        .sum()
}

fn parse_numbers_horizontally(lines: Vec<&[u8]>) -> Vec<u64> {
    lines
        .iter()
        .map(|line|
            line.iter()
                .filter_map(|&c| c.is_ascii_digit().then(|| (c - b'0') as u64))
                .fold(0u64, |acc, digit| acc * 10 + digit)
        ).collect()
}

fn parse_numbers_vertically(lines: Vec<&[u8]>) -> Vec<u64> {
    (0..lines[0].len())
        .map(|row|
            lines.iter()
                .filter_map(|&line| line[row].is_ascii_digit().then(|| (line[row] - b'0') as u64))
                .fold(0u64, |acc, digit| acc * 10 + digit)
        ).collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  ";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 4277556);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 6503327062445);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 3263827);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 9640641878593);
    }
}
