import helpers, std/[math, sequtils, strutils]

type Number = tuple[values, depths: seq[int]]

proc parseNumber(line: string): Number =
  var depth = 0

  for c in line:
    if c == '[':
      inc depth
    elif c == ']':
      dec depth
    elif c.isDigit:
      result.values.add parseInt($c)
      result.depths.add depth

proc readInputNumbers: seq[Number] =
  for line in readInputStrings(day = 18):
    result.add parseNumber(line)

proc `+`(left: Number, right: Number): Number =
  result.values = left.values.concat(right.values)
  result.depths = left.depths.concat(right.depths).mapIt(it + 1)

proc split(number: var Number, index: int) =
  let valueLow = (number.values[index] / 2).floor.int
  let valueHigh = (number.values[index] / 2).ceil.int
  number.values[index] = valueLow
  inc number.depths[index]
  number.values.insert(valueHigh, index + 1)
  number.depths.insert(number.depths[index], index + 1)

proc explode(number: var Number, index: int) =
  if index > number.values.low:
    inc number.values[index - 1], number.values[index]

  if index < number.values.high - 1:
    inc number.values[index + 2], number.values[index + 1]

  number.values[index] = 0
  dec number.depths[index]
  number.values.delete(index + 1)
  number.depths.delete(index + 1)

proc reduce(number: var Number) =
  echo number
  var i = 0

  while i < number.depths.len:
    if number.depths[i] == 5:
      number.explode(i)
      number.reduce()
    elif number.values[i] >= 10:
      number.split(i)
      break
    else:
      inc i

proc solveDay18*: IntSolution =
  var number = readInputNumbers().foldl(a + b)
  number.reduce
  echo number
 
when isMainModule:
  echo solveDay18()
