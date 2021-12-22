import helpers, std/[sequtils, sets]

iterator square(point: Point, offset: int): Point =
  for dy in -offset .. offset:
    for dx in -offset .. offset:
      yield (x: point.x + dx, y: point.y + dy)

proc index(points: HashSet[Point], point: Point): int =
  for gridPoint in point.square(offset = 1):
    result = result shl 1 or (if gridPoint in points: 1 else: 0)

proc parseLightPixelEncoding(line: string): HashSet[int] =
  for i in line.low .. line.high:
    if line[i] == '#':
      result.incl(i)

proc parseLightPixels(lines: seq[string]): HashSet[Point] =
  for y in lines.low .. lines.high:
    for x in lines[0].low .. lines[0].high:
      if lines[y][x] == '#':
        result.incl (x: x, y: y)

proc enhance(points: HashSet[Point], lightPixelEncoding: HashSet[int]): HashSet[Point] =
  for point in points:
    for gridPoint in point.square(offset = 2):
      if points.index(gridPoint) in lightPixelEncoding:
        result.incl gridPoint

proc solveDay20*: IntSolution =
  let lines = readInputStrings(day = 20).toSeq
  let lightPixelEncoding = parseLightPixelEncoding(lines[0])
  var lightPixels = parseLightPixels(lines[2..^1])

  lightPixels = lightPixels.enhance(lightPixelEncoding)
  lightPixels = lightPixels.enhance(lightPixelEncoding)

  result.part1 = lightPixels.len
  # result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay20()
