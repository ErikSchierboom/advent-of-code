import std/strutils

type
  Solution*[T, U] = object
    part1*: T
    part2*: U
  IntSolution* = Solution[int, int]
  Point* = tuple[x, y: int]

iterator readInputStringSeq*(filename: string): string =
  for line in filename.lines:
    yield line

iterator readInputIntSeq*(filename: string): int =
  for line in filename.lines:
    yield parseInt(line)
