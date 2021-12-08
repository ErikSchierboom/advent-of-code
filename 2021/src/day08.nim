import helpers, std/[sets, sequtils, strscans, strutils]

type
  Segments = HashSet[char]
  Entry = tuple[patterns: seq[Segments], digits: seq[Segments]]

const display =
  [
    {'a', 'b', 'c', 'e', 'f', 'g'},
    {'c', 'f'},
    {'a', 'c', 'd', 'e', 'g'},
    {'a', 'c', 'd', 'f', 'g'},
    {'b', 'c', 'd', 'f'},
    {'a', 'b', 'd', 'f', 'g'},
    {'a', 'b', 'd', 'e', 'f', 'g'},
    {'a', 'c', 'f'},
    {'a', 'b', 'c', 'd', 'e', 'f', 'g'},
    {'a', 'b', 'c', 'd', 'f', 'g'},
  ]

func segments(input: string): seq[Segments] =
  input.splitWhitespace.mapIt(it.toHashSet)

proc readInputEntries(): seq[Entry] =
  for (_, patterns, digits) in readInputScans(day = 8, pattern = "$+ | $+"):
    result.add (patterns: patterns.segments, digits: digits.segments)

proc solveDay8*: IntSolution =
  let entries = readInputEntries()

  for entry in entries:
    result.part1.inc entry.digits.countIt(it.len in {2,3,4,7})

when isMainModule:
  echo solveDay8()
