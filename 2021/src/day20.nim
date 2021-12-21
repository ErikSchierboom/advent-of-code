import helpers, std/[math, sequtils, sets, strutils]

const lightPixel = '#'

proc parseEnhancementAlgorithm(input: string): HashSet[int] =
  let normalized = input.replace("\n", "")
  for i in normalized.low .. normalized.high:
    if normalized[i] == lightPixel:
      result.incl(i)

proc parseInputImage(input: string): HashSet[Point] =
  let lines = input.splitLines
  for y in lines.low .. lines.high:
    for x in lines[0].low .. lines[0].high:
      if lines[y][x] == lightPixel:
        result.incl (x: x, y: y)

proc solveDay20*: IntSolution =
  let inputs = readInputString(day = 20).split("\n\n")
  let enhancementAlgorithm = parseEnhancementAlgorithm(inputs[0])
  let inputImage = parseInputImage(inputs[1])

  echo inputImage
  # let numbers = readInputNumbers() 
  # result.part1 = part1(numbers)
  # result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay20()
