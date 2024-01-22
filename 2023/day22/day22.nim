import std/[algorithm, deques, sequtils, sets, strscans, strformat, strutils, math, tables]

type
  Range = tuple[min, max: int]
  Brick = tuple[z, y, x: Range, supports, supportedBy: HashSet[int]]
  Structure = tuple[bricks: seq[Brick], supports, supportedBy: Table[int, HashSet[int]]]

func overlaps(l, r: Range): bool = l.min <= r.max and r.min <= l.max
func overlaps(l, r: Brick): bool = overlaps(l.x, r.x) and overlaps(l.y, r.y)
func supports(bottom, top: Brick): bool = bottom.z.max + 1 == top.z.min

proc settle(structure: var Structure) =
  structure.bricks.sort()

  for i, brick in structure.bricks.mpairs:
    var settleAt = 1

    for precedingBrick in structure.bricks[0..<i]:
      if brick.overlaps(precedingBrick):
        settleAt = max(settleAt, precedingBrick.z.max + 1)

    let fell = brick.z.min - settleAt
    brick.z.min -= fell
    brick.z.max -= fell

proc analyze(structure: var Structure) =
  for i, brick in structure.bricks.pairs:
    for j in i+1..structure.bricks.high:
      let followingBrick = structure.bricks[j]
      if brick.overlaps(followingBrick) and brick.supports(followingBrick):
        structure.supports[i].incl(j)
        structure.supportedBy[j].incl(i)

func parseBrick(line: string): Brick =
  discard line.scanf("$i,$i,$i~$i,$i,$i", result.x.min, result.y.min, result.z.min, result.x.max, result.y.max, result.z.max)

proc parseStructure: Structure =
  for i, line in readFile("input.txt").splitLines.toSeq.pairs:
    result.bricks.add parseBrick(line)
    result.supports[i] = initHashSet[int]()
    result.supportedBy[i] = initHashSet[int]()
  
  result.settle()
  result.analyze()

func countDisintegrations(structure: Structure): seq[int] =
  for i in 0..<structure.bricks.len:
    var disintegrated: HashSet[int]
    var disintegrating: Deque[int]
    disintegrating.addLast(i)

    while disintegrating.len > 0:
      let brick = disintegrating.popFirst()
      disintegrated.incl(brick)

      for supported in structure.supports[brick]:
        if structure.supportedBy[supported] <= disintegrated:
          disintegrating.addLast(supported)

    result.add(disintegrated.len - 1)

let structure = parseStructure()
let disintegrations = structure.countDisintegrations()

echo &"part a: {disintegrations.countIt(it == 0)}"
echo &"part b: {disintegrations.sum()}"
