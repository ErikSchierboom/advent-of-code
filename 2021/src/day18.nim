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

  let currentValue = number.values[index]
  number.values[index] = currentValue.floorDiv(2)
  inc number.depths[index]
  number.values.insert(currentValue.ceilDiv(2), index + 1)
  number.depths.insert(number.depths[index], index + 1)
  result = true

proc reduce(number: Number): Number =
  result = number
  var i = 0

  while i < result.depths.len:
    if result.explode(i): break
    inc i

  if i < result.depths.len:
    result = result.reduce()

  i = 0

  while i < result.depths.len:
    if result.split(i): break
    inc i

  if i < result.depths.len:
    result = result.reduce()

func magnitude(number: Number): int =
  var values = number.values
  var depths = number.depths

  while values.len > 1:
    for i in 0 ..< values.high:
      if depths[i] == depths[i + 1]:
        values[i] = values[i] * 3 + values[i + 1] * 2
        values.delete(i + 1)
        depths.delete(i + 1)
        if depths[i] > 1:
          dec depths[i]

        break
    
  result = values[0]

proc part1(numbers: seq[Number]): int =
  result = numbers.foldl((a + b).reduce).magnitude

proc part2(numbers: seq[Number]): int =
  for i in numbers.low .. numbers.high:
    for j in numbers.low .. numbers.high:
      if i == j:
        continue

      result = result.max((numbers[i] + numbers[j]).reduce.magnitude)

proc solveDay18*: IntSolution =
  let numbers = readInputNumbers() 
  result.part1 = part1(numbers)
  result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay18()
