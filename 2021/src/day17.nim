import helpers, std/strscans

proc solveDay17*: IntSolution =
  let (_, stopXMin, stopXMax, stopYMax, stopYMin) = readInputString(day = 17).scanTuple("target area: x=$i..$i, y=$i..$i")
  result.part1 = low(int)

  for startDx in 1..stopXMax:
    for startDy in stopYMax..stopYMax.abs:
      var x, y = 0; var dx = startDx; var dy = startDy; var yMax = y
      while x <= stopXMax and y >= stopYMax:
        yMax = max(yMax, y)
        if x >= stopXMin and y <= stopYMin:
          result.part1 = max(result.part1, yMax)
          inc result.part2
          break

        inc x, dx
        inc y, dy
        if dx > 0: dec dx
        dec dy
 
when isMainModule:
  echo solveDay17()
