import helpers, std/[heapqueue, options, sequtils, strformat, tables]

type 
  Grid = Table[Point, char]
  State = tuple[grid: Grid, energy: int]

func `<` (a, b: State): bool = a.energy < b.energy

const amphipods = "ABCD"

func moveCost(amphipod: char): int = 
  const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
  costs[amphipod]

func `$`(grid: Grid): string =
  result.add "#############\n"
  result.add "#"
  for x in 1..11:
    result.add grid.getOrDefault((x: x, y: 1), '.')
  result.add "#\n"
  result.add "###"
  result.add grid.getOrDefault((x: 3, y: 2), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 5, y: 2), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 7, y: 2), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 9, y: 2), '.')
  result.add "###\n"
  result.add "  #"
  result.add grid.getOrDefault((x: 3, y: 3), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 5, y: 3), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 7, y: 3), '.')
  result.add '#'
  result.add grid.getOrDefault((x: 9, y: 3), '.')
  result.add "#\n"
  result.add "  #########  "

# func `$`(state: State): string =
#   result.add "Energy: " & $state.energy
#   result.add '\n'
#   result.add $state.grid
#   result.add '\n'

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  for y in 0..lines.high:
    for x in 0..lines[y].high:
      if lines[y][x] in amphipods:
        result.grid.add((x: x, y: y), lines[y][x])

func organized(grid: Grid): bool =
  grid.rooms[0][0] == 'A' and grid.rooms[0][1] == 'A' and
  grid.rooms[1][0] == 'B' and grid.rooms[1][1] == 'B' and
  grid.rooms[2][0] == 'C' and grid.rooms[2][1] == 'C' and
  grid.rooms[3][0] == 'D' and grid.rooms[3][1] == 'D'

func roomToHallwayIdx(idx: int): int = idx * 2 + 2

proc moveToHallway(state: State, idx: int, pos: int): seq[State] =
  const openHallwayX = [2, 4, 6, 8]
  let movesToHallway = pos + 1

  for x in countdown(idx.roomToHallwayIdx - 1, 0):
    if x in openHallwayX:
      continue

    if state.grid.hallway[x] == '.':
      let moves = movesToHallway + abs(idx.roomToHallwayIdx - x)
      let energy = moves * moveCost[state.grid.rooms[idx][pos]]
      echo "move " & $state.grid.rooms[idx][pos] & " to hallway " & $x & " from room " & $idx & " pos " & $pos & " in " & $moves & " moves for " & $energy & " energy"
      var newState = state
      newState.grid.hallway[x] = state.grid.rooms[idx][pos]
      newState.grid.rooms[idx][pos] = '.'
      inc newState.energy, energy
      result.add newState

  for x in countup(idx.roomToHallwayIdx + 1, 10):
    if x in openHallwayX:
      continue

    if state.grid.hallway[x] == '.':
      let moves = movesToHallway + abs(idx.roomToHallwayIdx - x)
      let energy = moves * moveCost[state.grid.rooms[idx][pos]]
      echo "move " & $state.grid.rooms[idx][pos] & " to hallway " & $x & " from room " & $idx & " pos " & $pos & " in " & $moves & " moves for " & $energy & " energy"
      var newState = state
      newState.grid.hallway[x] = state.grid.rooms[idx][pos]
      newState.grid.rooms[idx][pos] = '.'
      inc newState.energy, energy
      result.add newState

proc canMoveBetweenRooms(state: State, room1, room2: int): bool =
  echo $room1 & ":" & $room1.roomToHallwayIdx
  echo $room2 & ":" & $room2.roomToHallwayIdx

  for x in min(room1.roomToHallwayIdx, room2.roomToHallwayIdx)..max(room1.roomToHallwayIdx, room2.roomToHallwayIdx):
    if state.grid.hallway[x] != '.':
      return false

  true

proc canMoveToRoom(state: State, hallway, room: int): bool =
  for x in min(room.roomToHallwayIdx, hallway)..max(room.roomToHallwayIdx, hallway):
    if state.grid.hallway[x] != '.':
      return false

  true

proc moveFromRoom(state: State, idx: int): seq[State] =
  if state.grid.rooms[idx][0] == roomType[idx] and
     state.grid.rooms[idx][1] == roomType[idx]:
    echo "move from room " & $idx & ": both in correct place"
    return  
  elif state.grid.rooms[idx][0] != '.':
    echo "move from room " & $idx & ": top is incorrect"
    let correctRoom = roomType.find(state.grid.rooms[idx][0])
    if state.grid.rooms[correctRoom][0] == '.' and state.grid.rooms[correctRoom][1] == '.' and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to bottom open pos in correct room"
    elif state.grid.rooms[correctRoom][0] == '.' and state.grid.rooms[correctRoom][1] == state.grid.rooms[idx][0] and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to top open pos in correct room"
    else:
      result.add moveToHallway(state, idx, 0)
  elif state.grid.rooms[idx][1] != '.':
    let correctRoom = roomType.find(state.grid.rooms[idx][1])
    echo "move from room " & $idx & ": bottom is incorrect"
    if state.grid.rooms[correctRoom][1] == '.' and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to open bottom pos in correct room"
    elif state.grid.rooms[correctRoom][0] == '.' and state.grid.rooms[correctRoom][1] == state.grid.rooms[idx][1] and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to open top pos in correct room"
    else:
      result.add moveToHallway(state, idx, 1)
  else:
    echo "move from room " & $idx & ": empty room"

proc moveFromHallway(state: State, idx: int): seq[State] =
  if state.grid.hallway[idx] == '.':
    return

  let correctRoom = roomType.find(state.grid.hallway[idx])
  echo "move from hallway " & $idx & ": bottom is incorrect"
  if state.grid.rooms[correctRoom][1] == '.' and canMoveToRoom(state, correctRoom, idx):
    echo "move to open bottom pos in correct room"
  elif state.grid.rooms[correctRoom][0] == '.' and state.grid.rooms[correctRoom][1] == state.grid.hallway[idx] and canMoveToRoom(state, correctRoom, idx):
    echo "move to open top pos in correct room"

proc moves(state: State): seq[State] =
  for idx, _ in state.grid.rooms:
    result.add moveFromRoom(state, idx)

  for idx, _ in state.grid.hallway:
    result.add moveFromHallway(state, idx)

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
