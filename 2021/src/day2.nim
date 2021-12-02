import helpers, std/strscans

type
  Submarine = object
    x: int
    y: int
    aim: int

proc solve*: IntSolution =
  var
    sub1: Submarine
    sub2: Submarine
    direction: string
    distance: int

  for line in "input/day2.txt".lines:
    if line.scanf("$w $i", direction, distance):
      case direction:
        of "forward":
          sub1.x += distance
          sub2.x += distance
          sub2.y += sub2.aim * distance
        of "up":
          sub1.y -= distance
          sub2.aim -= distance
        of "down":
          sub1.y += distance
          sub2.aim += distance

  result.part1 = sub1.x * sub1.y
  result.part2 = sub2.x * sub2.y

when isMainModule:
  echo solve()
