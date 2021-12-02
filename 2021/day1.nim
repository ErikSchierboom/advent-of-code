import aoc

proc solve(input: string): IntSolution =
  let depths = readInputIntSeq(input)

  for i in 0 .. depths.high:
    if i < depths.high and depths[i + 1] > depths[i]:
      inc result.part1
    if i < depths.high - 3 and depths[i + 3] > depths[i]:
      inc result.part2

echo solve("input/day1.txt")
