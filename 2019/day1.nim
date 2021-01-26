import input, strformat

let masses = readInputAsInts(1)  

func fuel(mass: int): int = mass div 3 + 2

proc part1(): int =
  for mass in masses:
    result += fuel(mass)

proc part2(): int =
  for mass in masses:
    discard

echo &"day 1: {part1()}, {part2()}"