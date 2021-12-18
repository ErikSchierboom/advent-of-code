import helpers, std/[sequtils, strutils]

type
  NumberKind = enum
    nkLiteral, nkPair
  Number = ref object
    case kind: NumberKind
      of nkLiteral: value: int
      of nkPair: left, right: Number

func `$`(number: Number): string =
  case number.kind
    of nkLiteral: $number.value
    of nkPair: "[" & $number.left & "," & $number.right & "]"

func `+`(left: Number, right: Number): Number =
  Number(kind: nkPair, left: left, right: right)

proc reduce(number: Number): Number =
  proc inner(number: Number, depth: int): Number =
    case number.kind
      of nkLiteral:
        number
      of nkPair:
        Number(kind: nkPair, left: inner(number.left, depth + 1), right: inner(number.right, depth + 1))

  inner(number, 0)

proc parseNumber(line: string, index: var int): Number

proc parsePair(line: string, index: var int): Number =
  result = Number(kind: nkPair)
  inc index # '['
  result.left = parseNumber(line, index)
  inc index # ','
  result.right = parseNumber(line, index)
  inc index # ']'

proc parseLiteral(line: string, index: var int): Number =
  var value: int

  while line[index].isDigit:
    value = value * 10 + parseInt($line[index])
    inc index

  Number(kind: nkLiteral, value: value)

proc parseNumber(line: string, index: var int): Number =
  if line[index] == '[':
    parsePair(line, index)
  else:
    parseLiteral(line, index)

proc readInputEquation: Number =
  var numbers: seq[Number]
  for line in readInputStrings(day = 18):
    var index: int
    numbers.add parseNumber(line, index)

  numbers.foldl(a + b)

proc solveDay18*: IntSolution =
  var equation = readInputEquation()
  echo equation.reduce()
 
when isMainModule:
  echo solveDay18()
