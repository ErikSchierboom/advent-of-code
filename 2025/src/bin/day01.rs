use std::ops::Add;
use aoc_2025::utils::read_input;

const DAY: u8 = 1;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    rotations(input).stopped_at_zero
}

fn part_2(input: &str) -> usize {
    rotations(input).passed_zero
}

fn rotations(input: &str) -> Rotations {
    input
        .lines()
        .fold(Rotations { stopped_at_zero: 0, passed_zero: 0, position: 50 }, |mut rotations, line| {
            let direction = if line.as_bytes()[0] == b'L' { -1 } else { 1 };
            let rotate_by = line[1..].parse::<i32>().unwrap();

            for _ in 0..rotate_by {
                rotations.position = rotations.position.add(direction).rem_euclid(100);
                rotations.passed_zero += usize::from(rotations.position == 0);
            }

            rotations.stopped_at_zero += usize::from(rotations.position == 0);
            rotations
        })
}

struct Rotations {
    stopped_at_zero: usize,
    passed_zero: usize,
    position: i32
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "L68\n\
                          L30\n\
                          R48\n\
                          L5\n\
                          R60\n\
                          L55\n\
                          L1\n\
                          L99\n\
                          R14\n\
                          L82";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 3);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 1182);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 6);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 6907);
    }
}
