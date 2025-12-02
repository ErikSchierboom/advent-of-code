use itertools::Itertools;

pub fn part_1(input: &str) -> i64 {
    invalid_ids_sum(input, is_invalid_part_1)
}

pub fn part_2(input: &str) -> i64 {
    invalid_ids_sum(input, is_invalid_part_2)
}

fn invalid_ids_sum(input: &str, invalid_check: impl Fn(&i64) -> bool) -> i64 {
    input
        .split(',')
        .flat_map(|range| {
            let (from, to) = range.split_once('-').unwrap();
            from.parse().unwrap() ..= to.parse().unwrap()
        })
        .filter(invalid_check)
        .sum()
}

fn is_invalid_part_1(number: &i64) -> bool {
    let str = number.to_string();
    if str.len() % 2 == 1 {
        return false
    }

    let bytes = str.as_bytes();
    let (left, right) = bytes.split_at(str.len() / 2);
    left == right
}

fn is_invalid_part_2(number: &i64) -> bool {
    let str = number.to_string();
    let bytes = str.as_bytes();

    (1..=str.len() / 2)
        .filter(|width| str.len() % width == 0)
        .any(|width| bytes.chunks(width).all_equal())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utils::read_input;

    const SAMPLE: &str = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 1227775554);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(2)), 13919717792);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 4174379265);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(2)), 14582313461);
    }
}
