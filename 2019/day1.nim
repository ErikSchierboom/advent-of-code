import input, math, sequtils, strformat

let masses = readInputAsInts(1)  

func fuelForMass(mass: int): int = mass div 3 - 2

func fuelForFuel(mass: int): int =
  var current = mass

  while current > 0:
    current = fuelForMass(current)
    result.inc(current)

proc part1(): int = masses.map(fuelForMass).sum

proc part2(): int = masses.map(fuelForFuel).sum

echo &"day 1: {part1()}, {part2()}"