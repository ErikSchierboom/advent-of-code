import helpers, std/[algorithm, deques, math, sequtils, strscans, strutils, strformat, tables]

type Block = tuple[p1, p2, p3: int]

proc readInstructions: seq[Block] =
  for instructionBlock in readInputStrings(day = 24).toSeq.distribute(14):
    let instructions = instructionBlock.mapIt(it.splitWhitespace)
    result.add (p1: instructions[4][^1].parseInt, p2: instructions[5][^1].parseInt, p3: instructions[15][^1].parseInt)

func findMinMax(instructions: seq[Block]): array[14, (int, int)] =
  var z = initDeque[int]()
  for i, segment in instructions:
    if segment.p1 == 1: z.addLast i else:
      let
        j = z.popLast
        w = segment.p2 + instructions[j].p3
        s = [max(-1 * w, 0), max(w, 0)]
      for k, q in [i, j]:
        result[q] = (9 - s[k], 1 + s[1 - k])

proc solveDay24*: Solution[int64, int64] =
  let minMax = readInstructions().findMinMax()
  result.part1 = minMax.foldl(a * 10 + b[0], 0)
  result.part2 = minMax.foldl(a * 10 + b[1], 0)

when isMainModule:
  echo solveDay24()
