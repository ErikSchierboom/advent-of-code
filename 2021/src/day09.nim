import helpers, std/sequtils

func part1(grid: seq[seq[int]]): int =
  for y in grid.low .. grid.high:
    for x in grid[0].low .. grid[0].high:
      if (x == grid[0].low  or grid[y][x] < grid[y][x - 1]) and
         (x == grid[0].high or grid[y][x] < grid[y][x + 1]) and
         (y == grid.low  or grid[y][x] < grid[y - 1][x]) and
         (y == grid.high or grid[y][x] < grid[y + 1][x]):
           result.inc grid[y][x] + 1

proc solveDay9*: IntSolution =
  let grid = readInputDigits(day = 9).toSeq
  result.part1 = part1(grid)
  # result.part2 = part2(entries)

when isMainModule:
  echo solveDay9()
