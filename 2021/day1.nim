import std/[math, os, strutils]
import helpers

func part1(depths: seq[int]): int =
  for i in 0 ..< depths.high:
    if depths[i + 1] > depths[i]:
      inc result

func part2(depths: seq[int]): int =
  for i in 0 ..< depths.high - 2:
    if sum(depths[i + 1 .. i + 3]) > sum(depths[i .. i + 2]):
      inc result

when isMainModule:
  const depths = staticRead("input" / "day1.txt").splitLines.toIntSeq
  echo part1(depths)
  echo part2(depths)
