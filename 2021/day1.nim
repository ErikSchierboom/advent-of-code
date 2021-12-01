import std/[math,strformat]
import input

let inputs = readInputInts(Day(1))

proc part1: int =
  for i in 0 ..< inputs.high:
    if inputs[i + 1] > inputs[i]:
      inc result

proc part2: int =
  for i in 0 ..< inputs.high - 2:
    if sum(inputs[i + 1 .. i + 3]) > sum(inputs[i .. i + 2]):
      inc result

echo &"1.1: {part1()}"
echo &"1.2: {part2()}"
