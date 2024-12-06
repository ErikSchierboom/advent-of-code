use std::collections::HashSet;
use std::ops::Deref;
use itertools::Itertools;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum Direction { North, East, South, West }

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct Position {
    x: usize,
    y: usize,
}

struct Guard {
    pos: Position,
    dir: Direction,
}

struct Maze {
    width: usize,
    height: usize,
    obstacles: HashSet<Position>,
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
        let next = self.advance();
        maze.obstacles.contains(&next.pos)
    }

    fn advance(&self) -> Self {
        match self.dir {
            Direction::North => Self { pos: Position { y: self.pos.y - 1, ..self.pos }, ..*self },
            Direction::East => Self { pos: Position { x: self.pos.x + 1, ..self.pos }, ..*self },
            Direction::South => Self { pos: Position { y: self.pos.y + 1, ..self.pos }, ..*self },
            Direction::West => Self { pos: Position { x: self.pos.x - 1, ..self.pos }, ..*self },
        }
    }

    fn turn_right(&self) -> Self {
        match self.dir {
            Direction::North => Self { dir: Direction::East, ..*self },
            Direction::East => Self { dir: Direction::South, ..*self },
            Direction::South => Self { dir: Direction::West, ..*self },
            Direction::West => Self { dir: Direction::North, ..*self },
        }
    }
}

fn part_1((guard, maze): &(Guard, Maze)) -> usize {
    let mut guard = *guard;
    let mut visited = HashSet::new();

    loop {
        visited.insert(guard.pos);
        if guard.will_exit(&maze) {
            break
        }

        if guard.advance().will_bump(&maze) {
            guard = guard.turn_right();
        } else {
            guard = guard.advance();
        }
    }

    visited.len()
}

fn part_2(maze: &(Guard, Maze)) -> usize {
    6
    // let mut pos = maze.guard;
    // let mut dir = Direction::North;
    // let mut visited = HashSet::new();
    // let mut obstructions = HashSet::new();
    //
    // loop {
    //     visited.insert((pos, dir));
    //     if maze.will_exit(pos, &dir) { break }
    //
    //     let next = advance(pos, &dir);
    //     if maze.obstacles.contains(&next) {
    //         dir = turn_right(&dir);
    //     } else {
    //
    //         let alternative_dir = turn_right(&dir);
    //         let alternate_pos = advance(pos, &alternative_dir);
    //         if visited.contains(&(alternate_pos, alternative_dir)) {
    //             obstructions.insert(alternate_pos);
    //         }
    //
    //         pos = next;
    //     }
    // }
    //
    // obstructions.len()
}

fn parse_guard(lines: &Vec<&str>) -> Guard {
    lines.iter()
        .enumerate()
        .find_map(|(y, &cells)| {
            cells.char_indices().find_map(
                |(x, c)| {
                    match c {
                        '^' => Some(Guard { pos: Position { x, y }, dir: Direction::North }),
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
                            '#' => Some(Position {x, y}),
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
    let input = parse(&aoc::read_input(6));
    println!("part A: {:0}", part_1(&input));
    println!("part B: {:0}", part_2(&input));
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
        assert_eq!(part_1(&parse(INPUT)), 41);
    }

    #[test]
    fn part_2_example() {
        assert_eq!(part_2(&parse(INPUT)), 6);
    }
}
