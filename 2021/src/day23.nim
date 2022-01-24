import algorithm
import heapqueue
import sequtils
import tables
import helpers

const cols = { 'A': 3, 'B': 5, 'C': 7, 'D': 9 }.toTable

const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable

type Amphipod = tuple[a: char, p: Point]

type State = tuple[grid: seq[seq[char]], energy: int]

# func `[]`*(grid: seq[seq[char]], p: Point): char = grid[p.y][p.x]

func `-`*(a: Point, b: Point): int = abs(a.x - b.x) + abs(a.y - b.y)

func findAmphipods(grid: seq[seq[char]]): seq[Amphipod] =
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[y].len:
      if grid[y][x] in cols: result.add (grid[y][x], (x, y))

func isDone(grid: seq[seq[char]]): bool =
  for k, v in cols:
    if (2 .. (grid.len - 2)).anyIt(grid[it][v] != k): return false
  return true

func isHallwayClear(a: int, b: int, grid: seq[seq[char]]): bool =
  (a.min(b) .. a.max(b)).allIt(grid[1][it] == '.')

func moves(amphipod: Amphipod, grid: seq[seq[char]], rest: seq[int]): seq[Point] =
  let (a, p) = amphipod
  if p.y == 1: # Hallway
    if rest.anyIt(grid[it][cols[a]] notin [a, '.']): return @[]
    let
      x = if p.x < cols[a]: p.x + 1 else: p.x - 1
      y = rest.filterIt(grid[it][cols[a]] == '.').max
    return @[(cols[a], y)].filterIt(x.isHallwayClear(cols[a], grid))
  # Room correct
  if p.x == cols[a] and (p.y .. rest.max).allIt(grid[it][p.x] == a):
    return @[]
  if grid[p.y - 1][p.x] != '.': # Top of room not empty
    @[]
  else:
    [1, 2, 4, 6, 8, 10, 11].filterIt(p.x.isHallwayClear(it, grid)).mapIt((it, 1))

func moves(state: State, rest: seq[int]): seq[State] =
  for a in state.grid.findAmphipods:
    for next in a.moves(state.grid, rest):
      var updated = state
      updated.grid[a.p.y][a.p.x] = '.'
      updated.grid[next.y][next.x] = a.a
      inc updated.energy, costs[a.a] * (a.p - next)
      result.add updated

func `<`(a: State, b: State): bool = a.energy < b.energy

func process(state: State, rest: seq[int]): int =
  var queue: HeapQueue[State]
  queue.push(state)

  var energyCounts: CountTable[seq[seq[char]]]
  energyCounts[state.grid] = state.energy

  while queue.len > 0:
    let current = queue.pop()

    if current.grid.isDone:
      return current.energy

    if current.energy > energyCounts.getOrDefault(current.grid, high(int)):
      continue

    for move in current.moves(rest):
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy

func part1*(state: State): int = state.process @[2, 3]

func part2*(state: State): int = state.process @[2, 3]
  # let grid = 
  #   @[
  #     state.grid[0 .. 2],
  #     @["  #D#C#B#A#  ", "  #D#B#A#C#  "].mapIt(it.items.toSeq),
  #     state.grid[^2 .. ^1]
  #   ].foldl(a & b, newSeq[seq[char]]())
  # let newState = state
  # .process @[2, 3, 4, 5]

proc solveDay23*: IntSolution =
  let grid = readInputStrings(day = 23).toSeq.mapIt(it.toSeq)
  let state = (grid: grid, energy: 0)
  result.part1 = part1(state)
  result.part2 = part2(state)

when isMainModule:
  echo solveDay23()
