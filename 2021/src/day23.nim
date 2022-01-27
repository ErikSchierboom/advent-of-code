import helpers, std/[heapqueue, sequtils, strutils, tables]

type 
  Grid = tuple[roomSize: int, organized: string]
  State = tuple[cells: string, energy: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)
func isHallwayClear(a, b: int, cells: string): bool = cells[min(a, b) .. max(a, b)].allIt(it == '0')
func inHallway(state: State, grid: Grid, idx: int): bool = idx < 7
func targetRoom(state: State, grid: Grid, amphipod: char): string =
  let roomBeginIdx = 7 + amphipods.find(amphipod) * grid.roomSize
  let roomEndIdx = roomBeginIdx + grid.roomSize - 1
  state.cells[roomBeginIdx..roomEndIdx]

func inOrganizedRoom(state: State, grid: Grid, amphipod: char): bool =
  targetRoom(state, grid, amphipod).allIt(it == amphipod)

func inBlockedRoom(state: State, grid: Grid, idx: int): bool =
  let roomBeginIdx = idx - 7 - (idx mod grid.roomSize)

proc moves(state: State, grid: Grid, oldIdx: int, amphipod: char): seq[int] =
  if state.inHallway(grid, oldIdx): 
    echo "in hallway"
#     if state.roomYs.anyIt(state.cells.getOrDefault((x: rooms[a], y: it), a) != a):
#       return
#     else:
#       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       let y = state.roomYs.filterIt((x: rooms[a], y: it) notin state.cells).max
#       return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.cells))
  elif state.inOrganizedRoom(grid, amphipod): 
    return
  elif state.inBlockedRoom(grid, oldIdx):
    return
  else:
    return
#   else:
#     return hallwayXs.filterIt(p.x.isHallwayClear(it, state.cells)).mapIt((it, 1))

proc moves(state: State, grid: Grid): seq[State] =
  for oldIdx, amphipod in state.cells:
    for newIdx in moves(state, grid, oldIdx, amphipod):
      var updated = state
      updated.cells[oldIdx] = '.'
      updated.cells[newIdx] = amphipod
      # inc updated.energy, costs[amphipod] * manhattanDistance(p, next)
      result.add updated

# TODO: compare using total costs using manhattan distance
func `<`(a: State, b: State): bool = a.energy < b.energy

func toGrid(state: State): Grid =
  result.roomSize = (state.cells.len - 7) div 4

  for _ in 0 ..< 7: # Hallway
    result.organized.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< result.roomSize:
      result.organized.add amphipods[x]

proc solve(state: State): int =
  let grid = state.toGrid

  echo targetRoom(state, grid, 'A')
  echo targetRoom(state, grid, 'B')
  echo targetRoom(state, grid, 'C')
  echo targetRoom(state, grid, 'D')

  # TODO: flip rooms and hallway

  var queue: HeapQueue[State]
  queue.push(state)

  var costs: CountTable[string]
  costs[state.cells] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.cells == grid.organized:
      return current.energy

    for move in current.moves(grid):
      if move.energy < costs.getOrDefault(move.cells, high(int)):
        queue.push move
        costs[move.cells] = move.energy

proc readInputState(lines: seq[string]): State =
  for _ in 0 ..< 7: # Hallway
    result.cells.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< lines.len - 3:
      result.cells.add lines[2 + y][3 + x * 2]

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
