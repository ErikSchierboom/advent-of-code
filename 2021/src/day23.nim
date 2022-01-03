import helpers, std/[options, sequtils, strscans, tables]

type 
  Grid = tuple[hallway: array[11, char], rooms: array[4, array[2, char]]]
  State = tuple[grid: Grid, energy: int]

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq

  for i in result.grid.hallway.low .. result.grid.hallway.high:
    result.grid.hallway[i] = '.'

  for i in 0..3:
    result.grid.rooms[i][0] = lines[2][3 + i * 2]
    result.grid.rooms[i][1] = lines[3][3 + i * 2]

func organized(grid: Grid): bool =
  grid.rooms[0][0] == 'A' and grid.rooms[0][1] == 'A' and
  grid.rooms[1][0] == 'B' and grid.rooms[1][1] == 'B' and
  grid.rooms[2][0] == 'C' and grid.rooms[2][1] == 'C' and
  grid.rooms[3][0] == 'D' and grid.rooms[3][1] == 'D'

proc moves(state: State): seq[State] =
  echo "todo"

proc solveDay23*: IntSolution =
  echo readInputState()

when isMainModule:
  echo solveDay23()
