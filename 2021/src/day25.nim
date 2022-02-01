import helpers, std/[math, sequtils]

func step(region: var seq[seq[char]]): bool =
  let width = region[0].len
  let height = region.len

  var old = region

  for y in 0 ..< height:
    for x in 0 ..< width:
      if old[y][x] == '>':
        if old[y][floorMod(x + 1, width)] == '.':
          swap(region[y][floorMod(x + 1, width)], region[y][x])
          result = true
        else:
          region[y][x] = '>'

  old = region

  for x in 0 ..< width:
    for y in 0 ..< height:    
      if old[y][x] == 'v':
        if old[floorMod(y + 1, height)][x] == '.':
          swap(region[floorMod(y + 1, height)][x], region[y][x])
          result = true
        else:
          region[y][x] = 'v'

proc solveDay25*: IntSolution =
  var region = readInputStrings(day = 25).toSeq.mapIt(it.toSeq)
  
  while region.step:
    inc result.part1

  inc result.part1

when isMainModule:
  echo solveDay25()