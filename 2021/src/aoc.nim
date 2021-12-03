import macros, os, strutils

iterator days(): string =
  for file in os.walkDir("src"):
      var (_, name, ext) = splitFile(file.path)
      if ext == ".nim" and name.startsWith("day"):
        yield name

macro solveDays(): untyped =
  var includeStmt = newNimNode(nnkIncludeStmt)
  for day in days():
    includeStmt.add(ident(day))

  result = newStmtList(includeStmt)

solveDays()
