import helpers, std/[algorithm, sets, sequtils, strscans, strutils, tables, typetraits]

type
  Encoding = HashSet[char]
  Entry = tuple[patterns: seq[Encoding], digits: seq[Encoding]]

const originalDigits = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

func encodings(input: string): seq[Encoding] =
  input.splitWhitespace.mapIt(it.toHashSet)

func createDecryptionTable(entry: Entry): Table[char, char] =
  proc findPattern(entry: Entry, length: int): Encoding = 
    for pattern in entry.patterns:
      if pattern.len == length: return pattern

  let segmentCounts = entry.patterns.mapIt(it.toSeq).concat.toCountTable
  let encodedOneSegment = entry.findPattern(length = 2)
  let encodedFourSegment = entry.findPattern(length = 4)
  let encodedSevenSegment = entry.findPattern(length = 3)

  var e = segmentCounts.find(4)[0]
  var b = segmentCounts.find(6)[0]
  var f = segmentCounts.find(9)[0]
  var a = toSeq(encodedSevenSegment - encodedOneSegment)[0]
  var c = toSeq(segmentCounts.find(8).toHashSet - toHashSet([a]))[0]
  var d = toSeq(encodedFourSegment - encodedOneSegment - [b].toHashSet())[0]
  let g = toSeq(toHashSet(segmentCounts.keys) - toHashSet([a, b, c, d, e, f]))[0]

  result = {a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', f: 'f', g: 'g'}.toTable

func decipherDigit(encodedDigit: Encoding, decriptionTable: Table[char, char]): int =
  originalDigits.find(encodedDigit.mapIt(decriptionTable[it]).sorted.join)

func digitsToDec(digits: seq[int]): int = digits.foldl(a * 10 + b, 0)

proc readInputEntries(): seq[Entry] =
  for (_, patterns, digits) in readInputScans(day = 8, pattern = "$+ | $+"):
    result.add (patterns: patterns.encodings, digits: digits.encodings)

func part1(entries: seq[Entry]): int =
  for entry in entries:
    result.inc entry.digits.countIt(it.len in {2,3,4,7})

proc part2(entries: seq[Entry]): int =
  for entry in entries:
    let decryptionTable = createDecryptionTable(entry)
    result.inc entry.digits.mapIt(it.decipherDigit(decryptionTable)).digitsToDec

proc solveDay8*: IntSolution =
  let entries = readInputEntries()
  result.part1 = part1(entries)
  result.part2 = part2(entries)

when isMainModule:
  echo solveDay8()
