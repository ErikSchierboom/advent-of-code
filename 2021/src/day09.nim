import helpers, std/[algorithm, math, sets, sequtils]

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

func isLowPoint(grid: seq[seq[int]], point: Point): bool =
  for neighbor in grid.neighbors(point):
    if grid[point] >= grid[neighbor]:
      return false

  result = true

func findLowPoints(grid: seq[seq[int]]): seq[Point] =
  for point in grid.points:
    if grid.isLowPoint(point):
      result.add point

func basinSize(grid: seq[seq[int]], lowPoint: Point): int =
  var processed: HashSet[Point]
  var unprocessed = toHashSet([lowPoint])
  while unprocessed.len > 0:
    var neighbors: HashSet[Point]
    for point in unprocessed:
      for neighbor in grid.neighbors(point):
        if grid[neighbor] != 9 and grid[neighbor] > grid[point]:
          neighbors.incl(neighbor)

    processed.incl unprocessed
    unprocessed = neighbors - processed

  result = processed.len

proc solveDay9*: IntSolution =
  let grid = readInputDigits(day = 9).toSeq
  let lowPoints = grid.findLowPoints
  result.part1 = lowPoints.mapIt(grid[it] + 1).sum
  result.part2 = lowPoints.mapIt(grid.basinSize(it)).sorted[^3..^1].prod

when isMainModule:
  echo solveDay9()
