import helpers, std/[math, strscans, tables]

type Game = tuple[p1Pos, p1Score, p2Pos, p2Score, round: int]

func mod1(x, y: int): int = floorMod(x - 1, y) + 1
func move(pos, steps: int): int {.inline.} = mod1(pos + steps, 10)

proc parseInputGame: Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1Pos: p1Pos, p1Score: 0, p2Pos: p2Pos, p2Score: 0, round: 0)

proc part1: int =
  const winningScore = 1000
  var (p1Pos, p1Score, p2Pos, p2Score, round) = parseInputGame()
  while p1Score < winningScore and p2Score < winningScore:
    inc round
    
    if round mod 2 == 1:
      p1Pos = move(p1Pos, (round * 3).pred * 3)
      inc p1Score, p1Pos
    else:
      p2Pos = move(p2Pos, (round * 3).pred * 3)
      inc p2Score, p2Pos

  result = min(p1Score, p2Score) * round * 3

proc part2: int64 =
  const winningScore = 21
  const pathFreqs = {3:1, 4:3, 5:6, 6:7, 7:6, 8:3, 9:1}.toTable

  # proc determineWinCount(p1Pos, p1Score, p2Pos, p2Score, round, paths: int): tuple[p1Wins, p2Wins: int64] =
  proc determineWinCount(game: Game, paths: int): tuple[p1Wins, p2Wins: int64] =
    for steps, freq in pathFreqs:
      # var (newP1Pos, newP1Score, newP2Pos, newP2Score, newRound) = (p1Pos, p1Score, p2Pos, p2Score, round)
      var newGame = game
      inc newGame.round
    
      if newGame.round mod 2 == 1:
        newGame.p1Pos = move(newGame.p1Pos, steps)
        inc newGame.p1Score, newGame.p1Pos
      else:
        newGame.p2Pos = move(newGame.p2Pos, steps)
        inc newGame.p2Score, newGame.p2Pos

      if newGame.p1Score >= winningScore:
        inc result.p1Wins, paths * freq
      elif newGame.p2Score >= winningScore:
        inc result.p2Wins, paths * freq
      else:
        let (p1Wins, p2Wins) = determineWinCount(newGame, paths * freq)
        result.p1Wins += p1Wins
        result.p2Wins += p2Wins

  let (p1Wins, p2Wins) = determineWinCount(parseInputGame(), 1)
  result = max(p1Wins, p2Wins)

proc solveDay21*: Solution[int, int64] =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay21()
