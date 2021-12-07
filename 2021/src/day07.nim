import helpers, std/[math, sequtils, sugar]

func summation(upTo: int): int = upTo * (upTo + 1) div 2

func lowestCost(xs: seq[int], calculate: (int, int) -> int): int =
  result = xs.deduplicate.mapIt(xs.map((x) => calculate(x, it)).sum).min

proc solveDay7*: IntSolution =
  var xs = readInputString(day = 7).splitToInts().toSeq
  result.part1 = lowestCost(xs, (x, goal) => abs(goal - x))
  result.part2 = lowestCost(xs, (x, goal) => abs(goal - x).summation)

when isMainModule:
  echo solveDay7()
