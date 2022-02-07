import helpers, std/[heapqueue, math, sequtils, strutils, tables]

type 
  Grid = tuple[hallway: array[7, int], rooms: array[4, seq[int]]]
  State = tuple[grid: Grid, energy: int]

const rooms = [2, 4, 6, 8]
const hallway = [0, 1, 3, 5, 7, 9, 10]
const empty = -1

func cost(amphipod: int): int = 10 ^ amphipod

func hallwayClear(grid: Grid, a, b: int): bool =
  hallway.filterIt(it in min(a, b)..max(a, b)).allIt(grid.hallway[hallway.find(it)] == empty)

func move(state: State, amphipod, hallwayIdx, roomIdx, levelIdx: int): State = 
  result = state
  swap(result.grid.hallway[hallwayIdx], result.grid.rooms[roomIdx][levelIdx])
  inc result.energy, amphipod.cost * (abs(hallway[hallwayIdx] - rooms[roomIdx]) + 1 + levelIdx)

iterator movesFromHallway(state: State): State =
   for i, a in state.grid.hallway:
    if a == empty:
      continue

    let x = hallway[i]

    let room = state.grid.rooms[a]
    if room.anyIt(it != empty and it != a):
      continue

    let xx = if x < rooms[a]: x + 1 else: x - 1
    if not state.grid.hallwayClear(xx, rooms[a]):
      continue

    let y = toSeq(room.low..room.high).filterIt(room[it] == empty).max
    yield move(state, a, i, a, y)

iterator movesFromRooms(state: State): State =
  for i, room in state.grid.rooms:
    if room.allIt(it == i):
      continue

    for y, a in room:
      if a == empty:
        continue
      elif y == room.high and a == i:
        break

      for j, x in hallway:
        if not state.grid.hallwayClear(x, rooms[i]):
          continue

        yield move(state, a, j, i, y)
      break

iterator moves(state: State): State =
  for move in state.movesFromHallway: yield move
  for move in state.movesFromRooms: yield move

func toOrganized(state: State): Grid =
  for i, _ in state.grid.hallway:
    result.hallway[i] = -1

  for j, room in state.grid.rooms:
    for _ in room:
      result.rooms[j].add j

func `<`(a: State, b: State): bool = a.energy < b.energy

proc solve(state: State): int =
  let organized = state.toOrganized

  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[Grid]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid == organized:
      return current.energy

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for cell in result.grid.hallway.mitems:
    cell = -1

  for i, x in rooms:
    for y in 2 ..< lines.high:
      result.grid.rooms[i].add "ABCD".find(lines[y][x + 1])

proc part1*: int = 
  let lines = readInputStrings(day = 23).toSeq
  solve(readInputState(lines))

proc part2*: int = 
  var lines = readInputStrings(day = 23).toSeq
  lines.insert(@["  #D#C#B#A#  ", "  #D#B#A#C#  "], pos = 3)
  solve(readInputState(lines))

proc solveDay23*: IntSolution =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay23()
