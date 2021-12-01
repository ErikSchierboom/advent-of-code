import std/[os,strutils,strformat]

type
  Day* = distinct Positive

func filename(day: Day): string =
  "input" / &"day{int(day)}.txt"

proc readStringSeq*(day: Day): seq[string] =
  for line in day.filename.lines:
    result.add(line)

proc readIntSeq*(day: Day): seq[int] =
  for line in day.filename.lines:
    result.add(parseInt(line))
