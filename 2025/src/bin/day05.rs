use std::cmp::Ordering;
use aoc_2025::utils::read_input;
use itertools::Itertools;

const DAY: u8 = 5;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    let (ranges, ingredients) = parse_data(input);

    ingredients
        .iter()
        .filter(|&ingredient| ranges.binary_search_by(|range|  {
            match (range.0.cmp(ingredient), range.1.cmp(ingredient)) {
                (Ordering::Greater, _) => Ordering::Greater,
                (_, Ordering::Less) => Ordering::Less,
                _ => Ordering::Equal
            }
        }).is_ok())
        .count()
}

fn part_2(input: &str) -> u64 {
    let (ranges, _) = parse_data(input);
    ranges.into_iter().map(|(from, to)| to - from + 1).sum()
}

fn parse_data(input: &str) -> (Vec<(u64, u64)>, Vec<u64>) {
    let (ranges, ingredients): (&str, &str) = input.split_once("\n\n").unwrap();
    (parse_ranges(ranges), parse_ingredients(ingredients))
}

fn parse_ranges(ranges: &str) -> Vec<(u64, u64)> {
    ranges
        .lines()
        .map(|range| {
            let (from, to) = range.split_once('-').unwrap();
            (from.parse().unwrap(), to.parse().unwrap())
        })
        .sorted()
        .fold(Vec::new(), |mut merged, next| {
            match merged.last_mut() {
                Some(last) if next.0 <= last.1 => last.1 = last.1.max(next.1),
                _ => merged.push(next),
            }

            merged
        })
}

fn parse_ingredients(ingredients: &str) -> Vec<u64> {
    ingredients.lines().map(|ingredient| ingredient.parse().unwrap()).collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "3-5\n\
                          10-14\n\
                          16-20\n\
                          12-18\n\
                          \n\
                          1\n\
                          5\n\
                          8\n\
                          11\n\
                          17\n\
                          32";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 3);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 611);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 14);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 345995423801866);
    }
}
