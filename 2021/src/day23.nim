import helpers, std/[algorithm, heapqueue, math, sequtils, strformat, strutils, tables]

type 
  Grid = tuple[hallway: seq[int], rooms: array[4, seq[int]]]
  State = tuple[grid: Grid, energy: int]

const amphipods = "ABCD"
const rooms = [2, 4, 6, 8]

func cost(amphipod: int): int = 10 ^ amphipod
func isOrganized(grid: Grid, i: int): bool = grid.rooms[i].allIt(it == i)
func isOrganized(grid: Grid): bool = toSeq(0..grid.rooms.high).allIt(grid.isOrganized(it))

func `$`(grid: Grid): string =
  func `$`(i: int): string =
    if i == -1: "." else: $(amphipods[i])
  let hallway = grid.hallway.mapIt($it).join()
  &"#############\n#{hallway}#\n###{$grid.rooms[0][0]}#{$grid.rooms[1][0]}#{$grid.rooms[2][0]}#{$grid.rooms[3][0]}###\n  #{$grid.rooms[0][1]}#{$grid.rooms[1][1]}#{$grid.rooms[2][1]}#{$grid.rooms[3][1]}#\n  #########\n"

func `$`(state: State): string =
  &"Energy: {state.energy}\n{state.grid}"

proc moves(state: State): seq[State] =
  for x, a in state.grid.hallway:
    if a == -1:
      continue

    let room = state.grid.rooms[a]
    if room.anyIt(it != -1 and it != a):
      continue

    let xx = if x < rooms[a]: x + 1 else: x - 1
    if toSeq(min(xx, rooms[a])..max(xx, rooms[a])).anyIt(state.grid.hallway[it] != -1):
      continue

    let y = toSeq(room.low..room.high).filterIt(room[it] == -1).max

    echo &"move {a} from hallway idx {x} to room {a} and level {y}"
    var updated = state
    updated.grid.hallway[x] = -1
    updated.grid.rooms[a][y] = a
    inc updated.energy, a.cost * (abs(x - rooms[a]) + 1 + y)
    result.add updated

  for i, room in state.grid.rooms:
    if state.grid.isOrganized(i):
      continue

    for y, a in room:
      if a == -1:
        continue
      elif y == room.high and a == i:
        break

      for x, _ in state.grid.hallway:
        if x in rooms:
          continue
        elif toSeq(min(x, rooms[i])..max(x, rooms[i])).anyIt(state.grid.hallway[it] != -1):
          continue

        echo &"move {a} from level {y} in room {i} to hallway {x}"

        var updated = state
        updated.grid.hallway[x] = a
        updated.grid.rooms[i][y] = -1
        inc updated.energy, a.cost * (abs(x - rooms[i]) + 1 + y)
        result.add updated
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
      echo "organized"
      return current.energy

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        # echo move
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
  # result.part2 = part2()

when isMainModule:
  echo solveDay23()
