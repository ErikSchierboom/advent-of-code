import std/strutils

type
  Solution*[T, U] = object
    part1*: T
    part2*: U
  IntSolution* = Solution[int, int]
  Point* = tuple[x, y: int]

proc readInputStringSeq*(filename: string): seq[string] =
  for line in filename.lines:
    result.add line

proc readInputIntSeq*(filename: string): seq[int] =
  for line in filename.lines:
    result.add parseInt(line)
