import helpers, std/strscans

proc solveDay2*: IntSolution =
  var sub: tuple[x, y, aim: int]

  for (success, command, distance) in readInputScans(day = 2, pattern = "$w $i"):
    if success:
      case command:
        of "forward":
          sub.x += distance
          sub.y += sub.aim * distance
        of "up":
          sub.aim -= distance
        of "down":
          sub.aim += distance

  result.part1 = sub.x * sub.aim
  result.part2 = sub.x * sub.y

when isMainModule:
  echo solveDay2()
