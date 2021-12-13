import helpers, std/[sequtils, sets, strscans, strutils]

func parsePaper(input: string): HashSet[Point] =
  for line in input.splitLines:
    let (_, x, y) = line.scanTuple("$i,$i")
    result.incl (x: x, y: y)

func parseFolds(input: string): seq[tuple[axis: char, at: int]] =
  for line in input.splitLines:
    let (_, axis, at) = line.scanTuple("fold along $c=$i")
    result.add (axis: axis, at: at)

func foldPaper(paper: HashSet[Point], fold: tuple[axis: char, at: int]): HashSet[Point] =
  for dot in paper:
    if fold.axis == 'x' and dot.x > fold.at:
      result.incl (x: fold.at - (dot.x - fold.at), y: dot.y)
    elif fold.axis == 'y' and dot.y > fold.at:
      result.incl (x: dot.x, y: fold.at - (dot.y - fold.at))
    else:
      result.incl dot

func `$`(paper: HashSet[Point]): string =
  let points = paper.toSeq
  let xs = points.mapIt(it.x)
  let ys = points.mapIt(it.y)
  for y in ys.min..ys.max:
    for x in xs.min..xs.max:
      result.add if paper.contains((x: x, y: y)): '#' else: '.'

    result.add '\n'

func part1(paper: HashSet[Point], folds: seq[tuple[axis: char, at: int]]): int =
  foldPaper(paper, folds[0]).len

proc part2(paper: HashSet[Point], folds: seq[tuple[axis: char, at: int]]): string =
  $folds.foldl(foldPaper(a, b), paper)

proc solveDay13*: Solution[int, string] =
  let parts = readInputString(day = 13).split("\n\n")
  let paper = parsePaper(parts[0])
  let folds = parseFolds(parts[1])

  result.part1 = part1(paper, folds)
  result.part2 = part2(paper, folds)
 
when isMainModule:
  echo solveDay13()
