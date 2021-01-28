import sequtils, strformat, strutils, sugar, tables

func digits(number: int): seq[int] = ($number).mapIt(parseInt($it))

func pairs(digits: seq[int]): seq[(int, int)] = digits.zip(digits[1..^1])

iterator candidates: seq[(int, int)] =
  for candidate in 235_741..706_948:
    yield candidate.digits().pairs()

proc inOrder(digitPairs: seq[(int, int)]): bool = 
  digitPairs.allIt(it[0] <= it[1])

proc pairOfAnyLength(digitPairs: seq[(int, int)]): bool =
  digitPairs.anyIt(it[0] == it[1])

proc pairOfLengthTwo(digitPairs: seq[(int, int)]): bool =
  toSeq(digitPairs.filterIt(it[0] == it[1]).toCountTable().values).contains(1)

proc matchCount(pair: seq[(int, int)] -> bool): int =
  for candidate in candidates():
    if inOrder(candidate) and pair(candidate):
      result.inc

proc part1(): int = matchCount(pairOfAnyLength)

proc part2(): int = matchCount(pairOfLengthTwo)

echo &"day 4: {part1()}, {part2()}"
