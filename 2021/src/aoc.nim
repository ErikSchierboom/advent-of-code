import std/[algorithm, macros, os, sequtils, strutils]

proc days(): seq[string] =
  for file in os.walkDir("src"):
      var (_, name, ext) = splitFile(file.path)
      if ext == ".nim" and name.startsWith("day"):
        result.add name

  result.sort()

macro solveDays(): untyped =
  result = newStmtList(newNimNode(nnkIncludeStmt).add(days().mapIt(ident(it))))

when isMainModule:
  solveDays()
