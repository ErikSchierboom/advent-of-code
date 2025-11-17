use std::collections::HashSet;

pub fn part_1(input: &str) -> i32 {
    input
        .lines()
        .map(|number| number.parse::<i32>().unwrap())
        .reduce(|accum, item| accum + item)
        .unwrap()
}

pub fn part_2(input: &str) -> i32 {
    let mut processed: HashSet<i32> = HashSet::new();
    let mut accum = 0;

    for number in input.lines().cycle() {
        accum = accum + number.parse::<i32>().unwrap();
        if !processed.insert(accum) {
            return accum
        }
    }

    panic!("Can't reach")
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "+1\n\
                          -2\n\
                          +3\n\
                          +1";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 3);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 2);
    }
}
