use aoc_2025::utils::read_input;
use itertools::Itertools;
use std::iter;

const DAY: u8 = 9;

fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
    println!("Part 2: {}", part_2(&input));
}

fn part_1(input: &str) -> i64 {
    parse_tiles(input)
        .iter()
        .tuple_combinations()
        .map(|((x1, y1), (x2, y2))| ((x1 - x2).abs() + 1) * ((y1 - y2).abs() + 1))
        .max()
        .unwrap()
}

fn part_2(input: &str) -> i64 {
    let tiles = parse_tiles(input);
    let polygon = to_polygon(&tiles);

    tiles.iter()
        .map(|(x1, y1)| {
            tiles
                .iter()
                .sorted_by_key(|(x2, y2)| (x1 - x2).pow(2) + (y1 - y2).pow(2))
                .rev()
                .filter_map(|(x2, y2)| {
                    let (min_x, max_x) = if x1 < x2 { (x1, x2) } else { (x2, x1) };
                    let (min_y, max_y) = if y1 < y2 { (y1, y2) } else { (y2, y1) };
                    let corners = [(*min_x, *min_y), (*max_x, *min_y), (*max_x, *max_y), (*min_x, *max_y)];

                    if corners.iter().all(|corner| in_polygon(corner, &polygon)) &&
                        to_polygon(&corners).iter().all(|edge| !intersects_polygon(*edge, &polygon)) {
                        Some(((*x1 - x2).abs() + 1) * ((*y1 - y2).abs() + 1))
                    } else {
                        None
                    }
                })
                .next()
                .unwrap_or_default()
        })
        .max()
        .unwrap()
}

fn parse_tiles(input: &str) -> Vec<(i64, i64)> {
    input
        .lines()
        .map(|line| {
            let (x, y) = line.split_once(',').unwrap();
            (x.parse().unwrap(), y.parse().unwrap())
        })
        .collect()
}

fn to_polygon(points: &[(i64, i64)]) -> Vec<(&(i64, i64), &(i64, i64))> {
    points
        .iter()
        .chain(iter::once(points.first().unwrap()))
        .tuple_windows()
        .collect()
}

fn in_polygon(point: &(i64, i64), polygon: &[(&(i64, i64), &(i64, i64))]) -> bool {
    on_edge(point, polygon) || inside_polygon(point, polygon)
}

fn on_edge(point: &(i64, i64), polygon: &[(&(i64, i64), &(i64, i64))]) -> bool {
    polygon.iter().any(|line| on_line(point, line))
}

fn on_line((x, y): &(i64, i64), ((from_x, from_y), (to_x, to_y)): &(&(i64, i64), &(i64, i64))) -> bool {
    x >= from_x.min(to_x) && x <= from_x.max(to_x) && y == from_y ||
        y >= from_y.min(to_y) && y <= from_y.max(to_y) && x == from_x
}

fn inside_polygon((x, y): &(i64, i64), polygon: &[(&(i64, i64), &(i64, i64))]) -> bool {
    let mut intersections = 0;

    for line in polygon {
        let ((x1, y1), (x2, y2)) = line;
        if (y < y1) != (y < y2) && (*x < x1 + ((y - y1) / (y2 - y1)) * (x2 - x1)) {
            intersections += 1
        }
    }

    intersections % 2 == 1
}

