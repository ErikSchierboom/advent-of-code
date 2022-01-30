import helpers, std/[algorithm, heapqueue, sequtils, strutils, strformat, tables]

type 
  Grid = tuple[hallway, rooms: string, roomSize: int]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

func isHallwayClear(grid: Grid, a, b: int): bool =
  grid.hallway[min(a, b) .. max(a, b)].allIt(it == '0')

func room(grid: Grid, num: int): string = 
  let roomIdx = num * grid.roomSize
  grid.rooms[roomIdx ..< roomIdx + grid.roomSize]

func room(grid: Grid, amphipod: char): string =
  grid.room(amphipods.find(amphipod))

proc moves(state: State): seq[State] =
  echo "moves"
  for roomNum, amphipod in amphipods:
    let room = state.grid.room(roomNum)
    if room.allIt(it == amphipod):
      echo "room is organized"
      continue
    else:
      for y in 0..<state.grid.roomSize:
        if room[y] == '.':
          continue
        else:
          # Move to hallway

  
    


# func moves(a: char, p: Point, state: State): seq[Point] =
#   if p.y == 1: # Hallway
#     if state.roomYs.anyIt(state.grid.getOrDefault((x: rooms[a], y: it), a) != a): return @[]
#     let
#       x = if p.x < rooms[a]: p.x + 1 else: p.x - 1
#       y = state.roomYs.toSeq.filterIt((x: rooms[a], y: it) notin state.grid).max
#     return @[(rooms[a], y)].filterIt(x.isHallwayClear(rooms[a], state.grid))
#   # Room correct

#   if (x: p.x, y: p.y - 1) in state.grid: # Top of room not empty
#     @[]
#   else:
#     [1, 2, 4, 6, 8, 10, 11].filterIt(p.x.isHallwayClear(it, state.grid)).mapIt((it, 1))

# TODO: compare using total costs using manhattan distance
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
  result.grid.hallway = "......."

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
