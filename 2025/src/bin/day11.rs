use aoc_2025::utils::read_input;
use std::collections::HashMap;

const DAY: u8 = 11;

const FLAG_VISITED_DAC: u8 = 1;
const FLAG_VISITED_FFT: u8 = 2;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> usize {
    solve(input, "you", &|_| true)
}

fn part_2(input: &str) -> usize {
    solve(input,"svr", &|flags| flags == FLAG_VISITED_DAC | FLAG_VISITED_FFT)
}

fn solve<F: Fn(u8) -> bool>(input: &str, start_node: &str, is_valid_end_of_path: &F) -> usize {
    let device_outputs = parse_device_outputs(input);

    let mut memo: HashMap<(&str, u8), usize> = HashMap::new();
    number_of_paths(start_node, &device_outputs, &mut memo, 0, is_valid_end_of_path)
}

fn number_of_paths<'a, F: Fn(u8) -> bool>(
    node: &'a str,
    graph: &HashMap<&'a str, Vec<&'a str>>,
    memo: &mut HashMap<(&'a str, u8), usize>,
    mut path_flags: u8,
    is_valid_end_of_path: &F
) -> usize {
    if node == "out" {
        return usize::from(is_valid_end_of_path(path_flags))
    }

    if node == "dac" {
        path_flags |= FLAG_VISITED_DAC;
    } else if node == "fft" {
        path_flags |= FLAG_VISITED_FFT;
    }

    if let Some(&cached) = memo.get(&(node, path_flags)) {
        return cached;
    }

    let total = graph[node].iter().map(|n| number_of_paths(n, graph, memo, path_flags, is_valid_end_of_path)).sum();
    memo.insert((node, path_flags), total);
    total
}

fn parse_device_outputs(input: &str) -> HashMap<&str, Vec<&str>> {
    input
        .lines()
        .map(|line| {
            let (device, outputs) = line.split_once(": ").unwrap();
            (device, outputs.split_whitespace().collect())
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE_PART_1: &str = "aaa: you hhh\n\
                                 you: bbb ccc\n\
                                 bbb: ddd eee\n\
                                 ccc: ddd eee fff\n\
                                 ddd: ggg\n\
                                 eee: out\n\
                                 fff: out\n\
                                 ggg: out\n\
                                 hhh: ccc fff iii\n\
                                 iii: out";

    const SAMPLE_PART_2: &str = "svr: aaa bbb\n\
                                 aaa: fft\n\
                                 fft: ccc\n\
                                 bbb: tty\n\
                                 tty: ccc\n\
                                 ccc: ddd eee\n\
                                 ddd: hub\n\
                                 hub: fff\n\
                                 eee: dac\n\
                                 dac: fff\n\
                                 fff: ggg hhh\n\
                                 ggg: out\n\
                                 hhh: out";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE_PART_1), 5);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 497);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE_PART_2), 2);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 358564784931864);
    }
}
