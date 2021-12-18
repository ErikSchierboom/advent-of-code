import helpers, std/[lists, sequtils, strutils]

type
  NumberNode = tuple[value, depth: int]
  Number = DoublyLinkedList[NumberNode]

proc parseNumber(line: string): Number =
  var depth, i: int

  while i <= line.high:
    if line[i] == '[':
      inc depth
      inc i
      
      var value: int
      while line[i].isDigit: 
        value = value * 10 + parseInt($line[i])
        inc i

      if value > 0:
        let numberNode = (value: value, depth: depth)
        result.add(numberNode)
    elif line[i] == ']':
      dec depth
      inc i
    elif line[i] == ',':
      inc i
      var value: int
      while line[i].isDigit: 
        value = value * 10 + parseInt($line[i])
        inc i

      if value > 0:
        let numberNode = (value: value, depth: depth)
        result.add(numberNode)
    else:
      inc i

proc `+`(left: Number, right: Number): Number =
  for n in left:
    result.add (value: n.value, depth: n.depth + 1)

  for n in right:
    result.add (value: n.value, depth: n.depth + 1)

proc readInputNumbers: seq[Number] =
  for line in readInputStrings(day = 18):
    result.add parseNumber(line)

proc solveDay18*: IntSolution =
  let addedNumber = readInputNumbers().foldl(a + b)
  echo addedNumber
 
when isMainModule:
  echo solveDay18()
