import helpers, std/[lists, math, sequtils, strutils]

type
  NumberNode = tuple[num, depth: int]
  Number = DoublyLinkedList[NumberNode]

proc parseNumber(line: string): Number =
  var depth = 0
  var num = -1

  for c in line:
    case c
      of '[':
        inc depth
      of ']':
        if num >= 0: 
          result.add((num: num, depth: depth))
          num = -1
        dec depth
      of ',':
        if num >= 0: 
          result.add((num: num, depth: depth))
          num = -1
      else:
        if num < 0:
          num = 0
        num = num * 10 + parseInt($c)

proc `+`(left: Number, right: Number): Number =
  for n in left:  result.add n
  for n in right: result.add n
  for n in result.nodes: inc n.value.depth

proc readInputNumbers: seq[Number] =
  for line in readInputStrings(day = 18):
    result.add parseNumber(line)

proc split(node: DoublyLinkedNode[NumberNode]) =
  let oldNext = node.next
  node.next = newDoublyLinkedNode[NumberNode]((num: ceil(node.value.num / 2).abs.int, depth: node.value.depth + 1))
  node.next.prev = node
  node.next.next = oldNext
  oldNext.prev = node.next
  node.value.num = floor(node.value.num / 2).abs.int
  inc node.value.depth

proc explode(number: var Number, node: DoublyLinkedNode[NumberNode]) =
  if node.prev != nil:
    inc node.prev.value.num, node.value.num

  if node.next != nil and node.next.next != nil:
    inc node.next.next.value.num, node.next.value.num

  node.value.num = 0
  dec node.value.depth
  number.remove(node.next)

proc reduce(number: var Number) =
  echo number
  for n in number.nodes:
    if n.value.num >= 10:
      echo "split"
      n.split
      number.reduce
    elif n.value.depth == 5 and n.next != nil and n.next.value.depth == 5:
      echo "explode"
      number.explode(n)
      number.reduce

proc solveDay18*: IntSolution =
  var addedNumber = readInputNumbers().foldl(a + b)
  addedNumber.reduce()
  echo addedNumber
 
when isMainModule:
  echo solveDay18()
