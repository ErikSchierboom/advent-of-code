import helpers, std/[macros, monotimes, strformat, strutils, times]

template timeIt(day: Day, body: untyped) =
  block:
    let before = getMonoTime()
    discard body
    let after = getMonoTime()
    let duration = after - before
    echo "Day" & intToStr(day, 2) & ": " & $duration.inMilliseconds & "ms"

macro timeSolve(): untyped =
  result = newStmtList()

  var importStmt = newNimNode(nnkImportStmt)
  result.add(importStmt)

  for day in Day.low .. Day.high:
    importStmt.add ident($day)

    var callStmt = newCall(
      ident("timeIt"),
      newNimNode(nnkExprEqExpr)
        .add(ident("day"))
        .add(newIntLitNode(day)),
      newStmtList()
        .add(newCall(ident("solve" & ($day).replace('d', 'D'))))
    )

    result.add(callStmt)

when isMainModule:
  timeSolve()
