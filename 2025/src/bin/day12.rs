use aoc_2025::utils::read_input;

const DAY: u8 = 12;


fn main() {
    let input = read_input(DAY);
    println!("Part 1: {}", part_1(&input));
}

fn part_1(input: &str) -> usize {
    let (shapes, regions) = parse(input);

    regions.iter()
        .filter(|region|
            region.shape_counts.iter()
                .zip(&shapes)
                .map(|(shape_count, shape)| shape_count * shape.size)
                .sum::<u16>() <= region.area)
        .count()
}

#[derive(Debug)]
struct Shape{
    size: u16
}

#[derive(Debug)]
struct Region {
    area: u16,
    shape_counts: Vec<u16>
}

impl From<&&str> for Shape {
    fn from(value: &&str) -> Self {
        let count = value.as_bytes().iter().filter(|&b| b == &b'#').count() as u16;
        Shape { size: count }
    }
}

impl From<&str> for Region {
    fn from(value: &str) -> Self {
        let (area, shape_counts) = value.split_once(": ").unwrap();
        let (width, height) = area.split_once('x').unwrap();
        let area = width.parse::<u16>().unwrap() * height.parse::<u16>().unwrap();
        let shape_counts = shape_counts.split_whitespace().map(|shape_count| shape_count.parse().unwrap()).collect();

        Region { area, shape_counts }
    }
}

fn parse(input: &str) -> (Vec<Shape>, Vec<Region>) {
    let blocks: Vec<&str> = input.split("\n\n").collect();
    let (regions, shapes) = blocks.split_last().unwrap();
    let regions: Vec<Region> = regions.split('\n').map(Region::from).collect();
    let shapes = shapes.iter().map(Shape::from).collect();

    (shapes, regions)
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "0:\n\
                          ###\n\
                          ##.\n\
                          ##.\n\
                          \n\
                          1:\n\
                          ###\n\
                          ##.\n\
                          .##\n\
                          \n\
                          2:\n\
                          .##\n\
                          ###\n\
                          ##.\n\
                          \n\
                          3:\n\
                          ##.\n\
                          ###\n\
                          ##.\n\
                          \n\
                          4:\n\
                          ###\n\
                          #..\n\
                          ###\n\
                          \n\
                          5:\n\
                          ###\n\
                          .#.\n\
                          ###\n\
                          \n\
                          4x4: 0 0 0 0 2 0\n\
                          12x5: 1 0 1 0 2 2\n\
                          12x5: 1 0 1 0 3 2";

    #[test]
    pub fn solve_part_1_example() {
        assert_eq!(part_1(SAMPLE), 2);
    }

    #[test]
    pub fn solve_part_1_input() {
        assert_eq!(part_1(&read_input(DAY)), 555);
    }
}
