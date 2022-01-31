import helpers, std/[heapqueue, sequtils, tables]

type 
  Grid = Table[Point, char]
  State = tuple[grid: Grid, energy, roomSize: int]

const rooms = { 'A': 3, 'B': 5, 'C': 7, 'D': 9 }.toTable
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
const hallwayXs = [1, 2, 4, 6, 8, 10, 11]
const hallwayY = 1

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func isOrganized(state: State): bool =
  for kind, x in rooms:
    for y in 0..<state.roomSize:
      if state.grid.getOrDefault((x: x, y: 2 + y)) != kind:
        return false
  
  true

func isHallwayClear(a, b: int, grid: Grid): bool =
  for x in min(a, b) .. max(a, b):
    if (x: x, y: 1) in grid:
      return false

  true

func canMoveToRoom(a: char, p: Point, state: State): bool =
  for y in 0..<state.roomSize:
    if state.grid.getOrDefault((x: rooms[a], y: y + 2), a) != a:
      return false
  
  true

func canMoveToHallway(a: char, p: Point, state: State): bool =
  for y in 0..<p.y:
    if (x: p.x, y: y) in state.grid:
      return false

  true

func inHallway(a: char, p: Point, state: State): bool = p.y == hallwayY

func inOrganizedRoom(a: char, p: Point, state: State): bool =
  p.x == rooms[a] and (p.y ..< state.roomSize + 2).toSeq.allIt(state.grid.getOrDefault((x: p.x, y: it)) == a)

func moves(a: char, p: Point, state: State): seq[Point] =
  if inHallway(a, p, state):
    if canMoveToRoom(a, p, state):
      let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
      let y = (2..<state.roomSize + 2).toSeq.filterIt((x: rooms[a], y: it) notin state.grid).max
      result.add @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.grid))
  elif not inOrganizedRoom(a, p, state) and canMoveToHallway(a, p, state):
    result.add hallwayXs.filterIt(p.x.isHallwayClear(it, state.grid)).mapIt((it, 1))

func moves(state: State): seq[State] =
  for p, a in state.grid:
    for next in moves(a, p, state):
      var updated = state
      updated.grid.del((x: p.x, y: p.y))
      updated.grid[next] = a
      inc updated.energy, costs[a] * manhattanDistance(p, next)
      result.add updated

func `<`(a: State, b: State): bool = a.energy < b.energy

func solve(state: State): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[Grid]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.isOrganized:
      return current.energy

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for y in 2 ..< lines.high:
    for _, x in rooms:
      result.grid[(x: x, y: y)] = lines[y][x]
  
  result.roomSize = lines.len - 3

proc part1*: int = 
  let lines = readInputStrings(day = 23).toSeq
  solve(readInputState(lines))

proc part2*: int = 
  var lines = readInputStrings(day = 23).toSeq
  lines.insert(@["  #D#C#B#A#  ", "  #D#B#A#C#  "], pos = 3)
  solve(readInputState(lines))

proc solveDay23*: IntSolution =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay23()