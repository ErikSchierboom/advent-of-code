import helpers, std/[sets, strscans, strutils, tables]

proc readInputAdjacencyMatrix: Table[string, seq[string]] =
  for (_, start, stop) in readInputScans(day = 12, "$w-$w"):
    if result.hasKeyOrPut(start, @[stop]): result[start].add stop
    if result.hasKeyOrPut(stop, @[start]): result[stop].add start

func findPaths(node: string, path: seq[string], visited: var HashSet[seq[string]], adjacencyMatrix: Table[string, seq[string]]): seq[seq[string]] =
  var newPath = path
  newPath.add node

  if newPath in visited:
    return

  if node == "end":
    visited.incl newPath
    return @[newPath]

  if node == node.toLowerAscii and node in path:
    return

  for neighbor in adjacencyMatrix.getOrDefault(node, @[]):
    for path in findPaths(neighbor, newPath, visited, adjacencyMatrix):
      result.add(path)

proc solveDay12*: IntSolution =
  let adjacencyMatrix = readInputAdjacencyMatrix()
  
  var visited: HashSet[seq[string]]
  let paths = findPaths("start", @[], visited, adjacencyMatrix)
  result.part1 = paths.len
 
when isMainModule:
  echo solveDay12()
