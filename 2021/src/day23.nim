import helpers, std/[heapqueue, math, sequtils, strutils, tables]

type 
  Grid = tuple[hallway: seq[int], rooms: array[4, seq[int]]]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const rooms = [2, 4, 6, 8]
const hallway = [0, 1, 3, 5, 7, 9, 10]

func cost(amphipod: int): int = 10 ^ amphipod
func isOrganized(grid: Grid, i: int): bool = grid.rooms[i].allIt(it == i)
func isOrganized(grid: Grid): bool = toSeq(0..grid.rooms.high).allIt(grid.isOrganized(it))
func hallwayClear(grid: Grid, a, b: int): bool = toSeq(min(a, b)..max(a, b)).allIt(grid.hallway[it] == -1)

func move(state: State, amphipod, hallway, room, level: int): State = 
  result = state
  swap(result.grid.hallway[hallway], result.grid.rooms[room][level])
  inc result.energy, amphipod.cost * (abs(hallway - rooms[room]) + 1 + level)

iterator moves(state: State): State =
  for x in hallway:
    let a = state.grid.hallway[x]
    if a == -1:
      continue

    let room = state.grid.rooms[a]
    if room.anyIt(it != -1 and it != a):
      continue

    let xx = if x < rooms[a]: x + 1 else: x - 1
    if not state.grid.hallwayClear(xx, rooms[a]):
      continue

    let y = toSeq(room.low..room.high).filterIt(room[it] == -1).max
    yield move(state, a, x, a, y)

  for i, room in state.grid.rooms:
    if state.grid.isOrganized(i):
      continue

    for y, a in room:
      if a == -1:
        continue
      elif y == room.high and a == i:
        break

      for x in hallway:
        if x in rooms or not state.grid.hallwayClear(x, rooms[i]):
          continue

        yield move(state, a, x, i, y)
      break

func `<`(a: State, b: State): bool = a.energy < b.energy

proc solve(state: State): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[Grid]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid.isOrganized:
      return current.energy

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

proc readInputState(lines: seq[string]): State =
  for x in 1..11:
    result.grid.hallway.add amphipods.find(lines[1][x])

  for i, x in rooms:
    for y in 2 ..< lines.high:
      result.grid.rooms[i].add amphipods.find(lines[y][x + 1])

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
