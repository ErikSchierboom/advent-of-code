import helpers, std/[heapqueue, options, sequtils, strformat, tables]

type 
  Room = tuple[top, bottom: char]
  Rooms = array[4, Room]
  Hallway = array[11, char]
  Grid = tuple[hallway: Hallway, rooms: Rooms]
  State = tuple[grid: Grid, energy: int]

func `<` (a, b: State): bool = a.energy < b.energy

const amphipods = "ABCD"
const hallwayXs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
const roomXs = [3, 5, 7, 9]
const roomYs = [2, 3]

func moveCost(amphipod: char): int = 
  const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
  costs[amphipod]

func `$`(grid: Grid): string =
  result.add "#############\n#"
  for hall in grid.hallway:
    result.add hall
  result.add "#\n###"
  for room in grid.rooms:
    result.add room.top
    result.add '#'
  result.add "##\n  #"
  for room in grid.rooms:
    result.add room.bottom
    result.add '#'
  result.add "\n  #########  "

func `$`(state: State): string =
  result.add "Energy: " & $state.energy
  result.add '\n'
  result.add $state.grid
  result.add '\n'

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq

  for x in result.grid.hallway.low .. result.grid.hallway.high:
    result.grid.hallway[x] = lines[1][x + 1]

  for x in result.grid.rooms.low .. result.grid.rooms.high:
    result.grid.rooms[x].top = lines[2][x * 2 + 3]
    result.grid.rooms[x].bottom = lines[3][x * 2 + 3]

proc move(point: Point, kind: char, state: State): seq[State] =
  echo &"move point {point}, kind{kind}"

func organized(grid: Grid): bool {.inline.} =
  grid.rooms[0].top == 'A' and grid.rooms[0].bottom == 'A' and
  grid.rooms[1].top == 'B' and grid.rooms[1].bottom == 'B' and
  grid.rooms[2].top == 'C' and grid.rooms[2].bottom == 'C' and
  grid.rooms[3].top == 'D' and grid.rooms[3].bottom == 'D'

proc moves(state: State): seq[State] =
  echo "moves"
  # for point, kind in state.grid:
  #   result.add move(point, kind, state)

proc part1(state: State): int =
  var queue: HeapQueue[State]
  var energyCounts = initCountTable[Grid]()

  energyCounts[state.grid] = 0  
  queue.push state

  while queue.len > 0:
    let current = queue.pop()

    if current.grid.organized:
      echo "organized"
      echo current.grid
      return current.energy

    if current.energy > energyCounts.getOrDefault(current.grid, high(int)):
      continue

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc solveDay23*: IntSolution =
  let state = readInputState()
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()
