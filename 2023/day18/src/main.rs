use std::fs;
use std::str::FromStr;

enum Direction {
    Right,
    Down,
    Left,
    Up,
}

struct Dig {
    direction: Direction,
    meters: i64
}

#[derive(Clone)]
struct Point {
    x: i64,
    y: i64
}

impl Dig {
    fn from_str_part_a(s: &str) -> Result<Self, ()> {
        let parts: Vec<&str> = s.split(' ').collect();
        Ok(Dig {
            direction: parts[0].parse().unwrap(),
            meters: parts[1].parse().unwrap()
        })
    }

    fn from_str_part_b(s: &str) -> Result<Self, ()> {
        let parts: Vec<&str> = s.split(' ').collect();
        Ok(Dig {
            direction: parts[2][7..8].parse().unwrap(),
            meters: i64::from_str_radix(&parts[2][2..7], 16).unwrap()
        })
    }
}

impl FromStr for Direction {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        return match s {
            "R" | "0" => Ok(Direction::Right),
            "D" | "1" => Ok(Direction::Down),
            "L" | "2" => Ok(Direction::Left),
            "U" | "3" => Ok(Direction::Up),
            _ => Err(())
        }
    }
}

fn area(polygon: &[Point]) -> i64 {
    let mut result: i64 = 0;

    for i in 0..polygon.len() {
        let j = (i + 1) % polygon.len();
        result += polygon[i].x * polygon[j].y;
        result -= polygon[j].x * polygon[i].y;
    }

    return result / 2
}

fn parse_digs<F>(parse_fn: F) -> Vec<Dig> where F: Fn(&str) -> Result<Dig, ()> {
    fs::read_to_string("input.txt").expect("Can't read input file")
        .lines()
        .map(|line| parse_fn(line).unwrap())
        .collect::<Vec<Dig>>()
}

fn create_outline(digs: &Vec<Dig>) -> Vec<Point> {
    let initial_point = Point { x: 0, y: 0 };
    digs.iter().scan(initial_point, |last_point, dig| {
        let next_point = match dig.direction {
            Direction::Up => Point { x: last_point.x, y: last_point.y - dig.meters },
            Direction::Right => Point { x: last_point.x + dig.meters, y: last_point.y },
            Direction::Down => Point { x: last_point.x, y: last_point.y + dig.meters },
            Direction::Left => Point { x: last_point.x - dig.meters, y: last_point.y },
        };

        *last_point = next_point.clone();
        Some(next_point)
    }).collect()
}

fn num_cubic_meters<F>(parse_fn: F) -> i64 where F: Fn(&str) -> Result<Dig, ()>{
    let digs = parse_digs(parse_fn);
    let outline = create_outline(&digs);
    let num_outer_points = digs.iter().map(|dig| dig.meters).sum::<i64>();
    let num_inner_points = area(outline.as_slice()) - num_outer_points / 2 + 1;
    num_outer_points + num_inner_points
}

fn main() {
    println!("part a: {}", num_cubic_meters(Dig::from_str_part_a));
    println!("part b: {}", num_cubic_meters(Dig::from_str_part_b));
}
