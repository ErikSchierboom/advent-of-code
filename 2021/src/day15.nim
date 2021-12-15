import helpers, std/[algorithm, sequtils, sets, tables]

func `[]`(grid: seq[seq[int]], point: Point): int {.inline.} = grid[point.y][point.x]

func points(grid: seq[seq[int]]): seq[Point] =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      result.add (x: x, y: y)

func neighbors(grid: seq[seq[int]], point: Point): HashSet[Point] =
  if point.x > grid[0].low:  result.incl (x: point.x - 1, y: point.y)
  if point.x < grid[0].high: result.incl (x: point.x + 1, y: point.y)
  if point.y > grid.low:     result.incl (x: point.x,     y: point.y - 1)
  if point.y < grid.high:    result.incl (x: point.x,     y: point.y + 1)

proc lowest(q: var HashSet[Point], dist: var Table[Point, int]): Point {.inline.} =
  var currentLow = high(int)

  for point in q:
    if dist[point] < currentLow:
      currentLow = dist[point]
      result = point

proc solveDay15*: IntSolution =
  let grid = readInputDigits(day = 15).toSeq
  let points = grid.points

  var source = (x: 0, y: 0)
  var q: HashSet[Point]
  var dist: Table[Point, int]
  var neighbors: Table[Point, HashSet[Point]]
  let target = (x: grid[0].high, y: grid.high)

  for point in points:
    dist[point] = high(int)
    neighbors[point] = grid.neighbors(point)
    q.incl point

  dist[source] = 0
  
  while q.len > 0:
    let u = lowest(q, dist)
    q.excl u

    if u == target:
      break

    for v in neighbors[u]:
      if v in q:
        let alt = dist[u] + grid[v]
        if alt < dist[v]:
          dist[v] = alt

  result.part1 = dist[target]
 
when isMainModule:
  echo solveDay15()
