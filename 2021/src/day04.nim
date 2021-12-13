import helpers, std/[deques, sets, sequtils, strutils]

type
  Board = object
    rows: seq[HashSet[int]]
    cols: seq[HashSet[int]]
  Game = object
    drawnNumbers: Deque[int]
    boards: seq[Board]

func unmarkedSum(board: Board): int =
  for i in board.rows.concat(board.cols).foldl(a + b):
    result.inc i

func won(board: Board): bool =
  board.rows.anyIt(it.len == 0) or
  board.cols.anyIt(it.len == 0)

proc crossNumber(board: var Board, drawnNumber: int): void =
  for i in board.rows.low .. board.rows.high:
    board.rows[i].excl(drawnNumber)

  for j in board.cols.low .. board.cols.high:
    board.cols[j].excl(drawnNumber)

func parseBoard(board: string): Board =
  let rows = board.splitLines.mapIt(it.splitWhitespace.map(parseInt))
  result.rows = rows.mapIt(it.toHashSet)
  result.cols = rows.transpose.mapIt(it.toHashSet)

proc parseGame: Game =
  let groups = readInputString(day = 4).split("\n\n")  
  result.drawnNumbers = groups[0].splitToInts.toSeq.toDeque
  result.boards = groups[1..groups.high].map(parseBoard)

proc solveDay04*: IntSolution =
  var game = parseGame()
  
  while game.boards.len > 0:
    let drawnNumber = game.drawnNumbers.popFirst()
    for i in countdown(game.boards.high, game.boards.low):
      game.boards[i].crossNumber(drawnNumber)

      if game.boards[i].won:
        if result.part1 == 0:
          result.part1 = game.boards[i].unmarkedSum * drawnNumber
        elif game.boards.len == 1:
          result.part2 = game.boards[i].unmarkedSum * drawnNumber

        game.boards.delete(i)

when isMainModule:
  echo solveDay04()
