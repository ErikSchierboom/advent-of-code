import helpers, std/[bitops, heapqueue, sequtils, strutils, tables]

type
  TypeId = enum
    tiLiteral, tiOperator

  LengthTypeId = enum
    ltLength, ltCount

  Packet = object
    version: int
    case typeId: TypeId
      of tiLiteral: intVal: int
      of tiOperator: children: seq[Packet]

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
  result = if bitsToInt(bits[index..index + 2]) == 4: tiLiteral else: tiOperator
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
    of tiOperator:
      result = Packet(version: version, typeId: typeId, children: parseChildren(bits, index))

func part1(packet: Packet): int =
  result.inc packet.version

  case packet.typeId
    of tiLiteral:
      discard
    of tiOperator:
      for child in packet.children:
        result.inc part1(child)

proc solveDay16*: IntSolution =
  let bits = readInputBits()
  var index = 0
  let packet = parsePacket(bits, index)
  result.part1 = part1(packet)
  # result.part2 = shortestPath(initGrid(cells, dimension = 5))
 
when isMainModule:
  echo solveDay16()
