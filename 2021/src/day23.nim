import helpers, std/[heapqueue, sequtils, strutils, tables]

type 
  Grid = tuple[hallway, rooms: string, roomSize: int]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
const hallwayX = [1, 2, 4, 6, 8, 10, 11]
const roomX = [3, 5, 7, 9]

func distance(grid: Grid, amphipod: char, hallwayIdx, roomNum, roomIdx: int): int =
  abs(roomX[roomNum] - hallwayX[hallwayIdx]) + abs(1 - (roomIdx + 2))

func cost(grid: Grid, amphipod: char, hallwayIdx, roomNum, roomIdx: int): int =
  grid.distance(amphipod, hallwayIdx, roomNum, roomIdx) * costs[amphipod]

func isHallwayClear(grid: Grid, roomNum, hallwayIdx: int): bool =
  (min(hallwayIdx + 1, roomNum + 2) .. max(roomNum + 1, hallwayIdx - 1)).toSeq.allIt(grid.hallway[it] == '.')

func room(grid: Grid, num: int): string = 
  let roomIdx = num * grid.roomSize
  grid.rooms[roomIdx ..< roomIdx + grid.roomSize]

func room(grid: Grid, amphipod: char): string =
  grid.room(amphipods.find(amphipod))

proc moves(state: State): seq[State] =
  for hallwayIdx, cell in state.grid.hallway:
    if cell == '.':
      continue

    let room = state.grid.room(cell)
    if room.anyIt(it != cell and it != '.'):
      continue

    let roomNum = amphipods.find(cell)
    let roomIdx = room.rfind('.')
    if state.grid.isHallwayClear(roomNum, hallwayIdx):
      var newState = state
      inc newState.energy, state.grid.cost(cell, hallwayIdx, roomNum, roomIdx)
      newState.grid.hallway[hallwayIdx] = '.'
      newState.grid.rooms[roomNum * state.grid.roomSize + roomIdx] = cell
      result.add newState

  for roomNum, amphipod in amphipods:
    let room = state.grid.room(roomNum)
    if room.allIt(it == amphipod):
      continue
    else:
      for y in 0..<state.grid.roomSize:
        if room[y] == '.':
          continue
        else:
          for hallwayIdx in (state.grid.hallway.low .. state.grid.hallway.high).toSeq.filterIt(state.grid.isHallwayClear(roomNum, it)):
            var newState = state
            inc newState.energy, state.grid.cost(state.grid.rooms[roomNum * state.grid.roomSize + y], hallwayIdx, roomNum, y)
            newState.grid.hallway[hallwayIdx] = state.grid.rooms[roomNum * state.grid.roomSize + y]
            newState.grid.rooms[roomNum * state.grid.roomSize + y] = '.'
            result.add newState
          break

func `<`(a: State, b: State): bool = a.energy < b.energy

proc solve(state: State, goal: Grid): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var costs: CountTable[Grid]
  costs[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid == goal:
      return current.energy

    for move in current.moves:
      if move.energy < costs.getOrDefault(move.grid, high(int)):
        queue.push move
        costs[move.grid] = move.energy

func initState(lines: seq[string], roomSize: int): State =
  for x in 0 ..< 4: # Rooms
    for y in 0 ..< lines.len - 3:
      result.grid.rooms.add lines[2 + y][3 + x * 2]

  result.grid.roomSize = roomSize

  for x in [1, 2, 4, 6, 8, 10, 11]: # Hallway
    result.grid.hallway.add lines[1][x]

func initGoalGrid(roomSize: int): Grid =
  for amphipod in amphipods:
    for y in 0 ..< roomSize:
      result.rooms.add amphipod

  result.roomSize = roomSize
  result.hallway = "......."

proc part1*(lines: seq[string]): int = 
  solve(initState(lines, roomSize = 2), initGoalGrid(roomSize = 2))

proc part2*(lines: seq[string]): int = 
  var lines = lines
  lines.insert(@["  #D#C#B#A#  ", "  #D#B#A#C#  "], pos = 3)
  solve(initState(lines, roomSize = 4), initGoalGrid(roomSize = 4))

proc solveDay23*: IntSolution =
  var lines = readInputStrings(day = 23).toSeq
  result.part1 = part1(lines)
  result.part2 = part2(lines)

when isMainModule:
  echo solveDay23()
