import helpers, std/[heapqueue, sequtils, tables]

type State = tuple[grid: string, energy, roomSize: int]

const amphipods = "ABCD"
const rooms = { 'A': 3, 'B': 5, 'C': 7, 'D': 9 }.toTable
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
const hallwayXs = [1, 2, 4, 6, 8, 10, 11]
const hallwayY = 1
const roomXs = [3, 5, 7, 9]

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func toPoint(state: State, idx: int): Point =
  if idx < hallwayXs.len:
    (x: hallwayXs[idx], y: hallwayY)
  else:
    (x: roomXs[(idx - hallwayXs.len) div state.roomSize], y: idx mod state.roomSize + hallwayY + 1)

func toIdx(state: State, p: Point): int =
  if p.y == hallwayY:
    hallwayXs.find(p.x)
  else:
    roomXs.find(p.x) * state.roomSize + p.y - hallwayY - 1

func isHallwayClear(a, b: int, state: State): bool =
  for x in min(a, b) .. max(a, b):
    if state.grid[x] != '.':
      return false

  true

func canMoveToRoom(a: char, p: Point, state: State): bool =
  for y in 0..<state.roomSize:
    if state.grid[state.toIdx(p)] != a:
      return false
  
  true

func canMoveToHallway(a: char, p: Point, state: State): bool =
  for y in 0..<p.y:
    if state.grid[state.toIdx(p)] != '.':
      return false

  true

func inHallway(a: char, p: Point, state: State): bool = p.y == hallwayY

func inOrganizedRoom(a: char, p: Point, state: State): bool =
  p.x == rooms[a] and (p.y ..< state.roomSize + 2).toSeq.allIt(state.grid[state.toIdx((x: p.x, y: it))] == a)

func moves(a: char, p: Point, state: State): seq[Point] =
  if inHallway(a, p, state):
    if canMoveToRoom(a, p, state):
      let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
      let y = (2..<state.roomSize + 2).toSeq.filterIt(state.grid[state.toIdx((x: rooms[a], y: it))] == '.').max
      result.add @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state))
  elif not inOrganizedRoom(a, p, state) and canMoveToHallway(a, p, state):
    result.add hallwayXs.filterIt(p.x.isHallwayClear(it, state)).mapIt((it, 1))

func moves(state: State): seq[State] =
  for p, a in state.grid:
    for next in moves(a, state.toPoint(p), state):
      var updated = state
      updated.grid[p] = '.'
      updated.grid[state.toIdx(next)] = a
      inc updated.energy, costs[a] * manhattanDistance(state.toPoint(p), next)
      result.add updated

func `<`(a: State, b: State): bool = a.energy < b.energy

func toGoal(state: State): string =
  for _ in 0..<7:
    result.add '.'

  for amphipod in amphipods:
    for _ in 0..<state.roomSize:
      result.add amphipod

proc solve(state: State): int =
  echo state
  echo state.toGoal
  # var queue: HeapQueue[State]
  # queue.push(state)

  # var energyCounts: CountTable[string]
  # energyCounts[state.grid] = state.energy

  # let goal = state.toGoal

  # while queue.len > 0:
  #   let current = queue.pop()

  #   if current.grid == goal:
  #     return current.energy

  #   for move in current.moves:
  #     if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
  #       queue.push move
  #       energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for _ in 0..<7:
    result.grid.add '.'

  for y in 2 ..< lines.high:
    for _, x in rooms:
      result.grid.add lines[y][x]
  
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
  # result.part2 = part2()

when isMainModule:
  echo solveDay23()