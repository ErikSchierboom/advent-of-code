import helpers, std/[math, strscans]

type 
  Player = tuple[pos, score: int]
  Game = tuple[p1, p2: Player, round, winningScore: int]

func won(game: Game, player: Player): bool {.inline.} = player.score >= game.winningScore
func won(game: Game): bool {.inline.} = game.won(game.p1) or game.won(game.p2)
func move(player: Player, round: int): int {.inline.} = floorMod((player.pos + (round.pred * 3) - 1), 10) + 1
func player1Turn(game: Game): bool {.inline.} = (game.round div 3) mod 2 == 1

proc parseInputGame(winningScore: int): Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1: (pos: p1Pos, score: 0), p2: (pos: p2Pos, score: 0), round: 0, winningScore: winningScore)

proc part1: int =
  var game = parseInputGame(winningScore = 1000)
  while not game.won:
    inc game.round, 3
    
    if game.player1Turn:
      game.p1.pos = move(game.p1, game.round)
      inc game.p1.score, game.p1.pos
    else:
      game.p2.pos = move(game.p2, game.round)
      inc game.p2.score, game.p2.pos

  result = min(game.p1.score, game.p2.score) * game.round

proc part2: int64 =
  var rolls: seq[int]
  var game = parseInputGame(winningScore = 21)

  proc determineWinCount(): tuple[p1Wins, p2Wins: int64] =
    if game.won(game.p1):
      inc result.p1Wins
    elif game.won(game.p2):
      inc result.p2Wins
    else:
      inc game.round

      for roll in 1..3:
        rolls.add roll

        if game.player1Turn:
          game.p1.pos = move(game.p1, game.round)
          inc game.p1.score, game.p1.pos
        else:
          game.p2.pos = move(game.p2, game.round)
          inc game.p2.score, game.p2.pos

        #     if newRolls.len == 3:
#           if ((game.round - 1) div 3) mod 2 == 0:

#     oldP1Pos = game.p1.pos; oldP1Score = game.p1.score
#     oldP2Pos = game.p2.pos; oldP2Score = game.p1.score

#     if game.round mod 2 == 1:
#       game.p1.pos = modulo(game.p1.pos + move, 10, 1)
#       inc game.p1.score, game.p1.pos
#     else:
#       game.p2.pos = modulo(game.p2.pos + move, 10, 1)
#       inc game.p2.score, game.p2.pos

        let winCount = determineWinCount()
        result.p1Wins = result.p1Wins + winCount.p1Wins
        result.p2Wins = result.p2Wins + winCount.p2Wins
        discard rolls.pop

      dec game.round
    
  let winCount = determineWinCount()
  result = if winCount.p1Wins > winCount.p2Wins: winCount.p1Wins else: winCount.p2Wins

proc solveDay21*: Solution[int, int64] =
  echo floorMod(-1, 4)
  result.part1 = part1()
  # result.part2 = part2()

when isMainModule:
  echo solveDay21()
