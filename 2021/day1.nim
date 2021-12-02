import aoc, std/math

proc solve(input: string): IntSolution =
  let depths = readInputIntSeq(input)

  for i in 0 .. depths.high:
    if i < depths.high and depths[i + 1] > depths[i]:
      inc result.part1
    if i < depths.high-2 and sum(depths[i + 1 .. i + 3]) > sum(depths[i .. i + 2]):
      inc result.part2

echo solve("input/day1.txt")
