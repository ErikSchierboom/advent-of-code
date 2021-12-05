import helpers, std/[strscans, sequtils, tables]

proc toGrid(lines: seq[tuple[start, stop: Point]]): CountTable[Point] =
  for (start, stop) in lines:
    if start.x == stop.x or start.y == stop.y:
      for x in min(start.x, stop.x) .. max(start.x, stop.x):
        for y in min(start.y, stop.y) .. max(start.y, stop.y):
          result.inc (x: x, y: y)

proc part1(lines: seq[tuple[start, stop: Point]]): int =
  result = lines.toGrid.values.countIt(it > 1)

iterator readInputLines(): tuple[start, stop: Point] =
  for (_, x1, y1, x2, y2) in readInputScans(day = Day(5), pattern = "$i,$i -> $i,$i"):
    yield (start: (x: x1, y: y1), stop: (x: x2, y: y2))

proc solveDay5*: IntSolution =
  let lines = readInputLines().toSeq()

  result.part1 = part1(lines)

when isMainModule:
  echo solveDay5()
