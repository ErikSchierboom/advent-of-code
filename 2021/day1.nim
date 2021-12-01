import input

let inputs = readInputInts(Day(1))

proc part1: int =
  for i in 1 .. inputs.high:
    if inputs[i] > inputs[i - 1]:
      inc result

echo $part1()
