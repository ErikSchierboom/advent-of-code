import std/[os, sequtils, sets, strscans, strutils, strformat, tables]

type
  Solution*[T, U] = object
    part1*: T
    part2*: U
  IntSolution* = Solution[int, int]
  Point* = tuple[x, y: int]
  Line* = tuple[a, b: Point]
  Day* = range[1..13]

func `$`*(day: Day): string =
  &"day{intToStr(day, 2)}"

func filename*(day: Day): string =
  &"{day}.txt"

func filepath*(day: Day): string =
  "input" / day.filename

proc readInputString*(day: Day): string =
  readFile(day.filepath)

iterator readInputStrings*(day: Day): string =
  for line in lines(day.filepath):
    yield line

iterator readInputScans*(day: Day, pattern: static[string]): auto =
  for line in lines(day.filepath):
    yield line.scanTuple(pattern)

iterator readInputInts*(day: Day): int =
  for line in lines(day.filepath):
    yield parseInt(line)

iterator readInputDigits*(day: Day): seq[int] =
  for line in lines(day.filepath):
    yield line.mapIt(parseInt($it))

iterator splitToInts*(str: string, separator = ','): int =
  for substr in str.split(','):
    yield parseInt($substr)

func transpose*[T](s: seq[seq[T]]): seq[seq[T]] =
  result = newSeq[seq[T]](s[0].len)
  for i in 0 .. s[0].high:
    result[i] = newSeq[T](s.len)
    for j in 0 .. s.high:
      result[i][j] = s[j][i]

func find*[T](table: CountTable[T], count: int): seq[T] =
  for k, v in table:
    if v == count:
      result.add k

func keys*[T](table: CountTable[T]): seq[T] =
  for k, _ in table:
    result.add k
