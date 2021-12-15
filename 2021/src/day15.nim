import helpers, std/[heapqueue, sequtils, tables]

type 
  Node = object
    pos: Point
    cost: int

  Grid = object
    cells: seq[seq[int]]
    baseWidth, baseHeight, width, height: int

proc `<` (a, b: Node): bool = a.cost < b.cost

func points(grid: Grid): seq[Point] =
  for y in 0 ..< grid.height:
    for x in 0 ..< grid.width:
      result.add (x: x, y: y)

iterator neighbors(grid: Grid, point: Point): Point =
  if point.x > 0: yield (x: point.x - 1, y: point.y)  
  if point.y > 0: yield (x: point.x, y: point.y - 1)
  if point.x < grid.width - 1: yield (x: point.x + 1, y: point.y)
  if point.y < grid.height - 1: yield (x: point.x, y: point.y + 1)

proc shortestPath(grid: Grid): int =
  let start = (x: 0, y: 0)
  let stop = (x: grid.width - 1, y: grid.height - 1)

  var queue: HeapQueue[Node]
  var dist = initCountTable[Point](initialSize = grid.width * grid.height)

  for point in grid.points:
    dist[point] = high(int)

  dist[start] = 0  
  queue.push Node(pos: start, cost: 0)
  
  while queue.len > 0:
    let current = queue.pop()

    if current.pos == stop:
      return dist[stop]

    if current.cost > dist[current.pos]:
      continue

    for neighbor in grid.neighbors(current.pos):
      let xmod = neighbor.x div grid.baseWidth
      let ymod = neighbor.y div grid.baseHeight
      let cost = (grid.cells[neighbor.y mod grid.baseHeight][neighbor.x mod grid.baseWidth] + xmod + ymod - 1) mod 9 + 1

      let next = Node(cost: current.cost + cost, pos: neighbor)
      if next.cost < dist[next.pos]:
        queue.push next
        dist[next.pos] = next.cost

func initGrid(cells: seq[seq[int]], dimension: int): Grid =
  Grid(cells: cells, baseWidth: cells[0].len, baseHeight: cells.len, width: cells[0].len * dimension, height: cells[0].len * dimension )

proc solveDay15*: IntSolution =
  let cells = readInputDigits(day = 15).toSeq
  result.part1 = shortestPath(initGrid(cells, dimension = 1))
  result.part2 = shortestPath(initGrid(cells, dimension = 5))
 
when isMainModule:
  echo solveDay15()
