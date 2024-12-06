use std::collections::HashSet;
use std::ops::Deref;
use itertools::Itertools;
use aoc::{Direction, Position};

#[derive(Clone, PartialEq, Eq)]
struct Guard {
    pos: Position,
    dir: Direction,
    visited: HashSet<(Position,Direction)>
}

struct Maze {
    width: usize,
    height: usize,
    obstacles: HashSet<Position>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum WalkResult {
    Bump,
    Exit,
    Walk,
    Loop
}

impl Guard {
    fn will_exit(&self, maze: &Maze) -> bool {
        match self.dir {
            Direction::North => self.pos.y == 0,
            Direction::East => self.pos.x == maze.width - 1,
            Direction::South => self.pos.y == maze.height - 1,
            Direction::West => self.pos.x == 0
        }
    }

    fn will_bump(&self, maze: &Maze) -> bool {
        let next = self.pos.advance(&self.dir);
        maze.obstacles.contains(&next)
    }

    fn turn_right(&mut self) {
        self.dir = self.dir.right()
    }

    fn walk(&mut self) {
        self.pos = self.pos.advance(&self.dir);
        self.visited.insert((self.pos, self.dir));
    }

    fn peek_walk(&mut self, maze: &Maze) -> WalkResult {
        if self.will_exit(maze) {
            WalkResult::Exit
        } else if self.will_bump(maze) {
            WalkResult::Bump
        } else {
            WalkResult::Walk
        }
    }

    fn walk_until(&mut self, maze: &Maze, stop_when: WalkResult) {
        loop {
            let walk_result = self.peek_walk(&maze);
            if walk_result == stop_when {
                break
            }

            match walk_result {
                WalkResult::Bump => self.turn_right(),
                WalkResult::Walk => self.walk(),
                _ => break
            }
        }
    }
}

fn part_1(guard: &Guard, maze: &Maze) -> usize {
    let mut guard = guard.clone();
    guard.walk_until(&maze, WalkResult::Exit);
    guard.visited.iter().map(|(pos, _)| *pos).unique().count()
}

fn part_2(guard: &Guard, maze: &Maze) -> usize {
    let mut guard = guard.clone();
    guard.walk_until(&maze, WalkResult::Exit);
    guard.visited.iter().map(|(pos, _)| *pos).unique().count()
}

fn parse_guard(lines: &Vec<&str>) -> Guard {
    lines.iter()
        .enumerate()
        .find_map(|(y, &cells)| {
            cells.char_indices().find_map(
                |(x, c)| {
                    match c {
                        '^' => Some(Guard { pos: Position { x, y }, dir: Direction::North, visited: HashSet::from([(Position { x, y }, Direction::North)]) }),
                        _ => None
                    }
                }
            )
        }).unwrap()
}

fn parse_maze(lines: &Vec<&str>) -> Maze {
    let height = lines.len();
    let width = lines.first().unwrap().len();

    let obstacles: HashSet<Position> =
        lines.iter()
            .enumerate()
            .flat_map(|(y, &cells)| {
                cells.char_indices().filter_map(
                    move |(x, c)| {
                        match c {
                            '#' => Some(Position { x, y }),
                            _ => None
                        }
                    }
                )
            }).collect();

    Maze { width, height, obstacles }
}

fn parse(input: &str) -> (Guard, Maze) {
    let lines: Vec<&str> = input.lines().collect();
    (parse_guard(&lines), parse_maze(&lines))
}

fn main() {
    let (guard, maze) = parse(&aoc::read_input(6));
    println!("part A: {:0}", part_1(&guard, &maze));
    println!("part B: {:0}", part_2(&guard, &maze));
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str =
        "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...";

    #[test]
    fn part_1_example() {
        let (guard, maze) = parse(INPUT);
        assert_eq!(part_1(&guard, &maze), 41);
    }

    #[test]
    fn part_2_example() {
        let (guard, maze) = parse(INPUT);
        assert_eq!(part_2(&guard, &maze), 6);
    }
}
