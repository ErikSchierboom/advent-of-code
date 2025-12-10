use aoc_2025::utils::read_input;
use std::collections::{HashSet, VecDeque};
use itertools::Itertools;
use z3::ast::{Ast, Int};
use z3::{Optimize, Solver};

const DAY: u8 = 10;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    solve(input, fewest_button_presses)
}

fn part_2(input: &str) -> usize {
    solve(input, fewest_voltage_increments)
}

fn solve<F: Fn(Machine) -> usize>(input: &str, solve_for_machine: F) -> usize {
    input.lines()
        .map(Machine::from)
        .map(solve_for_machine)
        .sum()
}

fn fewest_button_presses(machine: Machine) -> usize {
    let mut queue = VecDeque::new();
    let mut visited = HashSet::new();
    let initial = (0u16, 0usize);

    queue.push_back(initial);
    visited.insert(initial);

    while let Some((state, presses)) = queue.pop_front() {
        if state == machine.indicator_lights_goal {
            return presses;
        }

        for &button in &machine.indicator_lights_button_masks {
            let next = (state ^ button, presses + 1);

            if visited.insert(next) {
                queue.push_back(next)
            }
        }
    }

    panic!()
}

fn fewest_voltage_increments(machine: Machine) -> usize {
    let opt = Optimize::new();

    let button_presses: Vec<Int> =  (0..machine.joltages_button_increments.len()).map(|i| Int::new_const(format!("button-{i}"))).collect();
    for button_press in &button_presses {
        opt.assert(&button_press.ge(&Int::from_i64(0)));
    }

    for j in 0..machine.joltages_goal.len() {
        let terms: Vec<Int> = machine.joltages_button_increments.iter()
            .zip(&button_presses)
            .map(|(button_increments, button_press)| Int::mul(&[button_press, &Int::from_i64(button_increments[j] as i64)]))
            .collect();

        opt.assert(&Int::add(&terms).eq(&Int::from_i64(machine.joltages_goal[j] as i64)));
    }

    let total_presses = Int::add(&button_presses.iter().collect::<Vec<_>>());
    opt.minimize(&total_presses);
    opt.check(&vec![]);

    let model = opt.get_model().unwrap();
    model.eval(&total_presses, true).unwrap().as_u64().unwrap() as usize
}

struct Machine {
    indicator_lights_button_masks: Vec<u16>,
    indicator_lights_goal: u16,
    joltages_button_increments: Vec<Vec<u16>>,
    joltages_goal: Vec<u16>
}

impl From<&str> for Machine {
    fn from(s: &str) -> Self {
        let parts: Vec<&str> = s.split_whitespace().collect();

        let indicator_lights_goal = parts[0][1..parts[0].len() - 1]
            .bytes()
            .rev()
            .fold(0, |acc, byte| (acc << 1) + u16::from(byte == b'#'));

        let indicator_lights_button_masks: Vec<u16> = parts[1..parts.len() - 1]
            .iter()
            .map(|mask| {
                mask[1..mask.len()-1]
                    .split(',')
                    .fold(0, |acc, index| {
                        let i = index.as_bytes()[0] - b'0';
                        acc | (1 << i)
                    })
        }).collect();

        let joltages_goal = parts[parts.len() - 1][1..parts[parts.len() - 1].len() - 1]
            .split(',')
            .map(|joltage| joltage.parse().unwrap())
            .collect();

        let joltages_button_increments = parts[1..parts.len() - 1]
            .iter()
            .map(|mask| {
                let indices: Vec<u16> = mask[1..mask.len()-1].split(',').map(|m| m.parse().unwrap()).collect();
                (0..parts[0].len() - 2).map(|i| u16::from(indices.contains(&(i as u16)))).collect()
            }).collect();

        Machine { indicator_lights_goal, joltages_goal, indicator_lights_button_masks, joltages_button_increments }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}\n\
                          [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}\n\
                          [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 7);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 530);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 33);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 20172);
    }
}
