import helpers, std/[heapqueue, options, sequtils, tables]

type
  Grid = tuple[hallway: array[11, char], rooms: array[4, array[2, char]]]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const energyCost = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

proc `<` (a, b: State): bool = a.energy < b.energy

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq

  for i in result.grid.hallway.low .. result.grid.hallway.high:
    result.grid.hallway[i] = '.'

  for i in 0..3:
    result.grid.rooms[i][0] = lines[2][3 + i * 2]
    result.grid.rooms[i][1] = lines[3][3 + i * 2]

func organized(grid: Grid): bool =
  grid.rooms[0][0] == 'A' and grid.rooms[0][1] == 'A' and
  grid.rooms[1][0] == 'B' and grid.rooms[1][1] == 'B' and
  grid.rooms[2][0] == 'C' and grid.rooms[2][1] == 'C' and
  grid.rooms[3][0] == 'D' and grid.rooms[3][1] == 'D'

proc moves(state: State): seq[State] =
  for room in state.grid.rooms.low .. state.grid.rooms.high:
    # Top position in room is amphipod
    if state.grid.rooms[room][0] in amphipods:
      # Amphipod in wrong room
      if amphipods[room] != state.grid.rooms[room][0]:
        echo $room & ":top amphipod in wrong room"
      # Amphipod blocking other amphipod
      elif amphipods[room] != state.grid.rooms[room][1]:
        echo $room & ":top amphipod blocking room"
      else:
        echo $room & ":top amphipod in correct room"

    # Bottom position in room is amphipod
    if state.grid.rooms[room][1] in amphipods:
      # Amphipod in wrong room
      if amphipods[room] != state.grid.rooms[room][1]:
        if state.grid.rooms[room][0] in amphipods:
          echo $room & ":bottom amphipod in wrong room and blocked"
        else:
          echo $room & ":bottom amphipod in wrong room and unblocked"
      else:
        echo $room & ":bottom amphipod in correct room"

proc part1(state: State): int =
  var queue: HeapQueue[State]
  var energyCounts = initCountTable[Grid]()

  energyCounts[state.grid] = 0  
  queue.push state
  
  while queue.len > 0:
    let current = queue.pop()

    if current.grid.organized:
      return current.energy

    if current.energy > energyCounts[current.grid]:
      continue

    for move in state.moves:
      if move.energy < energyCounts[move.grid]:
        queue.push move
        energyCounts[move.grid] = move.energy

proc solveDay23*: IntSolution =
  let state = readInputState()
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()
