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

proc explode(number: var Number, index: int): bool =
  if number.depths[index] != 5:
    return false
  
  if index > number.values.low:
    inc number.values[index - 1], number.values[index]

  if index < number.values.high - 1:
    inc number.values[index + 2], number.values[index + 1]

  number.values[index] = 0
  dec number.depths[index]
  number.values.delete(index + 1)
  number.depths.delete(index + 1)
  result = true

proc split(number: var Number, index: int): bool =
  if number.values[index] < 10:
    return false

  let valueLow = number.values[index].floorDiv(2)
  let valueHigh = number.values[index].ceilDiv(2)
  number.values[index] = valueLow
  inc number.depths[index]
  number.values.insert(valueHigh, index + 1)
  number.depths.insert(number.depths[index], index + 1)
  result = true

proc reduce(number: var Number) =
  echo "reduce"
  var i = 0

  while i < number.depths.len:
    if number.explode(i) or number.split(i):
      break

    inc i

  if i < number.depths.len:
    number.reduce()

proc part1(number: var Number): int =
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
  proc folder(a, b: Number): Number =
    var x = (a + b)
    x.reduce()
    result = x

  var number = readInputNumbers().foldl(folder(a, b))
  echo number
  # echo number.reduce()
  # result.part1 = part1(number)
 
when isMainModule:
  echo solveDay18()
