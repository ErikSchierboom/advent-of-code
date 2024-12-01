use itertools::Itertools;

fn part_1(input: &(Vec<i32>, Vec<i32>)) -> i32 {
    input.0.iter().sorted().zip(input.1.iter().sorted())
        .map(|(l, r)| (l - r).abs())
        .sum()
}

fn part_2(input: &(Vec<i32>, Vec<i32>)) -> i32 {
    let right_counts = input.1.iter().counts();
    input.0.iter()
        .map(|l| *l * *right_counts.get(l).unwrap_or(&0) as i32)
        .sum()
}

fn parse(input: &str) -> (Vec<i32>, Vec<i32>) {
    input
        .lines()
        .map(|line| {
            let (left, right) = line.split_once("   ").unwrap();
            (left.parse::<i32>().unwrap(), right.parse::<i32>().unwrap())
         })
        .collect()
}

fn main() {
    let data = parse(&aoc::read_input(1));
    println!("part A: {:0}", part_1(&data));
    println!("part B: {:0}", part_2(&data));
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "3   4
4   3
2   5
1   3
3   9
3   3";

    #[test]
    fn part_1_example() {
        assert_eq!(part_1(&parse(INPUT)), 11);
    }

    #[test]
    fn part_2_example() {
        assert_eq!(part_2(&parse(INPUT)), 31);
    }
}
