use std::ops::{Add, Sub};

pub struct Rotation {
    before: i32,
    after: i32,
    by: i32,
}

pub fn part_1(input: &str) -> usize {
    rotations(input)
        .filter(|rotation| rotation.after == 0)
        .count()
}

pub fn part_2(input: &str) -> i32 {
    rotations(input)
        .map(|rotation| {
            let full_rotations = rotation.by.abs() / 100;

            if rotation.after == 0 {
                full_rotations + 1
            } else if rotation.by.signum() == rotation.before.sub(rotation.after).signum() * rotation.before.signum() {
                full_rotations + 1
            } else {
                full_rotations
            }
        })
        .sum()
}

fn rotations(input: &str) -> impl Iterator<Item=Rotation> {
    input
        .lines()
        .map(|rotation| if &rotation[0..1] == "L" { -1 } else { 1 } * rotation[1..].parse::<i32>().unwrap())
        .scan(50, |current, rotated_by| {
            let before = current.clone();
            let after = current.add(rotated_by).rem_euclid(100);
            *current = after;
            Some(Rotation { before, after, by: rotated_by })
        })
}

#[cfg(test)]
mod tests {
    use crate::utils::read_input;
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
        assert_eq!(part_1(&read_input(1)), 1182);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 6);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(1)), 6907);
    }
}
