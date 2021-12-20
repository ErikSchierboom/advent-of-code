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

proc explode(num: var Number, index: int) =
  if index > num.low:
    inc num[index - 1].value, num[index].value

  if index < num.high - 1:
    inc num[index + 2].value, num[index + 1].value

  num[index] = (value: 0, depth: num[index].depth - 1)
  num.delete(index + 1)

proc split(num: var Number, index: int) =
  num.insert((value: num[index].value.ceilDiv(2), depth: num[index].depth + 1), index + 1)
  num[index] = (value: num[index].value.floorDiv(2), depth: num[index].depth + 1)

proc reduce(num: var Number) =
  var i = 0
  while i < num.len:
    if num[i].depth == 4:
      num.explode(i)
    inc i

  i = 0

  while i < num.len:
    if num[i].value >= 10:
      num.split(i)
      num.reduce()
    inc i

proc reduced(num: Number): Number =
  result = num
  result.reduce()

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
  result = numbers.foldl((a + b).reduced).magnitude

proc part2(numbers: seq[Number]): int =
  for i in numbers.low .. numbers.high:
    for j in numbers.low .. numbers.high:
      if i == j:
        continue

      result = result.max((numbers[i] + numbers[j]).reduced.magnitude)

proc solveDay18*: IntSolution =
  let numbers = readInputNumbers() 
  result.part1 = part1(numbers)
  result.part2 = part2(numbers)
 
when isMainModule:
  echo solveDay18()
