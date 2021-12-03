import helpers, std/[macros, sequtils]

proc dayModuleImports(): NimNode =
  result = newNimNode(nnkIncludeStmt)

  for day in Day.low .. Day.high:
    result.add ident($day)

macro solveDays(): untyped =
  result = newStmtList(dayModuleImports())

when isMainModule:
  solveDays()
