use itertools::Itertools;

fn main() {
    let top_elves = include_str!("../input.txt")
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

    println!("a: {:?}", top_elves.first().unwrap());
    println!("b: {:?}", top_elves.into_iter().sum::<i32>())
}
