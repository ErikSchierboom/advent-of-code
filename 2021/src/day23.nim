import helpers, std/[options, sequtils, strscans, tables]

type 
  Grid = tuple[hallway: array[11, char], rooms: array[4, array[2, char]]]
  State = tuple[grid: Grid, energy: int]

proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  for i in 0..3:
    result.grid.rooms[i][0] = lines[2][3 + i * 2]
    result.grid.rooms[i][1] = lines[3][3 + i * 2]

#   result.grid['A'][0] = 

# { 'A1': pos, 'A2': pos, 'B1': pos, 'B2': pos, 
#            'C1': pos, 'C2': pos, 
#            'D1': pos, 'D2': pos }.toTable

#   result.grid[0] = (kind: input[2][3], pos: (x: 3, y: 2))
#   result.grid[1] = (kind: input[2][5], pos: (x: 5, y: 2))
#   result.grid[2] = (kind: input[2][7], pos: (x: 7, y: 2))
#   result.grid[3] = (kind: input[2][9], pos: (x: 9, y: 2))
#   result.grid[4] = (kind: input[3][3], pos: (x: 3, y: 3))
#   result.grid[5] = (kind: input[3][5], pos: (x: 5, y: 3))
#   result.grid[6] = (kind: input[3][7], pos: (x: 7, y: 3))
#   result.grid[7] = (kind: input[3][9], pos: (x: 9, y: 3))

# func solved(grid: Grid): bool =
#   result = true

#   grid[0].kind == 'A' and

#   for i in 0..3:
#     if grid[i].kind != grid[i + 4].kind or 
#        grid[i].pos.x != grid[i + 4].pos.x or
#        grid[i].pos.y == 1 or grid[i + 4].pos.y == 1:
#       return false

# func moves(state: State): seq[State] =
#   for i, amphipod in result.grid:
#     if amphipod.pos.y ==

proc solveDay23*: IntSolution =
  echo readInputState()

when isMainModule:
  echo solveDay23()
