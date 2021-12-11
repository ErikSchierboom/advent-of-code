import helpers, std/[sequtils, sets]

iterator points(grid: seq[seq[int]]): Point =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      yield (x: x, y: y)

iterator neighbors(grid: seq[seq[int]], point: Point): Point =
  for (dx, dy) in [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
    let neighbor = (x: point.x + dx, y: point.y + dy)
    if neighbor.x in grid[0].low .. grid[0].high and
       neighbor.y in grid.low .. grid.high:
      yield neighbor

func step(grid: var seq[seq[int]]): int =
  var flashed, unflashed: HashSet[Point]

  for point in grid.points:
    inc grid[point.y][point.x]
    if grid[point.y][point.x] == 10: unflashed.incl point

  while unflashed.len > 0:
    let flashPoint = unflashed.pop
    flashed.incl flashPoint
    
    for neighbor in grid.neighbors(flashPoint):
      inc grid[neighbor.y][neighbor.x]
      if grid[neighbor.y][neighbor.x] == 10: unflashed.incl neighbor

  for flashPoint in flashed:
    grid[flashPoint.y][flashPoint.x] = 0

  result = flashed.len

proc solveDay11*: IntSolution =
  var grid = readInputDigits(day = 11).toSeq
  let total = grid.len * grid[0].len

  while true:
    let flashed = grid.step
    inc result.part2
    if result.part2 < 100: inc result.part1, flashed
    if flashed == total: break

when isMainModule:
  echo solveDay11()
