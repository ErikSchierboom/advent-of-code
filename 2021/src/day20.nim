import helpers, std/[sequtils, sets, strutils]

const lightPixel = '#'

iterator grid(point: Point): Point =
  for dy in -1 .. 1:
    for dx in -1 .. 1:
      yield (x: point.x + dx, y: point.y + dy)

func pointsToEnhance(points: HashSet[Point]): HashSet[Point] =
  for point in points:
    for pointInGrid in point.grid:
      result.incl pointInGrid

proc index(points: HashSet[Point], point: Point): int =
  for pointInGrid in point.grid:
    result = result shl 1 or (if pointInGrid in points: 1 else: 0)

proc parseEnhancementAlgorithm(line: string): HashSet[int] =
  for i in line.low .. line.high:
    if line[i] == lightPixel:
      result.incl(i)

proc parseInputImage(lines: seq[string]): HashSet[Point] =
  for y in lines.low .. lines.high:
    for x in lines[0].low .. lines[0].high:
      if lines[y][x] == lightPixel:
        result.incl (x: x, y: y)

proc enhance(points: HashSet[Point], enhancementAlgorithm: HashSet[int]): HashSet[Point] =
  for point in pointsToEnhance(points):
    if points.index(point) in enhancementAlgorithm:
      result.incl point

proc solveDay20*: IntSolution =
  let lines = readInputStrings(day = 20).toSeq
  let enhancementAlgorithm = parseEnhancementAlgorithm(lines[0])
  var lightPixels = parseInputImage(lines[2..^1])

  lightPixels = lightPixels.enhance(enhancementAlgorithm)
  lightPixels = lightPixels.enhance(enhancementAlgorithm)

  result.part1 = lightPixels.len
  # result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay20()
