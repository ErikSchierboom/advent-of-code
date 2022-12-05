use std::fmt::Error;
use std::str::FromStr;

type Crate = char;
type Stack = Vec<Crate>;
struct Crates { stacks: Vec<Stack> }
struct Move { count: u8, from: usize, to: usize }
struct State { crates: Crates, moves: Vec<Move> }

impl FromStr for Move {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let parts: Vec<&str> = s.split_whitespace().collect();
        Ok(Move { count: parts[1].parse::<u8>().unwrap(), from: parts[3].parse::<usize>().unwrap() - 1, to: parts[5].parse::<usize>().unwrap() - 1 })
    }
}

impl FromStr for Crates {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let lines: Vec<&str> = s.lines().collect();
        let count = lines.last().unwrap().split_whitespace().count();
        let mut stacks: Vec<Stack> = vec![Vec::new(); count];

        for line in lines[0..lines.len()].iter().rev() {
            for i in 0..count {
                let c = line.chars().nth(1 + i * 4).unwrap();
                if c == ' ' { continue }

                stacks[i].push(c);
            }
        }

        Ok(Crates { stacks })
    }
}

impl FromStr for State {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (crates, moves) = s.split_once("\n\n").unwrap();
        Ok(State { crates: crates.parse::<Crates>().unwrap(), moves: moves.lines().into_iter().map(|m| m.parse::<Move>().unwrap()).collect() })
    }
}

fn solve() -> (String, String) {
    let mut state = include_str!("../input.txt").parse::<State>().unwrap();
    for m in state.moves.iter() {
        for i in 0..m.count {
            let c = state.crates.stacks[m.from].pop().unwrap();
            state.crates.stacks[m.to].push(c);
        }
    }

    let chars: Vec<&char> = state.crates.stacks.iter().map(|s| s.last().unwrap()).into_iter().collect();
    let a: String = chars.into_iter().collect();

    let mut state = include_str!("../input.txt").parse::<State>().unwrap();
    for m in state.moves.iter() {
        let mut x: Vec<Crate> = Vec::new();

        for i in 0..m.count {
            let c = state.crates.stacks[m.from].pop().unwrap();
            x.push(c);
        }

        x.reverse();

        for a in x.iter() {
            state.crates.stacks[m.to].push(*a);
        }
    }

    let chars: Vec<&char> = state.crates.stacks.iter().map(|s| s.last().unwrap()).into_iter().collect();
    let b: String = chars.into_iter().collect();

    (a, b)
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
        assert_eq!(a, "SVFDLGLWV");
    }

    #[test]
    fn part_b() {
        let (_, b) = solve();
        assert_eq!(b, "DCVTCVPCL");
    }
}
