import helpers, std/[sequtils, strutils]

type
  NumberKind = enum
    nkNil, nkLiteral, nkPair
  Number = ref object
    parent: Number
    case kind: NumberKind
      of nkNil: discard
      of nkLiteral: value: int
      of nkPair: left, right: Number

func `$`(number: Number): string =
  case number.kind
    of nkNil: "nil"
    of nkLiteral: $number.value
    of nkPair: "[" & $number.left & "," & $number.right & "]"

func `+`(left: Number, right: Number): Number =
  Number(kind: nkPair, left: left, right: right)

func depth(number: Number): int = 
  if number.kind == nkNil: 0 else: 1 + number.parent.depth

proc reduce(number: Number): Number =
  if number.kind == nkLiteral:
    return
  
    # if depth == 4 and number.right.kind == nkLiteral and number.left.kind == nkPair and number.left.left.kind == nkLiteral and number.left.right.kind == nkLiteral:
    #   Number(kind: nkPair, left: Number(kind: nkLiteral, value: 0), right: Number(kind: nkLiteral, value: number.right.value + number.left.right.value))
    # elif depth == 4 and number.left.kind == nkLiteral and number.right.kind == nkPair and number.right.left.kind == nkLiteral and number.right.right.kind == nkLiteral:
    #   Number(kind: nkPair, left: Number(kind: nkLiteral, value: number.left.value + number.right.left.value), right: Number(kind: nkLiteral, value: 0))
    # else:
    #   Number(kind: nkPair, left: reduce(number.left, depth + 1), right: reduce(number.right, depth + 1))

proc parseNumber(line: string, index: var int, parent: Number): Number

proc parsePair(line: string, index: var int, parent: Number): Number =
  result = Number(kind: nkPair, parent: parent)
  inc index # '['
  result.left = parseNumber(line, index, result)
  inc index # ','
  result.right = parseNumber(line, index, result)
  inc index # ']'

proc parseLiteral(line: string, index: var int, parent: Number): Number =
  var value: int

  while line[index].isDigit:
    value = value * 10 + parseInt($line[index])
    inc index

  Number(kind: nkLiteral, value: value, parent: parent)

proc parseNumber(line: string, index: var int, parent: Number): Number =
  if line[index] == '[':
    parsePair(line, index, parent)
  else:
    parseLiteral(line, index, parent)

proc readInputEquation: Number =
  var numbers: seq[Number]
  for line in readInputStrings(day = 18):
    var index: int
    numbers.add parseNumber(line, index, Number(kind: nkNil))

  numbers.foldl(a + b)

proc solveDay18*: IntSolution =
  let equation = readInputEquation()
  echo equation.depth
  echo equation.left.left.depth
  # equation.reduce
 
when isMainModule:
  echo solveDay18()