fn intersects_polygon(((from_x, from_y), (to_x, to_y)): (&(i64, i64), &(i64, i64)), polygon: &[(&(i64, i64), &(i64, i64))]) -> bool {
    polygon.iter().any(|((poly_from_x, poly_from_y), (poly_to_x, poly_to_y))|
       from_y == to_y && poly_from_x == poly_to_x &&
            poly_from_y.min(poly_to_y) < from_y && from_y < poly_from_y.max(poly_to_y) &&
            from_x.min(to_x) < poly_from_x && poly_from_x < from_x.max(to_x) ||
       from_x == to_x && poly_from_y == poly_to_y &&
           poly_from_x.min(poly_to_x) < from_x && from_x < poly_from_x.max(poly_to_x) &&
           from_y.min(to_y) < poly_from_y && poly_from_y < from_y.max(to_y))
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "7,1\n\
                          11,1\n\
                          11,7\n\
                          9,7\n\
                          9,5\n\
                          2,5\n\
                          2,3\n\
                          7,3";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 50);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 4749838800);
    }

    #[test]
    pub fn solve_part_2_example() {
        assert_eq!(part_2(SAMPLE), 24);
    }

    #[test]
    pub fn solve_part_2_input() {
        assert_eq!(part_2(&read_input(DAY)), 1624057680);
    }

    #[test]
    pub fn in_polygon_with_point_within_polygon() {
        let polygon = test_polygon();

        assert!(in_polygon(&(8, 2), &polygon));
        assert!(in_polygon(&(10, 2), &polygon));
        assert!(in_polygon(&(3, 4), &polygon));
        assert!(in_polygon(&(10, 4), &polygon));
        assert!(in_polygon(&(10, 6), &polygon));
        assert!(!in_polygon(&(8, 0), &polygon));
        assert!(!in_polygon(&(10, 0), &polygon));
        assert!(!in_polygon(&(10, 8), &polygon));
        assert!(!in_polygon(&(3, 6), &polygon));
    }

    #[test]
    pub fn in_polygon_with_point_on_edge() {
        let polygon = test_polygon();

        assert!(in_polygon(&(7, 1), &polygon));
        assert!(in_polygon(&(11, 1), &polygon));
        assert!(in_polygon(&(11, 7), &polygon));
        assert!(in_polygon(&(8, 1), &polygon));
        assert!(in_polygon(&(10, 1), &polygon));
        assert!(in_polygon(&(11, 2), &polygon));
        assert!(in_polygon(&(11, 6), &polygon));
    }

    #[test]
    pub fn in_polygon_with_point_outside_polygon() {
        let polygon = test_polygon();

        assert!(!on_edge(&(11, 0), &polygon));
        assert!(!on_edge(&(11, 8), &polygon));
        assert!(!on_edge(&(6, 1), &polygon));
        assert!(!on_edge(&(12, 1), &polygon));
        assert!(!on_edge(&(11, 0), &polygon));
        assert!(!on_edge(&(11, 8), &polygon));
        assert!(!on_edge(&(6, 1), &polygon));
        assert!(!on_edge(&(12, 1), &polygon));
    }

    #[test]
    pub fn intersect_polygon_with_intersecting_line() {
        let polygon = test_polygon();

        assert!(intersects_polygon((&(9, 0), &(9, 2)), &polygon));
        assert!(intersects_polygon((&(9, 2), &(9, 0)), &polygon));

        assert!(intersects_polygon((&(9, 3), &(13, 3)), &polygon));
        assert!(intersects_polygon((&(13, 3), &(9, 3)), &polygon));
    }

    #[test]
    pub fn intersect_polygon_with_parallel_line() {
        let polygon = test_polygon();

        assert!(!intersects_polygon((&(0, 0), &(12, 0)), &polygon));
        assert!(!intersects_polygon((&(7, 1), &(11, 1)), &polygon));
        assert!(!intersects_polygon((&(7, 2), &(11, 2)), &polygon));
        assert!(!intersects_polygon((&(12, 2), &(12, 5)), &polygon));
        assert!(!intersects_polygon((&(7, 3), &(7, 1)), &polygon));
        assert!(!intersects_polygon((&(7, 3), &(7, 0)), &polygon));
    }

    fn test_polygon<'a>() -> Vec<(&'a (i64, i64), &'a (i64, i64))> {
        vec![
            (&(7, 1), &(11, 1)),
            (&(11, 1), &(11, 7)),
            (&(11, 7), &(9, 7)),
            (&(9, 7), &(9, 5)),
            (&(9, 5), &(2, 5)),
            (&(2, 5), &(2, 3)),
            (&(2, 3), &(7, 3)),
            (&(7, 3), &(7, 1)),
        ]
    }
}
