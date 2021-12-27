import helpers, std/[math, strscans, tables]

type 
  Player = tuple[pos, score: int]
  Game = tuple[p1, p2: Player, round, winningScore: int]

func won(game: Game, player: Player): bool {.inline.} = player.score >= game.winningScore
func move(player: Player, steps: int): int {.inline.} = floorMod((player.pos + steps - 1), 10) + 1
func player1Turn(game: Game): bool {.inline.} = (game.round div 3) mod 2 == 1

proc parseInputGame(winningScore: int): Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1: (pos: p1Pos, score: 0), p2: (pos: p2Pos, score: 0), round: 0, winningScore: winningScore)

proc part1: int =
  var game = parseInputGame(winningScore = 1000)
  while not game.won(game.p1) or game.won(game.p2):
    inc game.round, 3
    
    if game.player1Turn:
      game.p1.pos = move(game.p1, game.round.pred * 3)
      inc game.p1.score, game.p1.pos
    else:
      game.p2.pos = move(game.p2, game.round.pred * 3)
      inc game.p2.score, game.p2.pos

  result = min(game.p1.score, game.p2.score) * game.round

proc part2: int64 =
  const moveFreqs = {3:1, 4:3, 5:6, 6:7, 7:6, 8:3, 9:1}.toTable

  proc determineWinCount(game: Game): tuple[p1Wins, p2Wins: int64] =
    for steps, count in moveFreqs:
      var newGame = game
      inc newGame.round, 3

      if newGame.player1Turn:
        newGame.p1.pos = move(newGame.p1, steps)
        inc newGame.p1.score, newGame.p1.pos
      else:
        newGame.p2.pos = move(newGame.p2, steps)
        inc newGame.p2.score, newGame.p2.pos

      if newGame.won(newGame.p1):
        inc result.p1Wins
      elif newGame.won(newGame.p2):
        inc result.p2Wins
      else:
        let winCount = determineWinCount(newGame)
        result.p1Wins = result.p1Wins + count * winCount.p1Wins
        result.p2Wins = result.p2Wins + count * winCount.p2Wins

  let game = parseInputGame(winningScore = 21)
  let winCount = determineWinCount(game)
  result = if winCount.p1Wins > winCount.p2Wins: winCount.p1Wins else: winCount.p2Wins

proc solveDay21*: Solution[int, int64] =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay21()
