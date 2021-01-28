import input, sets, sequtils, strformat, strutils, tables

let lines = readInputAsLines(3)

func manhattanDistance(fst: (int, int)): int =
  abs(fst[0]) + abs(fst[1])

func coordsForPath(instructions: seq[string]): Table[(int, int), int] =
  var current = (0, 0)
  var steps = 0

  for instruction in instructions:
    let direction = instruction[0]
    let offset = parseInt(instruction[1..^1])

    for dx in 0 ..< offset:
      case direction
      of 'R': current[0].inc()
      of 'L': current[0].dec()
      of 'U': current[1].inc()
      of 'D': current[1].dec()
      else: quit(1)

      steps.inc()
      discard result.hasKeyOrPut(current, steps)

proc coordsForWire(index: int): Table[(int, int), int] =
  coordsForPath(lines[index].split(','))

let wire1Coords = coordsForWire(0)
let wire2Coords = coordsForWire(1)

let crossingCoords = toHashSet(toSeq(wire1Coords.keys)) * toHashSet(toSeq(wire2Coords.keys))

proc part1(): int = crossingCoords.mapIt(it.manhattanDistance).min

proc part2(): int = crossingCoords.mapIt(wire1Coords[it] + wire2Coords[it]).min

echo &"day 3: {part1()}, {part2()}"