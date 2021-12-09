import helpers, std/[sets, sequtils, strscans, strutils, tables, typetraits]

type
  Encoding = HashSet[char]
  Entry = tuple[patterns: seq[Encoding], digits: seq[Encoding]]

const digits =
  [
    toHashSet(['a', 'b', 'c', 'e', 'f', 'g']),
    toHashSet(['c', 'f']),
    toHashSet(['a', 'c', 'd', 'e', 'g']),
    toHashSet(['a', 'c', 'd', 'f', 'g']),
    toHashSet(['b', 'c', 'd', 'f']),
    toHashSet(['a', 'b', 'd', 'f', 'g']),
    toHashSet(['a', 'b', 'd', 'e', 'f', 'g']),
    toHashSet(['a', 'c', 'f']),
    toHashSet(['a', 'b', 'c', 'd', 'e', 'f', 'g']),
    toHashSet(['a', 'b', 'c', 'd', 'f', 'g']),
  ]

func encodings(input: string): seq[Encoding] =
  input.splitWhitespace.mapIt(it.toHashSet)

proc readInputEntries(): seq[Entry] =
  for (_, patterns, digits) in readInputScans(day = 8, pattern = "$+ | $+"):
    result.add (patterns: patterns.encodings, digits: digits.encodings)

func part1(entries: seq[Entry]): int =
  for entry in entries:
    result.inc entry.digits.countIt(it.len in {2,3,4,7})

proc part2(entries: seq[Entry]): int =
  for entry in entries:
    let usedForOnes = entry.patterns.filterIt(it.len == 2)[0]
    let usedForFours = entry.patterns.filterIt(it.len == 4)[0]
    let usedForSevens = entry.patterns.filterIt(it.len == 3)[0]
    let usedForEights = entry.patterns.filterIt(it.len == 7)[0]
    
    let allSegments = entry.patterns.mapIt(it.toSeq).concat.toCountTable
    let ass = usedForSevens - usedForOnes
    let a = ass.toSeq[0]
    let cf = usedForSevens * usedForFours
    let bd = usedForEights * usedForFours - cf
    let eg = usedForEights - usedForOnes - usedForFours - usedForSevens

    var f: char
    var e: char
    var b: char

    for k,v in allSegments:
      if v == 9:
        f = k
      elif v == 4:
        e = k
      elif v == 6:
        b = k

    var cs = cf
    cs.excl f
    let c = cs.toSeq[0]

    var gs = eg
    gs.excl e
    let g = gs.toSeq[0]

    var ds = bd
    ds.excl b
    let d = ds.toSeq[0]

    let encoding = {
      a: 'a',
      b: 'b',
      c: 'c',
      d: 'd',
      e: 'e',
      f: 'f',
      g: 'g',
    }.toTable

    var number: string
    for x in entry.digits:
      
      let correct = x.mapIt(encoding[it]).toHashSet

      for i in digits.low .. digits.high:
        if digits[i] == correct:
          number.add $i

    result.inc parseInt(number)

proc solveDay8*: IntSolution =
  let entries = readInputEntries()
  result.part1 = part1(entries)
  result.part2 = part2(entries)

when isMainModule:
  echo solveDay8()
