import helpers, std/[heapqueue, options, sequtils, tables]

type
  Amphipods = Table[Point, char]
  State = tuple[amphipods: Amphipods, energy: int]

const kinds = "ABCD"
const kindCost = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
const roomsY = [2, 3]
const roomsX = [3, 5, 7, 9]
const hallwayX = [1, 2, 4, 6, 8, 10, 11]
const hallwayY = 1

proc `<` (a, b: State): bool = a.energy < b.energy

func `$`(amphipods: Amphipods): string =
  result.add "\n#############\n"
  result.add "#"
  for x in 1..11:
    result.add amphipods.getOrDefault((x: x, y: hallwayY), '.')
  result.add "#\n"
  result.add "###"
  for x in roomsX:
    result.add amphipods.getOrDefault((x: x, y: roomsY[0]), '.')
    result.add "#"
  result.add "##\n"
  result.add "  #"
  for x in roomsX:
    result.add amphipods.getOrDefault((x: x, y: roomsY[1]), '.')
    result.add "#"
  result.add "\n"
  result.add "  #########  "

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  
  for y in roomsY:
    for x in roomsX:
      result.amphipods[(x: x, y: y)] = lines[y][x]

func room(point: Point): int =
  if point.y in roomsY: roomsX.find(point.x) else: -1
func inRoom(point: Point): bool = room(point) != -1
func inCorrectRoom(point: Point, kind: char): bool = room(point) == kinds.find(kind)
func inTopOfRoom(point: Point): bool = point.y == roomsY[0]
func inBottomOfRoom(point: Point): bool = point.y == roomsY[1]

func organized(amphipods: Amphipods): bool =
  for point, kind in amphipods:
    if not inCorrectRoom(point, kind):
      return false

  result = true

proc moves(state: State): seq[State] =
  for point, kind in state.amphipods:
    if inRoom(point):
      if inCorrectRoom(point, kind):
        if inTopOfRoom(point):
          let bottomOfRoomPoint = (x: point.x, y: point.y + 1)
          if bottomOfRoomPoint in state.amphipods:
            if state.amphipods[bottomOfRoomPoint] == kind:
              echo $point & "," & $kind & ": in correct room at top with same kind at bottom"
            else:
              echo $point & "," & $kind & ": in correct room at top with different kind at bottom"

              for x in hallwayX:
                if x < point.x:
                  for x1 in x + 1 .. point.x:
                    if (x: x1, y: hallwayY) in state.amphipods:
                      continue
                else:
                  for x1 in point.x .. x - 1:
                    if (x: x1, y: hallwayY) in state.amphipods:
                      continue

                let moves = abs(point.x - x) + 1
                var newState = state
                inc newState.energy, (kindCost[kind] * moves)
                newState.amphipods.del(point)
                newState.amphipods[(x: x, y: hallwayY)] = kind
                result.add newState
          else:
            echo $point & "," & $kind & ": in correct room at top with bottom empty"
            var newState = state
            inc newState.energy, kindCost[kind]
            newState.amphipods.del(point)
            newState.amphipods[(x: point.x, y: point.y + 1)] = kind
            result.add newState
        else:
          echo $point & "," & $kind & ": in correct room at bottom"
      else:
        if inTopOfRoom(point):
          echo $point & "," & $kind & ": in wrong room at top"

          for x in hallwayX:
            if x < point.x:
              for x1 in x + 1 .. point.x:
                if (x: x1, y: hallwayY) in state.amphipods:
                  continue
            else:
              for x1 in point.x .. x - 1:
                if (x: x1, y: hallwayY) in state.amphipods:
                  continue

            let moves = abs(point.x - x) + 1
            var newState = state
            inc newState.energy, (kindCost[kind] * moves)
            newState.amphipods.del(point)
            newState.amphipods[(x: x, y: hallwayY)] = kind
            result.add newState
        else:
          let topOfRoomPoint = (x: point.x, y: point.y - 1)
          if topOfRoomPoint in state.amphipods:
            echo $point & "," & $kind & ": in wrong room at bottom and top blocked"
          else:
            echo $point & "," & $kind & ": in wrong room at bottom and no top"

            for x in hallwayX:
                if x < point.x:
                  for x1 in x + 1 .. point.x:
                    if (x: x1, y: hallwayY) in state.amphipods:
                      continue
                else:
                  for x1 in point.x .. x - 1:
                    if (x: x1, y: hallwayY) in state.amphipods:
                      continue

                let moves = abs(point.x - x) + 2
                var newState = state
                inc newState.energy, (kindCost[kind] * moves)
                newState.amphipods.del(point)
                newState.amphipods[(x: x, y: hallwayY)] = kind
                result.add newState
    else:
      let room = kinds.find(kind)
      let topRoomPos = (x: roomsX[room], y: roomsY[0])
      let bottomRoomPos = (x: roomsX[room], y: roomsY[0])

      if bottomRoomPos notin state.amphipods and topRoomPos notin state.amphipods:
        echo $point & "," & $kind & ": in hallway and correct room has both spots empty"
      elif bottomRoomPos notin state.amphipods and topRoomPos in state.amphipods:
        echo $point & "," & $kind & ": in hallway and correct room has top spot occupied"
      elif bottomRoomPos in state.amphipods and topRoomPos notin state.amphipods:
        if state.amphipods[bottomRoomPos] == kind:
          echo $point & "," & $kind & ": in hallway and correct room has top spot empty and bottom spot of same kind"
        else:
          echo $point & "," & $kind & ": in hallway and correct room has top spot empty and bottom spot of different kind"
      elif bottomRoomPos in state.amphipods and topRoomPos in state.amphipods:
        echo $point & "," & $kind & ": in hallway and correct room has both spots occupied"

proc part1(state: State): int =
  var queue: HeapQueue[State]
  var energyCounts = initCountTable[string]()

  energyCounts[$state.amphipods] = 0  
  queue.push state

  echo energyCounts
  
  while queue.len > 0:
    let current = queue.pop()

    if current.amphipods.organized:
      echo "organized"
      return current.energy

    if current.energy > energyCounts.getOrDefault($current.amphipods, high(int)):
      echo "too much energey"
      continue

    for move in current.moves:
      echo move
      echo energyCounts.getOrDefault($move.amphipods, high(int))
      if move.energy < energyCounts.getOrDefault($move.amphipods, high(int)):
        echo "new energy"
        queue.push move
        energyCounts[$move.amphipods] = move.energy

proc solveDay23*: IntSolution =
  let state = readInputState()
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()
