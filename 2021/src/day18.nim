import helpers, std/[lists, sequtils, strutils]

type
  NumberNodeKind = enum
    nkSingle, nkPair
  NumberNode = object
    depth: int
    case kind: NumberNodeKind
      of nkSingle: value: int
      of nkPair: left, right: int
  Number = DoublyLinkedList[NumberNode]

# proc parseNumber(line: string): Number =
#   var depth, i: int

#   while i <= line.high:
#     if line[i] == '[':
#       inc depth
#       inc i
      
#       var value: int
#       while line[i].isDigit: 
#         value = value * 10 + parseInt($line[i])
#         inc i

#       if value > 0:
#         let numberNode = (num: value, depth: depth)
#         result.add(numberNode)
#     elif line[i] == ']':
#       dec depth
#       inc i
#     elif line[i] == ',':
#       inc i
#       var value: int
#       while line[i].isDigit: 
#         value = value * 10 + parseInt($line[i])
#         inc i

#       if value > 0:
#         let numberNode = (num: value, depth: depth)
#         result.add(numberNode)
#     else:
#       inc i

proc `+`(left: Number, right: Number): Number =
  for n in left:
    result.add n

  for n in right:
    result.add n

  for n in result.nodes:
    inc n.value.depth

# proc readInputNumbers: seq[Number] =
#   for line in readInputStrings(day = 18):
#     result.add parseNumber(line)

# proc reduce(number: var Number) =
#   for n in number.nodes:
#     if n.value.depth == 5:
#       if n.next != nil and n.next.value.depth == 5:        
#         inc n.next.value.num, n.next.next.value.num
#         n.value.num = 0
#         dec n.next.value.depth
#         dec n.value.depth
#         number.remove(n.next.next)
#       echo "reduce"

proc solveDay18*: IntSolution =
  # var addedNumber = readInputNumbers().foldl(a + b)
  # echo addedNumber
  # addedNumber.reduce
  # echo addedNumber
 
when isMainModule:
  echo solveDay18()
