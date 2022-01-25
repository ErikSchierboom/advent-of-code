import helpers, std/[heapqueue, sequtils, tables]

type 
  Grid = Table[Point, char]
  State = tuple[grid: Grid, energy: int]

const rooms = { 'A': 3, 'B': 5, 'C': 7, 'D': 9 }.toTable
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func isDone(grid: Grid): bool =
  for kind, x in rooms:
    if grid.getOrDefault((x: x, y: 2)) != kind or 
       grid.getOrDefault((x: x, y: 3)) != kind:
      return false
  
  true

func isHallwayClear(a, b: int, grid: Grid): bool =
  (a.min(b) .. a.max(b)).allIt((x: it, y: 1) notin grid)

func moves(a: char, p: Point, grid: Grid, rest: seq[int]): seq[Point] =
  if p.y == 1: # Hallway
    if rest.anyIt(grid.getOrDefault((x: rooms[a], y: it), a) != a): return @[]
    let
      x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
      y = rest.filterIt((x: rooms[a], y: it) notin grid).max
    return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], grid))
  # Room correct
  if p.x == rooms[a] and (p.y .. rest.max).allIt(grid.getOrDefault((x: p.x, y: it)) == a):
    return @[]
  if (x: p.x, y: p.y - 1) in grid: # Top of room not empty
    @[]
  else:
    [1, 2, 4, 6, 8, 10, 11].filterIt(p.x.isHallwayClear(it, grid)).mapIt((it, 1))

func moves(state: State, rest: seq[int]): seq[State] =
  for p, a in state.grid:
    for next in moves(a, p, state.grid, rest):
      var updated = state
      updated.grid.del((x: p.x, y: p.y))
      updated.grid[next] = a
      inc updated.energy, costs[a] * manhattanDistance(p, next)
      result.add updated

func `<`(a: State, b: State): bool = a.energy < b.energy

func process(state: State, rest: seq[int]): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[Grid]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid.isDone:
      return current.energy

    if current.energy > energyCounts.getOrDefault(current.grid, high(int)):
      continue

    for move in current.moves(rest):
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State = 
  for y in lines.low .. lines.high:
    for x in lines[y].low .. lines[y].high:
      if lines[y][x] in rooms:
        result.grid[(x: x, y: y)] = lines[y][x]

proc part1*: int = 
  let lines = readInputStrings(day = 23).toSeq
  readInputState(lines).process @[2, 3]

proc part2*: int = 
  var lines = readInputStrings(day = 23).toSeq
  lines.insert(@["  #D#C#B#A#  ", "  #D#B#A#C#  "], pos = 3)
  readInputState(lines).process @[2, 3, 4, 5]

proc solveDay23*: IntSolution =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay23()
