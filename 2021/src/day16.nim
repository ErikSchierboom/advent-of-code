import helpers, std/[bitops, sequtils, strutils]

type
  TypeId = enum
    tiSum, tiProduct, tiMinimum, tiMaximum, tiLiteral, tiGreaterThan, tiLessThan, tiEqualTo

  LengthTypeId = enum
    ltLength, ltCount

  Packet = object
    version: int
    case typeId: TypeId
      of tiLiteral:
        intVal: int
      of tiSum, tiProduct, tiMinimum, tiMaximum, tiGreaterThan, tiLessThan, tiEqualTo:
        children: seq[Packet]

  BitReader = ref object
    bits: seq[int]
    index*: int

proc newBitReader(hex: string): BitReader =
  var bits: seq[int]
  for c in readInputString(day = 16):
    let hex = parseHexInt($c)
    for i in countdown(3, 0):
      bits.add if hex.testBit(i): 1 else: 0

  BitReader(bits: bits, index: 0)

proc parseNum(reader: BitReader, count: int): int =
  for i in reader.index ..< reader.index + count:
    result = result shl 1 or reader.bits[i]
    reader.index.inc

proc parsePacket(reader: BitReader): Packet
proc parseVersion(reader: BitReader): int = reader.parseNum(3)
proc parseTypeId(reader: BitReader): TypeId = TypeId(reader.parseNum(3))
proc parseLengthTypeId(reader: BitReader): LengthTypeId = LengthTypeId(reader.parseNum(1))

proc parseLiteralValue(reader: BitReader): int =
  while true:
    let lastPacket = reader.parseNum(1) == 0
    result = result shl 4 or reader.parseNum(4)
    if lastPacket:
      break

proc parseChildren(reader: BitReader): seq[Packet] =
  case reader.parseLengthTypeId()
    of ltCount:
      let packetsCount = reader.parseNum(11)
      while result.len < packetsCount:
        result.add reader.parsePacket()
    of ltLength:
      let endIndex = reader.parseNum(15) + reader.index
      while reader.index < endIndex:
        result.add reader.parsePacket()

proc parsePacket(reader: BitReader): Packet =
  let version = reader.parseVersion()
  let typeId = reader.parseTypeId()
  case typeId
    of tiLiteral:
      Packet(version: version, typeId: typeId, intVal: reader.parseLiteralValue())
    else:
      Packet(version: version, typeId: typeId, children: reader.parseChildren())

func part1(packet: Packet): int =
  result.inc packet.version

  if packet.typeId in {tiSum, tiProduct, tiMinimum, tiMaximum, tiGreaterThan, tiLessThan, tiEqualTo}:
    for child in packet.children:
      result.inc part1(child)

func part2(packet: Packet): int =
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

proc solveDay16*: IntSolution =
  let bitReader = newBitReader(readInputString(day = 16))
  let packet = bitReader.parsePacket()
  result.part1 = part1(packet)
  result.part2 = part2(packet)
 
when isMainModule:
  echo solveDay16()
