import algorithm, sequtils, strformat, strutils, sugar, tables

func digits(number: int): seq[int] = ($number).mapIt(parseInt($it))

var candidates = newSeq[seq[int]]()
for candidate in 235_741..706_948:
  candidates.add(candidate.digits())

func inOrder(digits: seq[int]): bool =  digits.sorted == digits

func hasPair(digitCount: CountTable[int], comparison: int -> bool): bool =
  toSeq(digitCount.values).anyIt(comparison(it))

proc matchCount(comparison: int -> bool): int =
  candidates.countIt(it.inOrder() and it.toCountTable().hasPair(comparison))

proc part1(): int = matchCount((count) => count >= 2)

proc part2(): int = matchCount((count) => count == 2)

echo &"day 4: {part1()}, {part2()}"
