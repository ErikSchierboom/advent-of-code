use std::collections::HashSet;
use std::ops::BitAnd;

const PRIORITIES: &'static str = ".abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

fn priority(item_type: &char) -> usize {
    PRIORITIES.find(*item_type).unwrap()
}

fn rucksack_priority(rucksack: &&str) -> usize {
    let (first_compartment, second_compartment) = rucksack.split_at(rucksack.len() / 2);
    let first_item_types = first_compartment.chars().collect::<HashSet<char>>();
    let second_item_types = second_compartment.chars().collect::<HashSet<char>>();

    priority(first_item_types.bitand(&second_item_types).iter().next().unwrap())
}

fn group_priority(rucksacks: &[&str]) -> usize {
    let first_item_types = rucksacks.first().unwrap().chars().collect::<HashSet<char>>();
    let second_item_types = rucksacks.iter().nth(1).unwrap().chars().collect::<HashSet<char>>();
    let third_item_types = rucksacks.last().unwrap().chars().collect::<HashSet<char>>();

    priority(first_item_types.bitand(&second_item_types).bitand(&third_item_types).iter().next().unwrap())
}

fn solve() -> (usize, usize) {
    include_str!("../input.txt")
        .lines()
        .collect::<Vec<&str>>()
        .chunks(3)
        .fold((0, 0), |(a, b), rucksacks|
            (a + rucksacks.iter().map(rucksack_priority).sum::<usize>(), b + group_priority(rucksacks)))
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
        assert_eq!(a, 7737);
    }

    #[test]
    fn part_b() {
        let (_, b) = solve();
        assert_eq!(b, 2697);
    }
}
