import helpers, std/[sequtils, sets]

func `[]`(grid: seq[seq[int]], point: Point): int = grid[point.y][point.x]

iterator points(grid: seq[seq[int]]): Point =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      yield (x: x, y: y)

const deltas = 
  [
    (-1, -1), (0, -1), (1, -1),
    (-1,  0),          (1,  0),
    (-1,  1), (0,  1), (1,  1)
  ]

iterator neighbors(grid: seq[seq[int]], point: Point): Point =
  for (dx, dy) in deltas:
    let neighbor = (x: point.x + dx, y: point.y + dy)
    if neighbor.x in grid[0].low .. grid[0].high and
       neighbor.y in grid.low .. grid.high:
      yield neighbor

proc step(grid: var seq[seq[int]]): int =
  for point in grid.points:
    inc grid[point.y][point.x]

  var toFlash: HashSet[Point]
  for point in grid.points:
    if grid[point] > 9:
      toFlash.incl point

  var flashed: HashSet[Point]

  while toFlash.len > 0:
    echo toFlash
    let flash = toFlash.pop
    flashed.incl flash
    
    for neighbor in grid.neighbors(flash):
      inc grid[neighbor.y][neighbor.x]

      if neighbor notin flashed and grid[neighbor] > 9:
        toFlash.incl neighbor

  for point in grid.points:
    if grid[point] > 9:
      grid[point.y][point.x] = 0

  result = flashed.len

proc solveDay11*: IntSolution =
  var grid = readInputDigits(day = 11).toSeq
  for _ in 1..100:
    inc result.part1, grid.step
  
  echo grid

when isMainModule:
  echo solveDay11()
