use itertools::Itertools;
use aoc_2025::utils::read_input;

fn main() {
    let input = read_input(3);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> u64 {
    total_output_joltage(input, 2)
}

fn part_2(input: &str) -> u64 {
    total_output_joltage(input, 12)
}

fn total_output_joltage(input: &str, num_digits: usize) -> u64 {
    input
        .lines()
        .map(|line| {
            let digits: Vec<u8> = line.bytes().map(|b| b - b'0').collect();
            output_joltage(&digits, 0, num_digits)
        })
        .sum()
}

fn output_joltage(digits: &[u8], offset: usize, remaining_digits: usize) -> u64 {
    if remaining_digits == 0 {
        return 0
    }

    let upper_bound = digits.len() - remaining_digits + 1;
    let digit_pos = upper_bound - digits[offset..upper_bound].iter().rev().position_max().unwrap() - 1;

    let joltage = digits[digit_pos] as u64 * 10u64.pow((remaining_digits - 1) as u32);
    joltage + output_joltage(digits, digit_pos + 1, remaining_digits - 1)
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "987654321111111\n\
                          811111111111119\n\
                          234234234234278\n\
                          818181911112111";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 357);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(3)), 17316);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 3121910778619);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(3)), 171741365473332);
    }
}
