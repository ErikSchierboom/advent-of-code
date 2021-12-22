import helpers, std/[sequtils, sets]

type Grid = tuple[minX, maxX, minY, maxY: int, pixels: HashSet[Point], encoding: HashSet[int]]

iterator square(point: Point): Point =
  for dy in -1 .. 1:
    for dx in -1 .. 1:
      yield (x: point.x + dx, y: point.y + dy)

func `notin`(point: Point, grid: Grid): bool =
  point.x < grid.minX or point.x > grid.maxX or
  point.y < grid.minY or point.y > grid.maxY

proc index(grid: Grid, point: Point): int =
  for gridPoint in point.square:
    result = result shl 1
    if gridPoint notin grid and 0 in grid.encoding:
      result = result or 1
    elif gridPoint in grid.pixels:
      result = result or 1

proc parseEncoding(line: string): HashSet[int] =
  for i in line.low .. line.high:
    if line[i] == '#':
      result.incl(i)

proc parsePixels(lines: seq[string]): HashSet[Point] =
  for y in lines.low .. lines.high:
    for x in lines[0].low .. lines[0].high:
      if lines[y][x] == '#':
        result.incl (x: x, y: y)

proc parseGrid: Grid =
  let lines = readInputStrings(day = 20).toSeq
  let imageLines = lines[2..^1]
  (minX: 0, maxX: imageLines[2].high, minY: 0, maxY: imageLines.high, pixels: parsePixels(imageLines), encoding: parseEncoding(lines[0]))

proc enhance(grid: Grid): Grid =
  result.minX = grid.minX - 2; result.maxX = grid.maxX + 2
  result.minY = grid.minY - 2; result.maxY = grid.maxY + 2
  result.encoding = grid.encoding

  for y in result.minY .. result.maxY:
    for x in result.minX .. result.maxX:
      let point = (x: x, y: y)
      if grid.index(point) in grid.encoding:
        result.pixels.incl point

proc solveDay20*: IntSolution =
  var grid = parseGrid()
  grid = grid.enhance()
  grid = grid.enhance()

  result.part1 = grid.pixels.len
  # result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay20()
