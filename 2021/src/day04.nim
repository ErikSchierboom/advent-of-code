import helpers, std/[deques, sets, sequtils, strutils]

type
  Board = ref object
    rows: seq[HashSet[int]]
    cols: seq[HashSet[int]]
  Game = ref object
    boards: seq[Board]
    drawNumbers: Deque[int]

func unmarkedSum(board: Board): int =
  for i in board.rows.concat(board.cols).foldl(a + b):
    result.inc i

func hasWon(board: Board): bool =
  board.rows.anyIt(it.len == 0) or board.cols.anyIt(it.len == 0)

proc crossNumber(board: Board, number: int): void =
  for i in board.rows.low .. board.rows.high:
    board.rows[i].excl(number)

  for j in board.cols.low .. board.cols.high:
    board.cols[j].excl(number)

func transpose[T](s: seq[seq[T]]): seq[seq[T]] =
  result = newSeq[seq[T]](s[0].len)
  for i in 0 .. s[0].high:
    result[i] = newSeq[T](s.len)
    for j in 0 .. s.high:
      result[i][j] = s[j][i]

func parseBoard(board: string): Board =
  result = new(Board)
  result.rows = newSeq[HashSet[int]]()
  let lines = board.splitLines
  let rows = lines.mapIt(it.splitWhitespace.map(parseInt))
  
  result.rows = rows.mapIt(it.toHashSet)
  result.cols = rows.transpose.mapIt(it.toHashSet)

proc readInputGame: Game =
  result = new(Game)
  let groups = readInputString(day = 4).split("\n\n")  
  result.boards = groups[1..groups.high].map(parseBoard)
  result.drawNumbers = groups[0].split(',').map(parseInt).toDeque

proc part1(game: Game): int =
  while true:
    let drawnNumber = game.drawNumbers.popFirst()
    for board in game.boards:
      board.crossNumber(drawnNumber)
      if board.hasWon:
        return board.unmarkedSum * drawnNumber

proc solveDay4*: IntSolution =
  var game = readInputGame()
  result.part1 = part1(game)

when isMainModule:
  echo solveDay4()
