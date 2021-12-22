import helpers, std/[sequtils, sets]

const lightPixel = '#'

iterator grid(point: Point): Point =
  for dy in -1 .. 1:
    for dx in -1 .. 1:
      yield (x: point.x + dx, y: point.y + dy)

proc index(points: HashSet[Point], point: Point): int =
  for gridPoint in point.grid:
    result = result shl 1 or (if gridPoint in points: 1 else: 0)

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
  for point in points:
    for gridPoint in point.grid:
      if points.index(gridPoint) in enhancementAlgorithm:
        result.incl gridPoint

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
