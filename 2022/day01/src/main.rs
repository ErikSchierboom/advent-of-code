use itertools::Itertools;

fn solve() -> (i32, i32) {
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

fn main() {
    let (a, b) = solve();
    println!("a: {}", a);
    println!("b: {}", b)
}

#[cfg(test)]
mod tests {
    use crate::solve;

    #[test]
    fn part_a() {
        let (a, _) = solve();
        assert_eq!(a, 71124);
    }

    #[test]
    fn part_b() {
        let (_, b) = solve();
        assert_eq!(b, 204639);
    }
}
