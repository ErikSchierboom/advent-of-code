import helpers, std/sequtils

const lightPixel = '#'
const darkPixel = '.'

type Grid = tuple[unknown: char, pixels: seq[seq[char]], encoding: string]

iterator square(point: Point): Point =
  for dy in -1 .. 1:
    for dx in -1 .. 1:
      yield (x: point.x + dx, y: point.y + dy)

func bit(c: char): int {.inline.} =
  if c == lightPixel: 1 else: 0

func index(grid: Grid, point: Point): int =
  for gridPoint in point.square:
    result = result shl 1
    if gridPoint.x < grid.pixels[0].low or gridPoint.x > grid.pixels[0].high or
       gridPoint.y < grid.pixels.low or gridPoint.y > grid.pixels.high:
      result = result or grid.unknown.bit
    else:
      result = result or grid.pixels[gridPoint.y][gridPoint.x].bit

func enhance(grid: Grid): Grid =
  result.encoding = grid.encoding
  result.pixels = newSeq[seq[char]](grid.pixels.len + 2)

  for y in grid.pixels.low - 1 .. grid.pixels.high + 1:
    result.pixels[y + 1] = newSeq[char](grid.pixels[0].len + 2)
    for x in grid.pixels[0].low - 1 .. grid.pixels[0].high + 1:
      let point = (x: x, y: y)
      result.pixels[y + 1][x + 1] = grid.encoding[grid.index(point)]

  result.unknown = if grid.unknown == darkPixel: lightPixel else: darkPixel

func numLightPixels(grid: Grid): int =
  for row in grid.pixels:
    for col in row:
      if col == lightPixel:
        inc result

proc parsePixels(lines: seq[string]): seq[seq[char]] =
  for y in lines.low .. lines.high:
    result.add lines[y].toSeq

proc parseGrid: Grid =
  let lines = readInputStrings(day = 20).toSeq
  (unknown: darkPixel, pixels: parsePixels(lines[2..^1]), encoding: lines[0])

proc solveDay20*: IntSolution =
  var grid = parseGrid()

  for i in 1..50:
    grid = grid.enhance()
    if i == 2:
      result.part1 = grid.numLightPixels
    elif i == 50:
      result.part2 = grid.numLightPixels
 
when isMainModule:
  echo solveDay20()
