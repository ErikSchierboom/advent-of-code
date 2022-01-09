import helpers, std/[heapqueue, options, sequtils, tables]

type
  Grid = tuple[hallway: array[11, char], rooms: array[4, array[2, char]]]
  State = tuple[grid: Grid, energy: int]

const roomType = "ABCD"
const moveCost = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

proc `<` (a, b: State): bool = a.energy < b.energy

func `$`(grid: Grid): string =
  result.add "#############\n"
  result.add "#"
  for cell in grid.hallway:
    result.add cell
  result.add "#\n"
  result.add "###"
  result.add grid.rooms[0][0]
  result.add '#'
  result.add grid.rooms[1][0]
  result.add '#'
  result.add grid.rooms[2][0]
  result.add '#'
  result.add grid.rooms[3][0]
  result.add "###\n"
  result.add "  #"
  result.add grid.rooms[0][1]
  result.add '#'
  result.add grid.rooms[1][1]
  result.add '#'
  result.add grid.rooms[2][1]
  result.add '#'
  result.add grid.rooms[3][1]
  result.add "#\n"
  result.add "  #########  "

func `$`(state: State): string =
  result.add "Energy: " & $state.energy
  result.add '\n'
  result.add $state.grid
  result.add '\n'

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  
  for cell in result.grid.hallway.mitems:
    cell = '.'

  result.grid.rooms[0][0] = lines[2][3]
  result.grid.rooms[0][1] = lines[3][3]
  result.grid.rooms[1][0] = lines[2][5]
  result.grid.rooms[1][1] = lines[3][5]
  result.grid.rooms[2][0] = lines[2][7]
  result.grid.rooms[2][1] = lines[3][7]
  result.grid.rooms[3][0] = lines[2][9]
  result.grid.rooms[3][1] = lines[3][9]

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
      # result.add newState

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
      # result.add newState

func canMoveBetweenRooms(state: State, room1, room2: int): bool =
  for x in min(room1.roomToHallwayIdx, room2.roomToHallwayIdx)..max(room1.roomToHallwayIdx, room2.roomToHallwayIdx):
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
    if state.grid.rooms[correctRoom][1] == '.' and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to open pos in correct room"
    else:
      result.add moveToHallway(state, idx, 0)
  elif state.grid.rooms[idx][1] != '.':
    let correctRoom = roomType.find(state.grid.rooms[idx][0])
    echo "move from room " & $idx & ": bottom is incorrect"
    if state.grid.rooms[correctRoom][1] == '.' and canMoveBetweenRooms(state, correctRoom, idx):
      echo "move to open pos in correct room"
    else:
      result.add moveToHallway(state, idx, 1)
  else:
    echo "move from room " & $idx & ": empty room"

proc moveFromHallway(state: State, idx: int): seq[State] =
  echo "move from hallway " & $idx

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
      echo move
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc solveDay23*: IntSolution =
  let state = readInputState()
  echo state.grid.organized
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()

# const kinds = "ABCD"
# const kindCost = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
# const roomsY = [2, 3]
# const roomsX = [3, 5, 7, 9]
# const hallwayX = [1, 2, 4, 6, 8, 10, 11]
# const hallwayY = 1

# proc `<` (a, b: State): bool = a.energy < b.energy

# func `$`(amphipods: Amphipods): string =
#   result.add "\n#############\n"
#   result.add "#"
#   for x in 1..11:
#     result.add amphipods.getOrDefault((x: x, y: hallwayY), '.')
#   result.add "#\n"
#   result.add "###"
#   for x in roomsX:
#     result.add amphipods.getOrDefault((x: x, y: roomsY[0]), '.')
#     result.add "#"
#   result.add "##\n"
#   result.add "  #"
#   for x in roomsX:
#     result.add amphipods.getOrDefault((x: x, y: roomsY[1]), '.')
#     result.add "#"
#   result.add "\n"
#   result.add "  #########  "

# proc readInputState: State =
#   let lines = readInputStrings(day = 23).toSeq
  
#   for y in roomsY:
#     for x in roomsX:
#       result.amphipods[(x: x, y: y)] = lines[y][x]

# func room(point: Point): int =
#   if point.y in roomsY: roomsX.find(point.x) else: -1
# func inRoom(point: Point): bool = room(point) != -1
# func inCorrectRoom(point: Point, kind: char): bool = room(point) == kinds.find(kind)
# func inTopOfRoom(point: Point): bool = point.y == roomsY[0]
# func inBottomOfRoom(point: Point): bool = point.y == roomsY[1]

# func organized(amphipods: Amphipods): bool =
#   for point, kind in amphipods:
#     if not inCorrectRoom(point, kind):
#       return false

#   result = true

# proc moves(state: State): seq[State] =
#   for point, kind in state.amphipods:
#     if inRoom(point):
#       if inCorrectRoom(point, kind):
#         if inTopOfRoom(point):
#           let bottomOfRoomPoint = (x: point.x, y: point.y + 1)
#           if bottomOfRoomPoint in state.amphipods:
#             if state.amphipods[bottomOfRoomPoint] == kind:
#               echo $point & "," & $kind & ": in correct room at top with same kind at bottom"
#             else:
#               echo $point & "," & $kind & ": in correct room at top with different kind at bottom"

#               for x in hallwayX:
#                 if x < point.x:
#                   for x1 in x + 1 .. point.x:
#                     if (x: x1, y: hallwayY) in state.amphipods:
#                       continue
#                 else:
#                   for x1 in point.x .. x - 1:
#                     if (x: x1, y: hallwayY) in state.amphipods:
#                       continue

