import helpers, std/sequtils

func `[]`(grid: seq[seq[int]], point: Point): int = grid[point.y][point.x]

iterator points(grid: seq[seq[int]]): Point =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      yield (x: x, y: y)

iterator neighbors(grid: seq[seq[int]], point: Point): Point =
  if point.x > grid[0].low:  yield (x: point.x - 1, y: point.y)
  if point.x < grid[0].high: yield (x: point.x + 1, y: point.y)
  if point.y > grid.low:     yield (x: point.x,     y: point.y - 1)
  if point.y < grid.high:    yield (x: point.x,     y: point.y + 1)

func lowPoint(grid: seq[seq[int]], point: Point): bool =
  grid.neighbors(point).toSeq.allIt(grid[point] < grid[it])

func part1(grid: seq[seq[int]]): int =
  for point in grid.points:
    if grid.lowPoint(point):
      result.inc grid[point] + 1

proc solveDay9*: IntSolution =
  let grid = readInputDigits(day = 9).toSeq
  result.part1 = part1(grid)
  # result.part2 = part2(entries)

when isMainModule:
  echo solveDay9()
