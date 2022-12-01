fn main() {
    let mut top_elves = include_str!("../input.txt")
        .split("\n\n")
        .map(|foods| {
            foods
                .lines()
                .map(|food| food.parse::<i32>().unwrap())
                .sum::<i32>()
        })
        .collect::<Vec<i32>>();

    top_elves.sort();
    top_elves.reverse();

    println!("a: {:?}", top_elves.first().unwrap());
    println!("b: {:?}", top_elves.into_iter().sum::<i32>())
}
