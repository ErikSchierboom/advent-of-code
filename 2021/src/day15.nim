import helpers, std/[heapqueue, sequtils, tables]

type Node = object
  pos: Point
  cost: int

proc `<` (a, b: Node): bool = a.cost < b.cost

func points(grid: seq[seq[int]]): seq[Point] =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      result.add (x: x, y: y)

iterator neighbors(grid: seq[seq[int]], point: Point): Point =
  if point.x > grid[0].low:  yield (x: point.x - 1, y: point.y)
  if point.x < grid[0].high: yield (x: point.x + 1, y: point.y)
  if point.y > grid.low:     yield (x: point.x,     y: point.y - 1)
  if point.y < grid.high:    yield (x: point.x,     y: point.y + 1)

proc shortestPath(grid: seq[seq[int]]): int =
  let start = (x: 0, y: 0)
  let stop = (x: grid[0].high, y: grid.high)

  var queue: HeapQueue[Node]
  var dist = initCountTable[Point](initialSize = stop.x * stop.y)

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
      let next = Node(cost: current.cost + grid[neighbor.y][neighbor.x], pos: neighbor)
      if next.cost < dist[next.pos]:
        queue.push next
        dist[next.pos] = next.cost

proc solveDay15*: IntSolution =
  let grid = readInputDigits(day = 15).toSeq
  result.part1 = shortestPath(grid)
 
when isMainModule:
  echo solveDay15()
