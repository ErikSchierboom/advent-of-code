import algorithm, sequtils, strformat

let minRange = 235_741
let maxRange = 706_948

func digits(number: int): seq[int] =
  var remainder = number

  while remainder > 0:
    result.add(remainder mod 10)
    remainder = remainder div 10

  result.reverse()

proc matchesRules(candidate: int): bool =
  let digits = candidate.digits()
  var hasPair = false

  for i in digits.low ..< digits.high:
    echo $i

    if digits[i + 1] < digits[i]:
      return false

    if digits[i + 1] == digits[i]:
      hasPair = true

  hasPair

iterator candidates: int = 
  for candidate in minRange..maxRange:
    let digits = candidate.digits()
    var hasPair = false
    var consecutive = true

    break

    # for i in digits.low ..< digits.high:
    #   if digits[i + 1] < digits[i]:
    #     consecutive = false

    #   if digits[i + 1] == digits[i]:
    #     hasPair = true

    # if hasPair and consecutive:
    #   yield candidate

echo &"{matchesRules(111111)}"
echo &"{matchesRules(223450)}"
echo &"{matchesRules(123789)}"

proc part1(): int = toSeq(candidates).len()

proc part2(): int = 0

echo &"day 4: {part1()}, {part2()}"