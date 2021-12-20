import helpers, std/[math, sequtils, strutils]

type Number = seq[tuple[value, depth: int]]

proc parseNumber(line: string): Number =
  var depth = -1

  for c in line:
    if c == '[':
      inc depth
    elif c == ']':
      dec depth
    elif c.isDigit:
      result.add (value: parseInt($c), depth: depth)

proc readInputNumbers: seq[Number] =
  for line in readInputStrings(day = 18):
    result.add parseNumber(line)

proc `+`(left: Number, right: Number): Number =
  result = left & right
  for i in result.low .. result.high:
    inc result[i].depth

proc explode(number: var Number, index: int) =
  if index > number.low:
    inc number[index - 1].value, number[index].value

  if index < number.high - 1:
    inc number[index + 2].value, number[index + 1].value

  number[index] = (value: 0, depth: number[index].depth - 1)
  number.delete(index + 1)

proc split(number: var Number, index: int) =
  number.insert((value: number[index].value.ceilDiv(2), depth: number[index].depth + 1), index + 1)
  number[index] = (value: number[index].value.floorDiv(2), depth: number[index].depth + 1)

proc reduce(number: Number): Number =
  result = number
  var i = 0

  while i < result.len:
    if result[i].depth == 4:
      result.explode(i)
      break
    inc i

  if i < result.len:
    result = result.reduce()

  i = 0

  while i < result.len:
    if result[i].value >= 10:
      result.split(i)
      break
    inc i

  if i < result.len:
    result = result.reduce()

func magnitude(number: Number): int =
  var number = number

  while number.len > 1:
    for i in 0 ..< number.high:
      if number[i].depth == number[i + 1].depth:
        number[i].value = number[i].value * 3 + number[i + 1].value * 2
        number.delete(i + 1)
        if number[i].depth > 0:
          dec number[i].depth

        break
    
  result = number[0].value

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
