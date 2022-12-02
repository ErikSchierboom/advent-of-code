fn score_a(other_move: i32, my_move: i32) -> i32 {
    my_move + 1 + 3 * (1 + my_move - other_move).rem_euclid(3)
}

fn score_b(other_move: i32, my_move: i32) -> i32 {
    my_move * 3 + 1 + (my_move + other_move - 1).rem_euclid(3)
}

fn solve() -> (i32, i32) {
    const OTHER_MOVES: &'static str = "ABC";
    const MY_MOVES: &'static str = "XYZ";

    include_str!("../input.txt")
        .lines()
        .fold((0, 0), |(a, b), code| {
            let other_move = OTHER_MOVES.find(code.chars().nth(0).unwrap()).unwrap() as i32;
            let my_move = MY_MOVES.find(code.chars().nth(2).unwrap()).unwrap() as i32;

            (
                a + score_a(other_move, my_move),
                b + score_b(other_move, my_move),
            )
        })
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
        assert_eq!(a, 11873);
    }

    #[test]
    fn part_b() {
        let (_, b) = solve();
        assert_eq!(b, 12014);
    }
}
