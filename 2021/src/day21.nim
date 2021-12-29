import helpers, std/[math, strscans, tables]

type Game = tuple[p1Pos, p1Score, p2Pos, p2Score, round: int]

func move(pos, steps: int): int {.inline.} = floorMod((pos + steps - 1), 10) + 1
func player1Turn(game: Game): bool {.inline.} = (game.round div 3) mod 2 == 1

proc parseInputGame: Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1Pos: p1Pos, p1Score: 0, p2Pos: p2Pos, p2Score: 0, round: 0)

proc part1: int =
  var (p1Pos, p1Score, p2Pos, p2Score, round) = parseInputGame()
  while p1Score < 1000 and p2Score < 1000:
    inc round
    
    if round mod 2 == 1:
      p1Pos = move(p1Pos, (round * 3).pred * 3)
      inc p1Score, p1Pos
    else:
      p2Pos = move(p2Pos, (round * 3).pred * 3)
      inc p2Score, p2Pos

  result = min(p1Score, p2Score) * round * 3

proc part2: int64 =
  const moveFreqs = {3:1, 4:3, 5:6, 6:7, 7:6, 8:3, 9:1}.toTable

  proc determineWinCount(game: Game, paths: int): tuple[p1Wins, p2Wins: int64] =
    for steps, count in moveFreqs:
      var newGame = game
      inc newGame.round, 3

      if newGame.player1Turn:
        newGame.p1Pos = move(newGame.p1Pos, steps)
        inc newGame.p1Score, newGame.p1Pos
      else:
        newGame.p2Pos = move(newGame.p2Pos, steps)
        inc newGame.p2Score, newGame.p2Pos

      if newGame.p1Score >= 21:
        inc result.p1Wins, paths * count
      elif newGame.p2Score >= 21:
        inc result.p2Wins, paths * count
      else:
        let winCount = determineWinCount(newGame, paths * count)
        result.p1Wins = result.p1Wins + winCount.p1Wins
        result.p2Wins = result.p2Wins + winCount.p2Wins

  let game = parseInputGame()
  let winCount = determineWinCount(game, 1)
  result = if winCount.p1Wins > winCount.p2Wins: winCount.p1Wins else: winCount.p2Wins

proc solveDay21*: Solution[int, int64] =
  result.part1 = part1()
  # result.part2 = part2()

when isMainModule:
  echo solveDay21()
