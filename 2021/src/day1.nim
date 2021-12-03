import helpers

proc solveDay1*: IntSolution =
  let depths = readInputIntSeq("input/day1.txt")

  for i in 0 .. depths.high:
    if i < depths.high and depths[i + 1] > depths[i]:
      inc result.part1
    if i < depths.high - 2 and depths[i + 3] > depths[i]:
      inc result.part2

when isMainModule:
  echo solveDay1()
