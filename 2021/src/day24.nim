import helpers, std/[deques, math, sequtils, strutils]

type Instructions = tuple[p1, p2, p3: int]

proc readInstructions: seq[Instructions] =
  for instructionBlock in readInputStrings(day = 24).toSeq.distribute(14):
    let instructions = instructionBlock.mapIt(it.splitWhitespace)
    result.add (p1: instructions[4][^1].parseInt, p2: instructions[5][^1].parseInt, p3: instructions[15][^1].parseInt)

func findMinMax(instructions: seq[Instructions]): array[14, tuple[min, max: int]] =
  var z: Deque[int]
  for i, instructionBlock in instructions:
    if instructionBlock.p1 == 1:
      z.addLast i
    else:
      let j = z.popLast
      let w = instructionBlock.p2 + instructions[j].p3
      let s = [max(-1 * w, 0), max(w, 0)]
      result[i] = (9 - s[0], 1 + s[1])
      result[j] = (9 - s[1], 1 + s[0])

proc solveDay24*: Solution[int64, int64] =
  let minMax = readInstructions().findMinMax()
  result.part1 = minMax.foldl(a * 10 + b.min, 0)
  result.part2 = minMax.foldl(a * 10 + b.max, 0)

when isMainModule:
  echo solveDay24()
