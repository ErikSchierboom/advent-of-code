import helpers, std/[math, strscans]

type 
  Player = tuple[pos, score: int]
  Game = tuple[p1, p2: Player, round, winningScore: int]

func modulo(x, y, offset: int): int {.inline.} = ((x - offset) mod y) + offset
func won(game: Game, player: Player): bool {.inline.} = player.score >= game.winningScore
func won(game: Game): bool {.inline.} = game.won(game.p1) or game.won(game.p2)
func move(player: Player, round: int): int {.inline.} = modulo(player.pos + (round.pred * 3) mod 10, 10, 1)
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

# proc part2: int64 =
#   var p1Wins, p2Wins: int64
#   var oldP1Pos, oldP1Score, oldP2Pos, oldP2Score: int
#   var rolls: seq[int]

#   var game = parseInputGame(winningScore = 21)
#   while not game.won:
#     inc game.round


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

#   result = if p1Wins > p2Wins: p1Wins else: p2Wins

proc solveDay21*: Solution[int, int64] =
  result.part1 = part1()
  # result.part2 = part2()

when isMainModule:
  echo solveDay21()
