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

func organized(room: Room, idx: int): bool {.inline.} =
  room.top == amphipods[idx] and room.bottom == amphipods[idx]

func organized(grid: Grid): bool {.inline.} =
  for idx, room in grid.rooms:
    if not room.organized(idx):
      return false
  
  true

func empty(room: Room): bool {.inline.} = room.top == '.' and room.bottom == '.'

func roomIdxToHallwayIdxAboveRoom(roomIdx: int): int = (roomIdx * 2 + 3) - 1

proc hallwayToRoomIsEmpty(state: State, hallwayIdx1, hallwayIdx2: int): bool =
  for x in min(hallwayIdx1, hallwayIdx2)..max(hallwayIdx1, hallwayIdx2):
    if state.grid.hallway[x] != '.':
      return false

  true

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
    if hallwayToRoomIsEmpty(state, roomIdxToHallwayIdxAboveRoom(roomIdx), idx):
      echo &"hallway {idx}: target room {roomIdx} has bottom correct and hallway is empty"
    else:
      echo &"hallway {idx}: target room {roomIdx} has bottom correct and hallway is blocked"
  elif room.bottom == '.':
    if hallwayToRoomIsEmpty(state, roomIdx, idx):
      echo &"hallway {idx}: target room {roomIdx} has bottom empty and hallway is empty"
    else:
      echo &"hallway {idx}: target room {roomIdx} has bottom empty and hallway is blocked"
  else:
    echo &"hallway {idx}: target room {roomIdx} has bottom incorrect"

proc movesFromTopOfRoom(state: State, idx: int): seq[State] =
  let room = state.grid.rooms[idx]
  let correctRoomIdx = amphipods.find(room.top)
  if idx == correctRoomIdx:
    if room.bottom == '.':
      echo &"room {idx}: top is correct and can move directly to bottom of room"
    else:
      echo &"room {idx}: top is correct but blocking incorrect bottom of room"
  else:
    if hallwayToRoomIsEmpty(state, roomIdxToHallwayIdxAboveRoom(idx), roomIdxToHallwayIdxAboveRoom(correctRoomIdx)):
      let correctRoom = state.grid.rooms[correctRoomIdx]
      if correctRoom.empty:
        echo &"room {idx}: top is not correct but can move directly to correct room that is empty"
      elif correctRoom.top == '.' and correctRoom.bottom == room.top:
        echo &"room {idx}: top is not correct but can move directly to correct room which bottom is correct"
      else:
        echo &"room {idx}: top is not correct and can't move directly to correct room due to room taken"
    else:
      echo &"room {idx}: top is not correct and can't move directly to correct room due to hallway closed"

proc movesFromBottomOfRoom(state: State, idx: int): seq[State] =
  let room = state.grid.rooms[idx]

  if room.bottom == amphipods[idx]:
     echo &"room {idx}: bottom is correct"
  else:
    let correctRoomIdx = amphipods.find(room.bottom)
    if room.top != '.':
      echo &"room {idx}: bottom is incorrect but can't move directly to correct room due to blocked top"
    elif hallwayToRoomIsEmpty(state, roomIdxToHallwayIdxAboveRoom(idx), roomIdxToHallwayIdxAboveRoom(correctRoomIdx)):
      echo &"room {idx}: bottom is incorrect but can move directly to correct room"
    else:
      echo &"room {idx}: bottom is incorrect but can't move directly to correct room due to blocked hallway"

proc movesFromRoom(state: State, idx: int): seq[State] =
  if state.grid.rooms[idx].empty:
    echo &"room {idx}: top and bottom are empty"
  elif state.grid.rooms[idx].organized(idx):
    echo &"room {idx}: top and bottom are correct"
  elif state.grid.rooms[idx].top == '.':
    result.add movesFromBottomOfRoom(state, idx)
  else:
    result.add movesFromTopOfRoom(state, idx)

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
