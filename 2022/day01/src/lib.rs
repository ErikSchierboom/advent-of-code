use itertools::Itertools;

pub fn solve() -> (i32, i32) {
    let calories = include_str!("../input.txt")
        .split("\n\n")
        .map(|foods| {
            foods
                .lines()
                .map(|food| food.parse::<i32>().unwrap())
                .sum::<i32>()
        })
        .sorted()
        .rev()
        .take(3)
        .collect_vec();

    (calories[0], calories[0..=2].into_iter().sum::<i32>())
}
