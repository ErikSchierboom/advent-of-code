import helpers, std/[heapqueue, options, sequtils, strformat, tables]

type 
  Grid = Table[Point, char]
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
  for x in hallwayXs:
    result.add grid.getOrDefault((x: x, y: 1), '.')
  result.add "#\n###"
  for x in roomXs:
    result.add grid.getOrDefault((x: x, y: 2), '.')
    result.add '#'
  result.add "##\n  #"
  for x in roomXs:
    result.add grid.getOrDefault((x: x, y: 3), '.')
    result.add '#'
  result.add "\n  #########  "

func `$`(state: State): string =
  result.add "Energy: " & $state.energy
  result.add '\n'
  result.add $state.grid
  result.add '\n'

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  for y in 0..lines.high:
    for x in 0..lines[y].high:
      if lines[y][x] in amphipods:
        result.grid.add((x: x, y: y), lines[y][x])

func inCorrectRoom(point: Point, kind: char): bool = amphipods.find(kind) == [3, 5, 7, 9].find(point.x)
func inTopOfRoom(point: Point): bool = point.y == roomYs[0]
func inBottomOfRoom(point: Point): bool = point.y == roomYs[1]
func organized(grid: Grid): bool = grid.pairs.toSeq.allIt(inCorrectRoom(it[0], it[1]))

proc move(point: Point, kind: char, state: State): seq[State] =
  echo &"move point {point}, kind{kind}"

  if inCorrectRoom(point, kind) and inBottomOfRoom(point):
      echo &"move point {point}, kind{kind}: correct room at bottom position"
  elif not inCorrectRoom(point, kind) and inBottomOfRoom(point):

    else:
      let topRoomPoint = (x: point.x, y: roomYs[0])
      if topRoomPoint in state.grid:
      else:
        echo &"move point {point}, kind{kind}: correct room at top position with empty bottom position"

proc moves(state: State): seq[State] =
  for point, kind in state.grid:
    result.add move(point, kind, state)

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
