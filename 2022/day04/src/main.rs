use std::fmt::Error;
use std::str::FromStr;

struct Assignment {
    low: i32,
    high: i32
}

struct AssignmentPair {
    first: Assignment,
    second: Assignment
}

impl AssignmentPair {
    fn fully_contained(&self) -> bool {
        self.first.low >= self.second.low && self.first.high <= self.second.high ||
        self.first.low <= self.second.low && self.first.high >= self.second.high
    }

    fn overlap(&self) -> bool {
        self.first.low >= self.second.low && self.first.low <= self.second.high ||
        self.first.high >= self.second.low && self.first.high <= self.second.high ||
        self.second.low >= self.first.low && self.second.low <= self.first.high ||
        self.second.high >= self.first.low && self.second.high <= self.first.high
    }
}

impl FromStr for Assignment {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        s.split_once('-').map(|(low, high)|
            Assignment { low: low.parse::<i32>().unwrap(), high: high.parse::<i32>().unwrap()  }
        ).ok_or(Error::default())
    }
}

impl FromStr for AssignmentPair {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        s.split_once(',').map(|(first, second)|
            AssignmentPair { first: first.parse::<Assignment>().unwrap(), second: second.parse::<Assignment>().unwrap() }
        ).ok_or(Error::default())
    }
}

fn solve() -> (usize, usize) {
    include_str!("../input.txt")
        .lines()
        .map(|line| line.parse::<AssignmentPair>().unwrap())
         .fold((0, 0), |(a, b), assignment_pair|
            (a + assignment_pair.fully_contained() as usize, b + assignment_pair.overlap() as usize)
        )
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
        assert_eq!(a, 518);
    }

    #[test]
    fn part_b() {
        let (_, b) = solve();
        assert_eq!(b, 909);
    }
}
