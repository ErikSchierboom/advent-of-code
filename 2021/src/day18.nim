import helpers, std/[lists, sequtils, strutils]

type
  NumberNodeKind = enum
    nkSingle, nkPair
  NumberNode = object
    depth: int
    case kind: NumberNodeKind
      of nkSingle: num: int
      of nkPair: left, right: int
  Number = DoublyLinkedList[NumberNode]

proc parseNumber(line: string): Number =
  var depth, num: int
  var numbers: seq[int]

  for c in line:
    case c
      of '[':
        inc depth
      of ']':
        if numbers.len > 0:
          result.add NumberNode(depth: depth, kind: nkPair, left: numbers[0], right: num)
        else:
          result.add NumberNode(depth: depth, kind: nkSingle, num: num)
        dec depth
        numbers = newSeq[int]()
        num = 0
      of ',':
        if num > 0: numbers.add num
        num = 0
      else:
        num = num * 10 + parseInt($c)

proc `+`(left: Number, right: Number): Number =
  for n in left:  result.add n
  for n in right: result.add n
  for n in result.nodes: inc n.value.depth

proc readInputNumbers: seq[Number] =
  for line in readInputStrings(day = 18):
    result.add parseNumber(line)

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
  var addedNumber = readInputNumbers().foldl(a + b)
  echo addedNumber
  # addedNumber.reduce
  # echo addedNumber
 
when isMainModule:
  echo solveDay18()