#                 let moves = abs(point.x - x) + 1
#                 var newState = state
#                 inc newState.energy, (kindCost[kind] * moves)
#                 newState.amphipods.del(point)
#                 newState.amphipods[(x: x, y: hallwayY)] = kind
#                 result.add newState
#           else:
#             echo $point & "," & $kind & ": in correct room at top with bottom empty"
#             var newState = state
#             inc newState.energy, kindCost[kind]
#             newState.amphipods.del(point)
#             newState.amphipods[(x: point.x, y: point.y + 1)] = kind
#             result.add newState
#         else:
#           echo $point & "," & $kind & ": in correct room at bottom"
#       else:
#         if inTopOfRoom(point):
#           echo $point & "," & $kind & ": in wrong room at top"

#           for x in hallwayX:
#             if x < point.x:
#               for x1 in x + 1 .. point.x:
#                 if (x: x1, y: hallwayY) in state.amphipods:
#                   continue
#             else:
#               for x1 in point.x .. x - 1:
#                 if (x: x1, y: hallwayY) in state.amphipods:
#                   continue

#             let moves = abs(point.x - x) + 1
#             var newState = state
#             inc newState.energy, (kindCost[kind] * moves)
#             newState.amphipods.del(point)
#             newState.amphipods[(x: x, y: hallwayY)] = kind
#             result.add newState
#         else:
#           let topOfRoomPoint = (x: point.x, y: point.y - 1)
#           if topOfRoomPoint in state.amphipods:
#             echo $point & "," & $kind & ": in wrong room at bottom and top blocked"
#           else:
#             echo $point & "," & $kind & ": in wrong room at bottom and no top"

#             for x in hallwayX:
#                 if x < point.x:
#                   for x1 in x + 1 .. point.x:
#                     if (x: x1, y: hallwayY) in state.amphipods:
#                       continue
#                 else:
#                   for x1 in point.x .. x - 1:
#                     if (x: x1, y: hallwayY) in state.amphipods:
#                       continue

#                 let moves = abs(point.x - x) + 2
#                 var newState = state
#                 inc newState.energy, (kindCost[kind] * moves)
#                 newState.amphipods.del(point)
#                 newState.amphipods[(x: x, y: hallwayY)] = kind
#                 result.add newState
#     else:
#       let room = kinds.find(kind)
#       let topRoomPos = (x: roomsX[room], y: roomsY[0])
#       let bottomRoomPos = (x: roomsX[room], y: roomsY[0])

#       if bottomRoomPos notin state.amphipods and topRoomPos notin state.amphipods:
#         echo $point & "," & $kind & ": in hallway and correct room has both spots empty"

#         if bottomRoomPos.x < point.x:
#           for x1 in bottomRoomPos.x + 1 .. point.x:
#             if (x: x1, y: hallwayY) in state.amphipods:
#               continue
#         else:
#           for x1 in point.x .. bottomRoomPos.x - 1:
#             if (x: x1, y: hallwayY) in state.amphipods:
#               continue

#         let moves = abs(point.x - bottomRoomPos.x) + 2
#         var newState = state
#         inc newState.energy, (kindCost[kind] * moves)
#         newState.amphipods.del(point)
#         newState.amphipods[(x: bottomRoomPos.x, y: bottomRoomPos.y)] = kind
#         result.add newState

#       elif bottomRoomPos notin state.amphipods and topRoomPos in state.amphipods:
#         echo $point & "," & $kind & ": in hallway and correct room has top spot occupied"
#       elif bottomRoomPos in state.amphipods and topRoomPos notin state.amphipods:
#         if state.amphipods[bottomRoomPos] == kind:
#           echo $point & "," & $kind & ": in hallway and correct room has top spot empty and bottom spot of same kind"

#           if topRoomPos.x < point.x:
#             for x1 in topRoomPos.x + 1 .. point.x:
#               if (x: x1, y: hallwayY) in state.amphipods:
#                 continue
#           else:
#             for x1 in point.x .. topRoomPos.x - 1:
#               if (x: x1, y: hallwayY) in state.amphipods:
#                 continue

#           let moves = abs(point.x - topRoomPos.x) + 1
#           var newState = state
#           inc newState.energy, (kindCost[kind] * moves)
#           newState.amphipods.del(point)
#           newState.amphipods[(x: topRoomPos.x, y: topRoomPos.y)] = kind
#           result.add newState

#         else:
#           echo $point & "," & $kind & ": in hallway and correct room has top spot empty and bottom spot of different kind"
#       elif bottomRoomPos in state.amphipods and topRoomPos in state.amphipods:
#         echo $point & "," & $kind & ": in hallway and correct room has both spots occupied"

# proc part1(state: State): int =
#   var queue: HeapQueue[State]
#   var energyCounts = initCountTable[string]()

#   energyCounts[$state.amphipods] = 0  
#   queue.push state

#   echo energyCounts
  
#   while queue.len > 0:
#     let current = queue.pop()

#     if current.amphipods.organized:
#       echo "organized"
#       echo current.amphipods
#       return current.energy

#     if current.energy > energyCounts.getOrDefault($current.amphipods, high(int)):
#       continue

#     for move in current.moves:
#       echo move
#       if move.energy < energyCounts.getOrDefault($move.amphipods, high(int)):
#         queue.push move
#         energyCounts[$move.amphipods] = move.energy

# proc solveDay23*: IntSolution =
#   let state = readInputState()
#   result.part1 = part1(state)

# when isMainModule:
#   echo solveDay23()
