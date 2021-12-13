import helpers, std/[math, sequtils, sugar]

func summation(upTo: int): int = upTo * (upTo + 1) div 2

func lowestCost(xs: seq[int], calculate: (int, int) -> int): int =
  result = xs.deduplicate.map((goal) => xs.map((x) => calculate(x, goal)).sum).min

proc solveDay07*: IntSolution =
  var xs = readInputString(day = 7).splitToInts().toSeq
  result.part1 = lowestCost(xs, (x, goal) => abs(x - goal))
  result.part2 = lowestCost(xs, (x, goal) => abs(x - goal).summation)

when isMainModule:
  echo solveDay07()
