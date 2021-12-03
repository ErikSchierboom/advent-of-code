import helpers, std/strscans

proc solveDay2*: IntSolution =
  var
    command: string
    x, y, aim, distance: int

  for line in readInputStringSeq("input/day2.txt"):
    if line.scanf("$w $i", command, distance):
      case command:
        of "forward":
          x += distance
          y += aim * distance
        of "up":
          aim -= distance
        of "down":
          aim += distance

  result.part1 = x * aim
  result.part2 = x * y

when isMainModule:
  echo solveDay2()
