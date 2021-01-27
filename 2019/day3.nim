import input, sets, strformat, strutils

let lines = readInputAsLines(3)

func manhattanDistance(fst: (int, int)): int =
  abs(fst[0]) + abs(fst[1])

func coordsForPath(instructions: seq[string]): HashSet[(int, int)] =
  var current = (0, 0)

  for instruction in instructions:
    let direction = instruction[0]
    let offset = parseInt(instruction[1..^1])
    let offsetRange = 0 ..< offset
    case direction
      of 'R': 
        for dx in offsetRange:
          current[0].inc()
          result.incl(current)
      of 'L': 
        for dx in offsetRange:
          current[0].dec()
          result.incl(current)
      of 'U':
        for dy in offsetRange:
          current[1].inc()
          result.incl(current)
      of 'D':
        for dy in offsetRange:
          current[1].dec()
          result.incl(current)
      else: quit(1)

  result.excl((0, 0))

proc coordsForWire(index: int): HashSet[(int, int)] =
  coordsForPath(lines[index].split(','))

let wire1Coords = coordsForWire(0)
let wire2Coords = coordsForWire(1)

proc part1(): int = 
  result = high(int)
  for coord in wire1Coords * wire2Coords:
    result = min(result, coord.manhattanDistance)

proc part2(): int =
  discard

echo &"day 3: {part1()}, {part2()}"