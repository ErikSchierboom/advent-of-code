import aoc, std/strscans

proc solve(input: string): IntSolution =
  var
    point: Point
    direction: string
    distance: int

  for line in input.lines:
    if line.scanf("$w $i", direction, distance):
      case direction:
        of "forward":
          point.x = point.x + distance
        of "up":
          point.y = point.y - distance
        of "down":
          point.y = point.y + distance

  result.part1 = point.x * point.y

echo solve("input/day2.txt")
