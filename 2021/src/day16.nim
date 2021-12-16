import helpers, std/[bitops, sequtils, strutils]

type
  TypeId = enum
    tiSum, tiProduct, tiMinimum, tiMaximum, tiLiteral, tiGreaterThan, tiLessThan, tiEqualTo

  LengthTypeId = enum
    ltLength, ltCount

  Packet = object
    version: int
    case typeId: TypeId
      of tiLiteral: intVal: int
      of tiSum, tiProduct, tiMinimum, tiMaximum,
         tiGreaterThan, tiLessThan, tiEqualTo: children: seq[Packet]

func hexToBits(c: char): seq[int] =
  let hex = parseHexInt($c)
  for i in countdown(3, 0):
    result.add if hex.testBit(i): 1 else: 0

func bitsToInt(bits: seq[int]): int =
  for bit in bits:
    result = result shl 1 or bit

proc readInputBits: seq[int] =
  for c in readInputString(day = 16):
    result.add c.hexToBits

proc parsePacket(bits: seq[int], index: var int): Packet

func parseVersion(bits: seq[int], index: var int): int =
  result = bitsToInt(bits[index..index + 2])
  index.inc 3

func parseTypeId(bits: seq[int], index: var int): TypeId =
  result = 
    case bitsToInt(bits[index..index + 2]) 
      of 0: tiSum
      of 1: tiProduct
      of 2: tiMinimum
      of 3: tiMaximum
      of 4: tiLiteral
      of 5: tiGreaterThan
      of 6: tiLessThan
      of 7: tiEqualTo
      else: raise newException(OSError, "the request to the OS failed")

  index.inc 3

func parseLengthTypeId(bits: seq[int], index: var int): LengthTypeId =
  result = if bits[index] == 0: ltLength else: ltCount
  index.inc

func parseLiteralValue(bits: seq[int], index: var int): int =
  while true:
    for bit in bits[index + 1..index+4]:
      result = result shl 1 or bit

    index.inc 5

    if bits[index - 5] == 0:
      break

proc parseChildren(bits: seq[int], index: var int): seq[Packet] =
  case parseLengthTypeId(bits, index)
    of ltCount:
      let packetsCount = bitsToInt(bits[index..index + 10])
      index.inc 11

      while result.len < packetsCount:
        result.add parsePacket(bits, index)

    of ltLength:
      let packetsSize = bitsToInt(bits[index..index + 14])
      index.inc 15
      let start = index
      while index - start < packetsSize:
        result.add parsePacket(bits, index)

proc parsePacket(bits: seq[int], index: var int): Packet =
  let version = parseVersion(bits, index)
  let typeId = parseTypeId(bits, index)
  case typeId
    of tiLiteral:
      result = Packet(version: version, typeId: typeId, intVal: parseLiteralValue(bits, index))
    else:
      result = Packet(version: version, typeId: typeId, children: parseChildren(bits, index))

func part1(packet: Packet): int =
  result.inc packet.version

  case packet.typeId
    of tiLiteral:
      discard
    else:
      for child in packet.children:
        result.inc part1(child)

func part2(packet: Packet): int =
  result = 
    case packet.typeId
      of tiSum: packet.children.foldl(a + part2(b), 0)
      of tiProduct: packet.children.foldl(a * part2(b), 1)
      of tiMinimum: packet.children.mapIt(part2(it)).min
      of tiMaximum: packet.children.mapIt(part2(it)).max
      of tiLiteral: packet.intVal
      of tiGreaterThan:
        if part2(packet.children[0]) > part2(packet.children[1]): 1 else: 0
      of tiLessThan:
        if part2(packet.children[0]) < part2(packet.children[1]): 1 else: 0
      of tiEqualTo:
        if part2(packet.children[0]) == part2(packet.children[1]): 1 else: 0
      else: raise newException(OSError, "the request to the OS failed")

proc solveDay16*: IntSolution =
  let bits = readInputBits()
  var index = 0
  let packet = parsePacket(bits, index)
  result.part1 = part1(packet)
  result.part2 = part2(packet)
 
when isMainModule:
  echo solveDay16()
