import std/[os, sequtils, strutils, strformat]

type
  Solution*[T, U] = object
    part1*: T
    part2*: U
  IntSolution* = Solution[int, int]
  Point* = tuple[x, y: int]
  Day* = range[1..3]

func `$`*(day: Day): string =
  &"day{intToStr(day, 2)}"

func filename*(day: Day): string =
  &"{day}.txt"

func filepath*(day: Day): string =
  "input" / day.filename

iterator readInputStrings*(day: Day): string =
  for line in lines(day.filepath):
    yield line

iterator readInputInts*(day: Day): int =
  for line in lines(day.filepath):
    yield parseInt(line)

iterator readInputBinaryNums*(day: Day): seq[int] =
  for line in lines(day.filepath):
    yield line.mapIt(parseInt($it))
