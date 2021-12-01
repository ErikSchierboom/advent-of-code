import std/math
import input

func part1(depths: seq[int]): int =
  for i in 0 ..< depths.high:
    if depths[i + 1] > depths[i]:
      inc result

func part2(depths: seq[int]): int =
  for i in 0 ..< depths.high - 2:
    if sum(depths[i + 1 .. i + 3]) > sum(depths[i .. i + 2]):
      inc result

when isMainModule:
  let depths = readIntSeq(Day(1))
  echo part1(depths)
  echo part2(depths)
