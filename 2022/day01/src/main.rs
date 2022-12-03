fn solve() -> (i32, i32) {
    let mut calories: Vec<i32> = include_str!("../input.txt")
        .split("\n\n")
        .map(|foods| foods.lines().map(|food| food.parse::<i32>().unwrap()).sum())
        .collect();

    calories.sort_by(|a, b| b.cmp(a));

    (calories[0], calories.iter().take(3).sum())
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
