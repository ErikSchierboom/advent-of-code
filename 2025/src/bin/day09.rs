use aoc_2025::utils::read_input;

const DAY: u8 = 9;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> i64 {
    let tiles: Vec<(i64, i64)> = input.lines()
        .map(|line| {
            let (x, y) = line.split_once(',').unwrap();
            (x.parse().unwrap(), y.parse().unwrap())
        }).collect();

    tiles.iter()
        .map(|(x, y)| {
             tiles
                .iter()
                .filter(|(tile_x, tile_y)| *tile_y != *y && *tile_x != *x)
                .max_by_key(|(tile_x, tile_y)| (x - tile_x).pow(2) + (y - tile_y).pow(2))
                .map(|(opposite_x, opposite_y)| ((*x - opposite_x).abs() + 1) * ((*y - opposite_y).abs() + 1))
                .unwrap()
        })
        .max()
        .unwrap()
}

fn part_2(input: &str) -> i64 {
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "7,1\n\
                          11,1\n\
                          11,7\n\
                          9,7\n\
                          9,5\n\
                          2,5\n\
                          2,3\n\
                          7,3";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 50);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 4749838800);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 25272);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 673096646);
    }
}
