import helpers, std/[heapqueue, sequtils, tables]

type Node = object
  pos: Point
  cost: int

proc `<` (a, b: Node): bool = a.cost < b.cost

func points(grid: var seq[seq[int]]): seq[Point] =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      result.add (x: x, y: y)

iterator neighbors(grid: var seq[seq[int]], point: Point): Point =
  if point.x > grid[0].low:  yield (x: point.x - 1, y: point.y)
  if point.x < grid[0].high: yield (x: point.x + 1, y: point.y)
  if point.y > grid.low:     yield (x: point.x,     y: point.y - 1)
  if point.y < grid.high:    yield (x: point.x,     y: point.y + 1)

proc solveDay15*: IntSolution =
  var grid = readInputDigits(day = 15).toSeq
  var points = grid.points

  var source = (x: 0, y: 0)
  var q: HeapQueue[Node]
  var dist = newTable[Point, int]()
  let target = (x: grid[0].high, y: grid.high)

  for point in points:
    dist[point] = high(int)

  dist[source] = 0  
  q.push Node(pos: source, cost: 0)
  
  while q.len > 0:
    let u = q.pop()

    if u.pos == target:
      result.part1 = dist[target]
      return

    if u.cost > dist[u.pos]:
      continue

    for v in grid.neighbors(u.pos):
      let next = Node(cost: u.cost + grid[v.y][v.x], pos: v)
      if next.cost < dist[next.pos]:
        q.push next
        dist[next.pos] = next.cost
 
when isMainModule:
  echo solveDay15()
