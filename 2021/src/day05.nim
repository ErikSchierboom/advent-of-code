import helpers, std/[strscans, sequtils, tables]

proc numOverlappingPoints(lines: seq[tuple[start, stop: Point]], diagonal: bool): int =
  var grid = initCountTable[Point]()

  for (start, stop) in lines:
    if start.x == stop.x:
      for y in min(start.y, stop.y) .. max(start.y, stop.y):
        grid.inc (x: start.x, y: y)
    elif start.y == stop.y:
      for x in min(start.x, stop.x) .. max(start.x, stop.x):
        grid.inc (x: x, y: start.y)
    elif diagonal:
      let dx = if start.x <= stop.x: 1 else: -1
      let dy = if start.y <= stop.y: 1 else: -1
      for d in 0 .. abs(stop.x - start.x):
        grid.inc (x: start.x + d * dx, y: start.y + d * dy)

  result = grid.values.countIt(it > 1)

iterator readInputLines(): tuple[start, stop: Point] =
  for (_, x1, y1, x2, y2) in readInputScans(day = Day(5), pattern = "$i,$i -> $i,$i"):
    yield (start: (x: x1, y: y1), stop: (x: x2, y: y2))

proc solveDay5*: IntSolution =
  let lines = readInputLines().toSeq()
  result.part1 = lines.numOverlappingPoints(diagonal = false)
  result.part2 = lines.numOverlappingPoints(diagonal = true)

when isMainModule:
  echo solveDay5()
