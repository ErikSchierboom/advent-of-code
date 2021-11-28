import std/[os,strutils,strformat]

type
  Day* = distinct int

proc `$` *(day: Day): string {.borrow.}

func filePath(day: Day): string =
  "input" / &"day{day}.txt"

proc readInputStrings*(day: Day): seq[string] =
  for line in day.filePath.lines:
    result.add(line)

proc readInputInts*(day: Day): seq[int] =
  for line in day.filePath.lines:
    result.add(parseInt(line))
