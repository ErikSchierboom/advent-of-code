import helpers, std/[algorithm, math, sequtils, sugar]

func median(xs: seq[int]): int =
  let xs = xs.sorted()
  let middle = xs.len div 2
  result = if xs.len mod 2 == 1: xs[middle] else: (xs[middle - 1] + xs[middle]) div 2

func part1(xs: seq[int]): int =
  let median = xs.median()

  for x in xs:
    result.inc abs(x - median)

func summation(upTo: int): int = (1..upTo).toSeq.sum

func part2(xs: seq[int]): int =
  result = (0 ..< xs.max).mapIt(xs.map((x: int) => abs(it - x).summation).sum).min()

proc solveDay7*: IntSolution =
  var xs = readInputString(day = 7).splitToInts().toSeq
  result.part1 = part1(xs)
  result.part2 = part2(xs)

when isMainModule:
  echo solveDay7()
