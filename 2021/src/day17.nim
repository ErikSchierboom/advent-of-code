import helpers, std/[math, sequtils, strscans]

type 
  Area = tuple[topLeft, bottomRight: Point]
  Probe = tuple[x, y, dx, dy: int]

proc readInputTarget: Area =
  let (_, xmin, xmax, ymax, ymin) = readInputString(day = 17).scanTuple("target area: x=$i..$i, y=$i..$i")
  result.topLeft = (x: xmin, y: ymin)
  result.bottomRight = (x: xmax, y: ymax)

func inArea(probe: Probe, area: Area): bool {.inline.} =
  probe.x >= area.topLeft.x and probe.x <= area.bottomRight.x and
  probe.y >= area.topLeft.y and probe.y <= area.bottomRight.y

proc step(probe: var Probe) =
  inc probe.x, probe.dx
  inc probe.y, probe.dy
  if probe.dx > 0: dec probe.dx
  dec probe.dy

proc solveDay17*: IntSolution =
  let target = readInputTarget()

  result.part1 = low(int)

  for dx in 1..target.bottomRight.x:
    for dy in target.bottomRight.y..target.bottomRight.y.abs:
      var probe = (x: 0, y: 0, dx: dx, dy: dy)
      var maxY = probe.y
      while probe.x <= target.bottomRight.x and probe.y >= target.bottomRight.y:
        maxY = max(maxY, probe.y)
        if probe.x >= target.topLeft.x and probe.y <= target.topLeft.y:
          result.part1 = max(result.part1, maxY)
          inc result.part2
          break
        probe.step
 
when isMainModule:
  echo solveDay17()
