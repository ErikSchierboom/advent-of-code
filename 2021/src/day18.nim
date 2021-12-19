import helpers, std/[algorithm, math, sequtils, strutils]

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
  let valueLow = number.values[index].floorDiv(2)
  let valueHigh = number.values[index].ceilDiv(2)
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
  var i = 0

  while i < number.depths.len:
    if number.depths[i] == 5:
      number.explode(i)
      number.reduce()
    elif number.values[i] >= 10:
      number.split(i)
      number.reduce()
    else:
      inc i

proc part1(number: var Number): int =
  # TODO: don't use int
  while number.values.len > 1:
    for i in 0 ..< number.values.high:
      if number.depths[i] == number.depths[i + 1]:
        number.values[i] = number.values[i] * 3 + number.values[i + 1] * 2
        number.values.delete(i + 1)
        number.depths.delete(i + 1)
        if number.depths[i] > 1:
          dec number.depths[i]

        break
    
  result = number.values[0]

proc solveDay18*: IntSolution =
  var number = readInputNumbers().foldl(a + b)
  number.reduce
  result.part1 = part1(number)
 
when isMainModule:
  echo solveDay18()
