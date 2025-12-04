use aoc_2025::utils::read_input;
use std::collections::HashSet;

const NEIGHBORS: [(isize, isize); 8] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

fn main() {
    let input = read_input(4);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    removal_rounds(input).next().unwrap()
}

fn part_2(input: &str) -> usize {
    removal_rounds(input).sum()
}

fn removal_rounds(input: &str) -> impl Iterator<Item=usize> {
    std::iter::repeat(())
        .scan(parse_paper_coordinates(input), |paper_rolls, _| {
            let rolls_to_remove: Vec<(isize, isize)> = paper_rolls
                .iter()
                .filter(|&&(y, x)| {
                    NEIGHBORS
                        .iter()
                        .filter(|&&(dy, dx)| paper_rolls.contains(&(y + dy, x + dx)))
                        .count()
                        < 4
                })
                .cloned()
                .collect();

            for roll_to_remove in &rolls_to_remove {
                paper_rolls.remove(&roll_to_remove);
            }

            if rolls_to_remove.is_empty() { None } else { Some(rolls_to_remove.len()) }
        })
}

fn parse_paper_coordinates(input: &str) -> HashSet<(isize, isize)> {
    input
        .lines()
        .enumerate()
        .flat_map(|(y, row)| {
            row.bytes()
                .enumerate()
                .filter_map(move |(x, cell)| if cell == b'@' { Some((y as isize, x as isize)) } else { None })
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "..@@.@@@@.\n\
                          @@@.@.@.@@\n\
                          @@@@@.@.@@\n\
                          @.@@@@..@.\n\
                          @@.@@@@.@@\n\
                          .@@@@@@@.@\n\
                          .@.@.@.@@@\n\
                          @.@@@.@@@@\n\
                          .@@@@@@@@.\n\
                          @.@.@@@.@.";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 13);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(4)), 1460);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 43);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(4)), 9243);
    }
}
