import helpers, std/sequtils

func bitFrequencies(bitsSeq: seq[seq[int]]): seq[int] =
  result = newSeq[int](bitsSeq[0].len)

  for bits in bitsSeq:
    for i in result.low .. result.high:
      if bits[i] == 1:
        inc result[i]
      else:
        dec result[i]

func mostCommonBits(frequencies: seq[int]): seq[int] =
  frequencies.mapIt(if it >= 0: 1 else: 0)

func leastCommonBits(frequencies: seq[int]): seq[int] =
  frequencies.mapIt(if it >= 0: 0 else: 1)

func bitsToInt(bits: seq[int]): int = bits.foldl(a shl 1 or b, 0)

proc findBits(bitsSeq: seq[seq[int]], strategy: proc (frequencies: seq[int]): seq[int]): int =
  var index = 0
  var remaining = bitsSeq

  while remaining.len > 1:
    let strategyBits = strategy(remaining.bitFrequencies())
    remaining.keepItIf(it[index] == strategyBits[index])
    inc index

  result = bitsToInt(remaining[0])

proc part1(bitsSeq: seq[seq[int]]): int =
  let frequencies = bitsSeq.bitFrequencies()
  let gammaRate = frequencies.mostCommonBits().bitsToInt()
  let epsilonRate = frequencies.leastCommonBits().bitsToInt()

  result = gammaRate * epsilonRate

proc part2(bitsSeq: seq[seq[int]]): int =
  let oxygenGeneratorRating = findBits(bitsSeq, mostCommonBits)
  let co2ScrubberRating = findBits(bitsSeq, leastCommonBits)

  result = oxygenGeneratorRating * co2ScrubberRating

proc solveDay3*: IntSolution =
  let bitsSeq = readInputBinaryNums(day = 3).toSeq
  result.part1 = part1(bitsSeq)
  result.part2 = part2(bitsSeq)

when isMainModule:
  echo solveDay3()
