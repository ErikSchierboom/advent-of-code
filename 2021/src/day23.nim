import helpers, std/[heapqueue, sequtils, strutils, tables]

type 
  Grid = tuple[roomSize: int, organized: string]
  State = tuple[occupants: string, energy: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func isHallwayClear(a, b: int, grid: string): bool =
  grid[min(a, b) .. max(a, b)].allIt(it == '0')

func inHallway(state: State, idx: int): bool = idx < 7
func room(state: State, idx: int): int = (idx - 7) div state.roomSize
func roomIdx(state: State, idx: int): int = 7 + state.room(idx) * state.roomSize

proc roomOrganized(state: State, idx: int): bool =
  let roomIdx = (idx -  7) div state.roomSize
  let roomAmphipod = amphipods[roomIdx]
  echo "room " & $roomIdx & ": " & $roomAmphipod & "," & $state.occupants[roomIdx * ..roomIdx + state.roomSize]
  # state.occupants[roomIdx..<roomIdx + state.roomSize].allIt(it == roomAmphipod)

proc moves(state: State, oldIdx: int, amphipod: char): seq[int] =
   # Hallway
  if state.inHallway(oldIdx):
    echo "in hallway"
  else:
    return
    # if state.roomYs.anyIt(state.occupants.getOrDefault((x: rooms[a], y: it), a) != a):
#       return
#     else:
#       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       let y = state.roomYs.filterIt((x: rooms[a], y: it) notin state.occupants).max
#       return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.occupants))
#   # Room correct
#   elif p.x == rooms[a] and (p.y .. state.roomYs.max).allIt(state.occupants.getOrDefault((x: p.x, y: it)) == a):
#     return
#    # Top of room not empty
#   elif (x: p.x, y: p.y - 1) in state.occupants:
#     return
#   else:
#     return hallwayXs.filterIt(p.x.isHallwayClear(it, state.occupants)).mapIt((it, 1))

proc moves(state: State): seq[State] =
  for oldIdx, amphipod in state.occupants:
    for newIdx in moves(state, oldIdx, amphipod):
      var updated = state
      updated.occupants[oldIdx] = '.'
      updated.occupants[newIdx] = amphipod
      # inc updated.energy, costs[amphipod] * manhattanDistance(p, next)
      result.add updated

# TODO: compare using total costs using manhattan distance
func `<`(a: State, b: State): bool = a.energy < b.energy

func toGrid(state: State): Grid =
  result.roomSize = (state.occupants.len - 7) div 4

  for _ in 0 ..< 7: # Hallway
    result.organized.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< result.roomSize:
      result.organized.add amphipods[x]

proc solve(state: State): int =
  let grid = state.toGrid

  var queue: HeapQueue[State]
  queue.push(state)

  var costs: CountTable[string]
  costs[state.occupants] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.occupants == grid.organized:
      return current.energy

    for move in current.moves:
      if move.energy < costs.getOrDefault(move.occupants, high(int)):
        queue.push move
        costs[move.occupants] = move.energy

proc readInputState(lines: seq[string]): State =
  for _ in 0 ..< 7: # Hallway
    result.occupants.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< lines.len - 3:
      result.occupants.add lines[2 + y][3 + x * 2]

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
