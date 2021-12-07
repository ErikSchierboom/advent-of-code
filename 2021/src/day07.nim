import helpers, std/[math, sequtils, sugar]

func summation(upTo: int): int = upTo * (upTo + 1) div 2

func part1(xs: seq[int]): int =
  let median = xs.median()
  result = xs.mapIt(abs(it - median)).sum

func part2(xs: seq[int]): int =
  result = (0 ..< xs.max).mapIt(xs.map((x) => abs(it - x).summation).sum).min()

proc solveDay7*: IntSolution =
  var xs = readInputString(day = 7).splitToInts().toSeq
  result.part1 = part1(xs)
  result.part2 = part2(xs)

when isMainModule:
  echo solveDay7()
