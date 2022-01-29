import helpers, std/[algorithm, heapqueue, sequtils, strutils, strformat, tables]

type State = tuple[grid: string, energy: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

# func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)
# func isHallwayClear(a, b: int, cells: string): bool = cells[min(a, b) .. max(a, b)].allIt(it == '0')
# func inHallway(state: State, grid: Grid, idx: int): bool = idx in grid.hallwayIdxs

# func inOrganizedRoom(state: State, grid: Grid, idx: int, amphipod: char): bool =
#   grid.roomIdxs[amphipods.find(amphipod)].allIt(state.grid[it] == amphipod)

# func inBlockedRoom(state: State, grid: Grid, idx: int, amphipod: char): bool =
#   grid.roomIdxs[amphipods.find(amphipod)].filterIt(it < idx).allIt(state.grid[it] == '.')

# proc moves(state: State, grid: Grid, oldIdx: int, amphipod: char): seq[int] =
#   echo ""
#   if state.inHallway(grid, oldIdx): 
#     echo "in hallway"
# #     if state.roomYs.anyIt(state.grid.getOrDefault((x: rooms[a], y: it), a) != a):
# #       return
# #     else:
# #       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
# #       let y = state.roomYs.filterIt((x: rooms[a], y: it) notin state.grid).max
# #       return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.grid))
#   elif state.inOrganizedRoom(grid, oldIdx, amphipod) or
#        state.inBlockedRoom(grid, oldIdx, amphipod):
#     return
#   else:
#     return
# #   else:
# #     return hallwayXs.filterIt(p.x.isHallwayClear(it, state.grid)).mapIt((it, 1))

proc moves(state: State): seq[State] =
  echo "moves"
#   for oldIdx, amphipod in state.grid:
#     for newIdx in moves(state, grid, oldIdx, amphipod):
#       var updated = state
#       updated.grid[oldIdx] = '.'
#       updated.grid[newIdx] = amphipod
#       # inc updated.energy, costs[amphipod] * manhattanDistance(p, next)
#       result.add updated

# TODO: compare using total costs using manhattan distance
func `<`(a: State, b: State): bool = a.energy < b.energy

func roomSize(state: State): int = (state.grid.len - 7) div 4

iterator rooms(state: State): tuple[idx: int, room: string] =
  for x in countup(0, state.grid.len - 8, state.roomSize):
    yield (idx: x, room: state.grid[x..<x + state.roomSize])

iterator hallway(state: State): tuple[idx: int, cell: char] =
  for x in state.grid.len - 7..state.grid.high:
    yield (idx: x, cell: state.grid[x])

proc isOrganized(state: State): bool = state.grid[0..^8].sorted == state.grid[0..^8]


proc solve(state: State): int =
  # for idx, cell in state.hallway:
  #   echo &"hallway idx: {idx}, cell: {cell}"

  # for idx, cells in state.rooms:
  #   echo &"room idx: {idx}, cells: {cells}"

  var queue: HeapQueue[State]
  queue.push(state)

  var costs: CountTable[string]
  costs[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.isOrganized:
      return current.energy

    for move in current.moves:
      if move.energy < costs.getOrDefault(move.grid, high(int)):
        queue.push move
        costs[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for x in 0 ..< 4: # Rooms
    for y in 0 ..< lines.len - 3:
      result.grid.add lines[2 + y][3 + x * 2]

  for _ in 0 ..< 7: # Hallway
    result.grid.add '.'

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
