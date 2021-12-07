import helpers, std/[algorithm, sequtils]

func median(xs: seq[int]): int =
  let xs = xs.sorted()
  let middle = xs.len div 2
  result = if xs.len mod 2 == 1: xs[middle] else: (xs[middle - 1] + xs[middle]) div 2

func part1(xs: seq[int]): int =
  let median = xs.median()

  for x in xs:
    result.inc abs(x - median)

proc solveDay7*: IntSolution =
  var xs = readInputString(day = 7).splitToInts().toSeq
  result.part1 = part1(xs)

when isMainModule:
  echo solveDay7()
