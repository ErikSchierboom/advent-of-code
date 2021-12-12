import helpers, std/[strscans, sequtils, tables]

iterator points(line: Line, diagonal: bool): Point =
  let dx = cmp(line.b.x, line.a.x)
  let dy = cmp(line.b.y, line.a.y)

  if (diagonal and not dx == 0 and not dy == 0) or
     (not diagonal and (dx == 0 or dy == 0)):
    var point = line.a
    while true:
      yield point
      if point == line.b: break
      point.x += dx
      point.y += dy

proc numOverlappingPoints(grid: var CountTable[Point], lines: seq[Line], diagonal: bool): int =
  for line in lines:
    for point in line.points(diagonal):
      if grid[point] <= 2:
        grid.inc point
      if grid[point] == 2:
        inc result

iterator readInputLines(): Line =
  for (_, x1, y1, x2, y2) in readInputScans(day = 5, pattern = "$i,$i -> $i,$i"):
    yield (a: (x: x1, y: y1), b: (x: x2, y: y2))

proc solveDay5*: IntSolution =
  let lines = readInputLines().toSeq()
  var grid = initCountTable[Point](100_000)
  result.part1 = grid.numOverlappingPoints(lines, diagonal = false)
  result.part2 = grid.numOverlappingPoints(lines, diagonal = true)

when isMainModule:
  echo solveDay5()
