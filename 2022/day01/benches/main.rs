#[macro_use]
extern crate bencher;

use bencher::Bencher;
use itertools::Itertools;

fn itertools(bench: &mut Bencher) {
    bench.iter(|| {
        let top_elves = include_str!("../input.txt")
            .split("\n\n")
            .map(|foods| {
                foods
                    .lines()
                    .map(|food| food.parse::<i32>().unwrap())
                    .sum::<i32>()
            })
            .sorted()
            .rev()
            .take(3)
            .collect_vec();

        (top_elves[0], top_elves[0..2].into_iter().sum::<i32>())
    })
}

fn stdlib(bench: &mut Bencher) {
    bench.iter(|| {
        let mut top_elves = include_str!("../input.txt")
            .split("\n\n")
            .map(|foods| {
                foods
                    .lines()
                    .map(|food| food.parse::<i32>().unwrap())
                    .sum::<i32>()
            })
            .collect::<Vec<i32>>();

        top_elves.sort();
        top_elves.reverse();

        (top_elves[0], top_elves[..].into_iter().sum::<i32>())
    })
}

benchmark_group!(benches, itertools, stdlib);
benchmark_main!(benches);
