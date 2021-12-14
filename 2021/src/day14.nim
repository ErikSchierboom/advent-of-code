import helpers, std/[sequtils, strscans, tables]

proc readInput: tuple[polymer: CountTable[string], insertionRules: Table[string, array[2, string]]] =
  let lines = readInputStrings(day = 14).toSeq
  
  for i in lines[0].low ..< lines[0].high:
    result.polymer.inc lines[0][i..i + 1]
  
  for i in 2..lines.high:
    let (_, source, destination) = lines[i].scanTuple("$w -> $c")
    result.insertionRules[source] = [source[0] & destination, destination & source[1]]

proc applyRules(polymer: CountTable[string], insertionRules: Table[string, array[2, string]]): CountTable[string] =
  for (pair, count) in polymer.pairs:
    if pair in insertionRules:
      result.inc insertionRules[pair][0], count
      result.inc insertionRules[pair][1], count
    else:
      result.inc pair, count

proc minMaxDifference(polymer: CountTable[string]): int =  
  var charCounts: CountTable[char]
  for pair, count in polymer:
    charCounts.inc pair[0], count

  let counts = charCounts.values.toSeq
  result = counts.max - counts.min - 1

proc solveDay14*: IntSolution =
  var (polymer, insertionRules) = readInput()
  for i in 1..40:
    polymer = applyRules(polymer, insertionRules)
    if i == 10:
      result.part1 = minMaxDifference(polymer)
    elif i == 40:
      result.part2 = minMaxDifference(polymer)
 
when isMainModule:
  echo solveDay14()
