import helpers, std/[sets, strscans, strutils, tables]

proc readInputGraph: TableRef[string, HashSet[string]] =
  result = newTable[string, HashSet[string]]()
  for (_, start, stop) in readInputScans(day = 12, "$w-$w"):
    result.mgetOrPut(start, [stop].toHashSet).incl stop
    result.mgetOrPut(stop, [start].toHashSet).incl start

func isSmall(node: string): bool {.inline.} = node[0].isLowerAscii

proc findNumPathsFromStartToEnd(graph: TableRef[string, HashSet[string]], visitSmallTwice: bool): int =
  proc findNumPaths(graph: TableRef[string, HashSet[string]], currentCave: string, visitedSmall: var HashSet[string], visitSmallTwice: bool): int =
    if currentCave == "end":
      return 1
    elif currentCave == "start" and currentCave in visitedSmall:
      return 0
    elif currentCave.isSmall:
      visitedSmall.incl currentCave

    for adjacentCave in graph[currentCave]:
      if adjacentCave notin visitedSmall:
        result.inc graph.findNumPaths(adjacentCave, visitedSmall, visitSmallTwice)
        visitedSmall.excl adjacentCave
      elif visitSmallTwice and adjacentCave.isSmall:
        result.inc graph.findNumPaths(adjacentCave, visitedSmall, false)

  var visited: HashSet[string]
  result = graph.findNumPaths("start", visited, visitSmallTwice)

proc solveDay12*: IntSolution =
  let graph = readInputGraph()  
  result.part1 = graph.findNumPathsFromStartToEnd(visitSmallTwice = false)
  result.part2 = graph.findNumPathsFromStartToEnd(visitSmallTwice = true)
 
when isMainModule:
  echo solveDay12()
