import std/strutils

proc toIntSeq*(lines: seq[string]): seq[int] =
  for line in lines:
    result.add(parseInt(line))
