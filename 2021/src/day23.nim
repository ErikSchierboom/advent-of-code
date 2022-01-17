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

func organizedRoom(grid: Grid, idx: int): bool {.inline.} =
  grid.rooms[idx].top == amphipods[idx] and grid.rooms[idx].bottom == amphipods[idx]

func organized(grid: Grid): bool {.inline.} =
  grid.organizedRoom(0) and grid.organizedRoom(1) and grid.organizedRoom(2) and grid.organizedRoom(3)

proc movesFromHallway(state: State, idx: int): seq[State] =
  if state.grid.hallway[idx] == '.':
    echo &"hallway {idx}: is empty"
    return

  let hallway = state.grid.hallway[idx]
  let roomIdx = amphipods.find(hallway)
  let room = state.grid.rooms[roomIdx]

  if room.top != '.':
    echo &"hallway {idx}: target room {roomIdx} has top taken"
  elif room.bottom == hallway:
    echo &"hallway {idx}: target room {roomIdx} has bottom correct"
  else:
    echo &"hallway {idx}: target room {roomIdx} has bottom incorrect"

proc movesFromRoom(state: State, idx: int): seq[State] =
  if state.grid.organizedRoom(idx):
    echo &"room {idx}: top and bottom are correct"
    return

  let room = state.grid.rooms[idx]

  if room.top == '.':
    echo &"room {idx}: top is empty"
    if room.bottom == amphipods[idx]:
     echo &"room {idx}: bottom is correct"
    elif room.top == '.':
      echo &"room {idx}: bottom is incorrect and top is empty"
    else:
      echo &"room {idx}: bottom is incorrect and top is taken"
  elif room.top == amphipods[idx]:
    if room.bottom == '.':
      echo &"room {idx}: top is correct and bottom is empty"
    else:
      echo &"room {idx}: top is correct and bottom is incorrect"
  else:
    echo &"room {idx}: top is not correct"

proc moves(state: State): seq[State] =
  for idx in state.grid.rooms.low .. state.grid.rooms.high:
    result.add movesFromRoom(state, idx)

  for idx in state.grid.hallway.low .. state.grid.hallway.high:
    result.add movesFromHallway(state, idx)

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
