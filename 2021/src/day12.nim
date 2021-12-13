import helpers, std/[sets, strscans, strutils, tables]

proc readInputGraph: Table[string, seq[string]] =
  for (_, start, stop) in readInputScans(day = 12, "$w-$w"):
    if result.hasKeyOrPut(start, @[stop]):
      result[start].add stop
    if result.hasKeyOrPut(stop, @[start]):
      result[stop].add start

func isSmall(node: string): bool {.inline.} = node[0].isLowerAscii

func findNumPathsToEnd(graph: Table[string, seq[string]], visitSmallTwice: bool): int =
  func findNumPaths(currentNode: string, currentPath: seq[string], visitedSmall: HashSet[string], visitSmallTwice: bool): int =
    if currentNode == "end":
      return 1
    elif currentNode == "start" and currentPath.len > 0:
      return 0
    elif currentNode in visitedSmall and not visitSmallTwice:
      return 0

    var newVisitedSmall = visitedSmall
    var newVisitSmallTwice = visitSmallTwice

    if currentNode.isSmall:
      newVisitSmallTwice = currentNode notin visitedSmall
      newVisitedSmall.incl currentNode

    var newPath = currentPath
    newPath.add currentNode

    for neighbor in graph.getOrDefault(currentNode, @[]):
      inc result, findNumPaths(neighbor, newPath, newVisitedSmall, newVisitSmallTwice)

  result = findNumPaths("start", @[], initHashSet[string](), visitSmallTwice)

proc solveDay12*: IntSolution =
  let graph = readInputGraph()
  result.part1 = findNumPathsToEnd(graph, visitSmallTwice = false)
  result.part2 = findNumPathsToEnd(graph, visitSmallTwice = true)
 
when isMainModule:
  echo solveDay12()
