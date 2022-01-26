import helpers, std/[heapqueue, sequtils, strutils, tables]

type State = tuple[grid: string, cost, energy, roomSize: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

func manhattanDistance(a, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func isHallwayClear(a, b: int, grid: string): bool =
  grid[min(a, b) .. max(a, b)].allIt(it == '0')

func inHallway(state: State, idx: int): bool = idx < 7
func room(state: State, idx: int): int = (idx - 7) div state.roomSize

func moves(state: State, oldIdx: int, amphipod: char): seq[int] =
  return
#    # Hallway
#   if p.y == hallwayY:
#     if state.roomYs.anyIt(state.grid.getOrDefault((x: rooms[a], y: it), a) != a):
#       return
#     else:
#       let x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       let y = state.roomYs.filterIt((x: rooms[a], y: it) notin state.grid).max
#       return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.grid))
#   # Room correct
#   elif p.x == rooms[a] and (p.y .. state.roomYs.max).allIt(state.grid.getOrDefault((x: p.x, y: it)) == a):
#     return
#    # Top of room not empty
#   elif (x: p.x, y: p.y - 1) in state.grid:
#     return
#   else:
#     return hallwayXs.filterIt(p.x.isHallwayClear(it, state.grid)).mapIt((it, 1))

func moves(state: State): seq[State] =
  for oldIdx, amphipod in state.grid:
    for newIdx in moves(state, oldIdx, amphipod):
      var updated = state
      updated.grid[oldIdx] = '.'
      updated.grid[newIdx] = amphipod
      # TODO: calculate total costs using manhattan distance
      # inc updated.energy, costs[amphipod] * manhattanDistance(p, next)
      result.add updated

func `<`(a: State, b: State): bool = a.cost < b.cost

func organizedGrid(state: State): string =
  for _ in 0 ..< 7: # Hallway
    result.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< state.roomSize:
      result.add amphipods[x]

proc solve(state: State): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var costs: CountTable[string]
  costs[state.grid] = state.cost

  let organizedGrid = state.organizedGrid

  while queue.len > 0:
    let current = queue.pop()

    if current.grid == organizedGrid:
      return current.energy

    for move in current.moves:
      if move.cost < costs.getOrDefault(move.grid, high(int)):
        queue.push move
        costs[move.grid] = move.cost

proc readInputState(lines: seq[string]): State =
  result.roomSize = lines.len - 3

  for _ in 0 ..< 7: # Hallway
    result.grid.add '.'

  for x in 0 ..< 4: # Rooms
    for y in 0 ..< result.roomSize:
      result.grid.add lines[2 + y][3 + x * 2]

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
