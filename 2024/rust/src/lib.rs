use std::fs;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Direction { North, East, South, West }

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Position {
    pub x: usize,
    pub y: usize,
}


impl Direction {
    pub fn right(&self) -> Self {
        match self {
            Direction::North => Direction::East,
            Direction::East => Direction::South,
            Direction::South => Direction::West,
            Direction::West => Direction::North,
        }
    }
}

impl Position {
    pub fn new(x: usize, y: usize) -> Self {
        Position { x, y }
    }

    pub fn advance(&self, dir: &Direction) -> Position {
        match dir {
            Direction::North => Position { y: self.y - 1, ..*self },
            Direction::East => Position { x: self.x + 1, ..*self },
            Direction::South => Position { y: self.y + 1, ..*self },
            Direction::West => Position { x: self.x - 1, ..*self },
        }
    }
}

pub fn read_input(day: u32) -> String {
    let path = format!("input/day{:02}.txt", day);
    fs::read_to_string(path).unwrap()
}


