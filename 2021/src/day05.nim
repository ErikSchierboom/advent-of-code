import helpers, std/[strscans, sequtils, tables]

iterator points(line: Line, diagonal: bool): Point =
  let dx = cmp(line.b.x, line.a.x)
  let dy = cmp(line.b.y, line.a.y)

  var point = line.a
  while true:
    if diagonal or dy == 0 or dx == 0: yield point
    if point == line.b: break
    point.x += dx
    point.y += dy

proc numOverlappingPoints(lines: seq[Line], diagonal: bool): int =
  var grid = initCountTable[Point]()

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
  result.part1 = lines.numOverlappingPoints(diagonal = false)
  result.part2 = lines.numOverlappingPoints(diagonal = true)

when isMainModule:
  echo solveDay5()
