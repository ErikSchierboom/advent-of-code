use std::fmt::Error;
use std::str::FromStr;

struct Assignment { low: i32, high: i32 }
struct AssignmentPair { first: Assignment, second: Assignment }

impl Assignment {
    fn contains(&self, other: &Assignment) -> bool {
        self.low >= other.low && self.high <= other.high
    }

    fn overlaps(&self, other: &Assignment) -> bool {
        self.low >= other.low && self.low <= other.high ||
        self.high >= other.low && self.high <= other.high
    }
}

impl AssignmentPair {
    fn contains(&self) -> bool {
        self.first.contains(&self.second) || self.second.contains(&self.first)
    }

    fn overlaps(&self) -> bool {
        self.first.overlaps(&self.second) || self.second.overlaps(&self.first)
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
            (a + assignment_pair.contains() as usize, b + assignment_pair.overlaps() as usize)
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
