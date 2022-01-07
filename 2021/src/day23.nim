import helpers, std/[heapqueue, options, sequtils, tables]

type
  Amphipods = Table[Point, char]
  State = tuple[amphipods: Amphipods, energy: int]

const kinds = "ABCD"
const kindCost = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

proc `<` (a, b: State): bool = a.energy < b.energy

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  
  for y in 2..3:
    for x in [3, 5, 7, 9]:
      result.amphipods[(x: x, y: y)] = lines[y][x]

# func room(amphipod: Amphipod): int = amphipod.pos.x.succ div 3
# func correctRoom(amphipod: Amphipod): int = rooms.find(amphipod.kind) + 1
# func inRoom(amphipod: Amphipod): bool = amphipod.pos.y in 2..3
# func inCorrectRoom(amphipod: Amphipod): bool = amphipod.inRoom and amphipod.room == amphipod.correctRoom

func organized(amphipods: Amphipods): bool =
  for room in 0..3:
    if amphipods.getOrDefault((x: 2 * (room + 1) + 1, y: 2)) != kinds[room] or
       amphipods.getOrDefault((x: 2 * (room + 1) + 1, y: 3)) != kinds[room]:
      return false

  result = true

func tryMoveToHallway(state: State, room, hallway: int): Option[State] =
  return
  # # Can't move to occupied place
  # if state.amphipods.hallway[hallway] in amphipods:
  #   return

  # # Can't move to hallway above room
  # if hallway in {2, 4, 6, 8}:
  #   return

  # # Can't move due to being blocked
  # if room >= 4 and state.amphipods.rooms[room - 4] in amphipods:
  #   return

  # if room mod 4 > hallway:
  #   for x in room mod 4 .. hallway:
  #     # Occupied
  #     if state.amphipods.hallway[x] in amphipods:
  #       return
  # else:
  #   for x in hallway .. room mod 4:
  #     # Occupied
  #     if state.amphipods.hallway[x] in amphipods:
  #       return

proc moves(state: State): seq[State] =
  # for room in 0..3:
  #   # Top position in room is amphipod
  #   if state.amphipods.rooms[room] in amphipods:
  #     # Amphipod in wrong room
  #     if amphipods[room] != state.amphipods.rooms[room]:
  #       echo $room & ":top amphipod in wrong room"

  #       # for tile in state.amphipods.hallway.low .. state.amphipods.hallway.high:
  #       #   if state.amphipods.hallway[tile] notin amphipods:
  #     # Amphipod blocking other amphipod
  #     elif amphipods[room] != state.amphipods.rooms[room + 4]:
  #       echo $room & ":top amphipod blocking room"
  #     else:
  #       echo $room & ":top amphipod in correct room"

  #   # Bottom position in room is amphipod
  #   if state.amphipods.rooms[room + 4] in amphipods:
  #     # Amphipod in wrong room
  #     if amphipods[room mod 4] != state.amphipods.rooms[room + 4]:
  #       if state.amphipods.rooms[room mod 4] in amphipods:
  #         echo $room & ":bottom amphipod in wrong room and blocked"
  #       else:
  #         echo $room & ":bottom amphipod in wrong room and unblocked"
  #     else:
  #       echo $room & ":bottom amphipod in correct room"

proc part1(state: State): int =
  var queue: HeapQueue[State]
  var energyCounts = initCountTable[Amphipods]()

  energyCounts[state.amphipods] = 0  
  queue.push state
  
  while queue.len > 0:
    let current = queue.pop()

    if current.amphipods.organized:
      return current.energy

    if current.energy > energyCounts[current.amphipods]:
      continue

    for move in state.moves:
      if move.energy < energyCounts[move.amphipods]:
        queue.push move
        energyCounts[move.amphipods] = move.energy

proc solveDay23*: IntSolution =
  let state = readInputState()
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()
