import helpers, std/[sets, strscans, strutils, tables]

proc readInputGraph: Table[string, seq[string]] =
  for (_, start, stop) in readInputScans(day = 12, "$w-$w"):
    if result.hasKeyOrPut(start, @[stop]):
      result[start].add stop
    if result.hasKeyOrPut(stop, @[start]):
      result[stop].add start

func isSmall(node: string): bool {.inline.} = node[0].isLowerAscii

proc findNumPathsToEnd(graph: Table[string, seq[string]], visitSmallTwice: bool): int =
  proc findNumPaths(currentNode: string, currentPath: seq[string], visitedSmall: HashSet[string], visitSmallTwice: bool): int =
    if currentNode == "end":
      return 1
    elif currentNode == "start" and currentPath.len > 0:
      return 0
    elif not visitSmallTwice and currentNode in visitedSmall:
      return 0

    var newVisitedSmall = visitedSmall
    var newVisitSmallTwice = visitSmallTwice

    if currentNode.isSmall:
      if currentNode in visitedSmall:
        newVisitSmallTwice = false

      newVisitedSmall.incl currentNode

    var newPath = currentPath
    newPath.add currentNode

    for neighbor in graph[currentNode]:
      inc result, findNumPaths(neighbor, newPath, newVisitedSmall, newVisitSmallTwice)

  result = findNumPaths("start", @[], initHashSet[string](), visitSmallTwice)

proc solveDay12*: IntSolution =
  let graph = readInputGraph()
  result.part1 = findNumPathsToEnd(graph, visitSmallTwice = false)
  result.part2 = findNumPathsToEnd(graph, visitSmallTwice = true)
 
when isMainModule:
  echo solveDay12()
