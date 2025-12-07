use itertools::Itertools;
use aoc_2025::utils::read_input;

const DAY: u8 = 7;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    solve(input).splits
}

fn part_2(input: &str) -> usize {
    solve(input).timelines
}

fn solve(input: &str) -> Solution {
    let lines: Vec<&[u8]> = input.lines().map(|line| line.as_bytes()).collect();
    let initial_beams = lines[0].iter().map(|&c| usize::from(c == b'S')).collect_vec();

    let (final_beams, total_splits) = lines[1..].iter().fold((initial_beams, 0), |(beams, splits), line| {
        beams
            .iter()
            .enumerate()
            .zip(line.iter())
            .fold((vec![0; beams.len()], splits), |(mut beams, splits), ((beam_pos, beam_timelines), cell)| {
                if *beam_timelines > 0 && *cell == b'^' {
                    beams[beam_pos - 1] += beam_timelines;
                    beams[beam_pos + 1] += beam_timelines;
                    (beams, splits + 1)
                } else {
                    beams[beam_pos] += beam_timelines;
                    (beams, splits)
                }
            })
    });

    Solution { splits: total_splits, timelines: final_beams.iter().sum() }
}

struct Solution {
    splits: usize,
    timelines: usize
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = ".......S.......\n\
                          ...............\n\
                          .......^.......\n\
                          ...............\n\
                          ......^.^......\n\
                          ...............\n\
                          .....^.^.^.....\n\
                          ...............\n\
                          ....^.^...^....\n\
                          ...............\n\
                          ...^.^...^.^...\n\
                          ...............\n\
                          ..^...^.....^..\n\
                          ...............\n\
                          .^.^.^.^.^...^.\n\
                          ...............";
    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 21);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 1504);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 40);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 5137133207830);
    }
}
