import std/strutils

proc readInputStringSeq*(filename: string): seq[string] =
  for line in filename.lines:
    result.add line

proc readInputIntSeq*(filename: string): seq[int] =
  for line in filename.lines:
    result.add parseInt(line)
