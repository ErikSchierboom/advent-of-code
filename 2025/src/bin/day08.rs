use aoc_2025::utils::read_input;
use itertools::Itertools;

const DAY: u8 = 8;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input, 1000));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str, num_closest_junction_boxes: usize) -> usize {
    let junction_boxes = parse_junction_boxes(input);
    let closest_junction_boxes = find_closest_junction_boxes(&junction_boxes);
    let mut junction_circuits = junction_boxes.iter().map(|&junction_box| vec![junction_box]).collect_vec();

    for closest_junction in closest_junction_boxes.into_iter().take(num_closest_junction_boxes) {
        merge_closest_junctions(&mut junction_circuits, closest_junction)
    }

    junction_circuits.iter().map(Vec::len).sorted().rev().take(3).product()
}

fn part_2(input: &str) -> i64 {
    let junction_boxes = parse_junction_boxes(input);
    let closest_junction_boxes = find_closest_junction_boxes(&junction_boxes);
    let mut junction_circuits = junction_boxes.iter().map(|&junction_box| vec![junction_box]).collect_vec();

    for closest_junction in closest_junction_boxes.into_iter() {
        merge_closest_junctions(&mut junction_circuits, closest_junction);

        if junction_circuits.len() == 1 {
            return closest_junction.0.0 * closest_junction.1.0;
        }
    }

    panic!("We should not get here")
}
fn parse_junction_boxes(input: &str) -> Vec<Coord> {
    input.lines().map(Coord::from).collect()
}

fn find_closest_junction_boxes(junction_boxes: &Vec<Coord>) -> Vec<(&Coord, &Coord)> {
    junction_boxes.iter()
        .combinations(2)
        .map(|comb| (comb[0], comb[1]))
        .sorted_by_key(|(p, q)| p.distance_to(q))
        .collect()
}

fn merge_closest_junctions(junction_circuits: &mut Vec<Vec<Coord>>, closest_junction: (&Coord, &Coord))  {
    let first_pos = junction_circuits.iter().position(|circuit| circuit.contains(&closest_junction.0)).unwrap();
    let second_pos = junction_circuits.iter().position(|circuit| circuit.contains(&closest_junction.1)).unwrap();

    if first_pos == second_pos {
        return;
    }

    let merged_circuit = junction_circuits[first_pos]
        .iter()
        .merge(junction_circuits[second_pos].iter())
        .cloned()
        .collect();

    let (hi, lo) = if first_pos > second_pos { (first_pos, second_pos) } else { (second_pos, first_pos) };
    junction_circuits.remove(hi);
    junction_circuits.remove(lo);

    junction_circuits.push(merged_circuit);
}

#[derive(Clone, Copy, PartialEq, PartialOrd)]
struct Coord(i64, i64, i64);

impl Coord {
    fn distance_to(&self, other: &Self) -> i64 {
        (self.0- other.0).pow(2) + (self.1- other.1).pow(2) + (self.2- other.2).pow(2)
    }
}

impl From<&str> for Coord {
    fn from(s: &str) -> Self {
        let mut parts = s.split(',').map(|part| part.parse().unwrap());
        Coord(parts.next().unwrap(), parts.next().unwrap(), parts.next().unwrap())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "162,817,812\n\
                          57,618,57\n\
                          906,360,560\n\
                          592,479,940\n\
                          352,342,300\n\
                          466,668,158\n\
                          542,29,236\n\
                          431,825,988\n\
                          739,650,466\n\
                          52,470,668\n\
                          216,146,977\n\
                          819,987,18\n\
                          117,168,530\n\
                          805,96,715\n\
                          346,949,466\n\
                          970,615,88\n\
                          941,993,340\n\
                          862,61,35\n\
                          984,92,344\n\
                          425,690,689";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE, 10), 40);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY), 1000), 123420);
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
