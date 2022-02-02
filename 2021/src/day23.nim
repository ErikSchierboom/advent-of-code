import helpers, std/[algorithm, heapqueue, sequtils, strformat, tables]

type 
  Grid = tuple[hallway: seq[int], rooms: array[4, seq[int]]]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const rooms = [3, 5, 7, 9]

func isOrganized(grid: Grid, i: int): bool = grid.rooms[i].allIt(it == i)
func isOrganized(grid: Grid): bool = countup(grid.rooms.low, grid.rooms.high).toSeq.allIt(grid.isOrganized(it))

# func isHallwayClear(a, b: int, state: State): bool =
#   for x in min(a, b) .. max(a, b):
#     if state.grid[x] != '.':
#       return false

#   true

# func canMoveToRoom(a: char, p: Point, state: State): bool =
#   for y in 0..<state.roomSize:
#     if state.grid[state.toIdx(p)] != a:
#       return false
  
#   true

proc moves(state: State): seq[State] =
  for x, a in state.grid.hallway:
    if a == -1:
      continue

    let room = state.grid.rooms[a]
    

    #     if canMoveToRoom(a, p, state):
#       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       echo &"a: {a}, p: {p}: can move to room"
#       let y = (2..<state.roomSize + 2).toSeq.filterIt(state.grid[state.toIdx((x: rooms[a], y: it))] == '.')
#       # .max
#       # result.add @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state))

  for i, room in state.grid.rooms:
    if state.grid.isOrganized(i):
      continue

    for y, a in room:
      if a == -1:
        continue
      
#       result.add hallwayXs.filterIt(p.x.isHallwayClear(it, state)).mapIt((it, 1))


      

  # for next in moves(a, state.toPoint(p), state):
  #   var updated = state
  #   updated.grid[p] = '.'
  #   updated.grid[state.toIdx(next)] = a
  #   inc updated.energy, costs[a] * manhattanDistance(state.toPoint(p), next)
  #   result.add updated

func `<`(a: State, b: State): bool = a.energy < b.energy

proc solve(state: State): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[Grid]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid.isOrganized:
      return current.energy

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for x in 1..11:
    result.grid.hallway.add amphipods.find(lines[1][x])

  for i, x in rooms:
    for y in 2 ..< lines.high:
      result.grid.rooms[i].add amphipods.find(lines[y][x])

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

# const amphipods = "ABCD"
# const rooms = { 'A': 3, 'B': 5, 'C': 7, 'D': 9 }.toTable
# const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
# const hallwayXs = [1, 2, 4, 6, 8, 10, 11]
# const hallwayY = 1
# const roomXs = [3, 5, 7, 9]

# func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)
# func toPoint(state: State, idx: int): Point = state.points[idx]
# func toIdx(state: State, p: Point): int = state.points.find(p)

# func isHallwayClear(a, b: int, state: State): bool =
#   for x in min(a, b) .. max(a, b):
#     if state.grid[x] != '.':
#       return false

#   true

# func canMoveToRoom(a: char, p: Point, state: State): bool =
#   for y in 0..<state.roomSize:
#     if state.grid[state.toIdx(p)] != a:
#       return false
  
#   true

# func canMoveToHallway(a: char, p: Point, state: State): bool =
#   for y in 2..<p.y:
#     if state.grid[state.toIdx(p)] != '.':
#       return false

#   true

# func inHallway(a: char, p: Point, state: State): bool = p.y == hallwayY

# func inOrganizedRoom(a: char, p: Point, state: State): bool =
#   p.x == rooms[a] and (p.y ..< state.roomSize + 2).toSeq.allIt(state.grid[state.toIdx((x: p.x, y: it))] == a)

# proc moves(a: char, p: Point, state: State): seq[Point] =
#   echo state
  
#   if inHallway(a, p, state):
#     if canMoveToRoom(a, p, state):
#       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       echo &"a: {a}, p: {p}: can move to room"
#       let y = (2..<state.roomSize + 2).toSeq.filterIt(state.grid[state.toIdx((x: rooms[a], y: it))] == '.')
#       # .max
#       # result.add @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state))
#   elif not inOrganizedRoom(a, p, state):
#     if canMoveToHallway(a, p, state):
#       result.add hallwayXs.filterIt(p.x.isHallwayClear(it, state)).mapIt((it, 1))

# proc moves(state: State): seq[State] =
#   for p, a in state.grid:
#     if a == '.':
#       continue

#     for next in moves(a, state.toPoint(p), state):
#       var updated = state
#       updated.grid[p] = '.'
#       updated.grid[state.toIdx(next)] = a
#       inc updated.energy, costs[a] * manhattanDistance(state.toPoint(p), next)
#       result.add updated

# func `<`(a: State, b: State): bool = a.energy < b.energy

# func toGoal(state: State): string =
#   for _ in 0..<11:
#     result.add '.'

#   for amphipod in amphipods:
#     for _ in 0..<state.roomSize:
#       result.add amphipod

