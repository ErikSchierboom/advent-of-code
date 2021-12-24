import helpers, std/strscans

type 
  Player = tuple[pos, score: int]
  Game = tuple[p1, p2: Player, round, winningScore: int]

func move(round: int): int = (round * 9 - 3) mod 10
func won(game: Game, player: Player): bool = player.score >= game.winningScore
func won(game: Game): bool = game.won(game.p1) or game.won(game.p2)
func modulo(x, y, offset: int): int = ((x - offset) mod y) + offset

proc parseInputGame(winningScore: int): Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1: (pos: p1Pos, score: 0), p2: (pos: p2Pos, score: 0), round: 0, winningScore: winningScore)

proc part1: int =
  var game = parseInputGame(winningScore = 1000)
  while not game.won:
    inc game.round

    if game.round mod 2 == 1:
      game.p1.pos = modulo(game.p1.pos + move(game.round), 10, 1)
      inc game.p1.score, game.p1.pos
    else:
      game.p2.pos = modulo(game.p2.pos + move(game.round), 10, 1)
      inc game.p2.score, game.p2.pos

  if game.won(game.p1):
    result = game.p2.score * game.round * 3
  else:
    result = game.p1.score * game.round * 3

proc part2: int =
  # proc playUntilWon(game: Game): tuple[p1Wins, p2Wins: int] =
  #   if game.won(game.p1):
  #     inc result.p1Wins
  #   elif game.won(game.p2):
  #     inc result.p2Wins
  #   else
  #     inc game.round

  #     for roll in 1..3:
  #       if game.round mod 2 == 1:
  #         game.p1.pos = ((game.p1.pos - 1 + move(game.round)) mod 10) + 1
  #         inc game.p1.score, game.p1.pos
  #       else:
  #         game.p2.pos = ((game.p2.pos - 1 + move(game.round)) mod 10) + 1
  #         inc game.p2.score, game.p2.pos
  #   echo ""

  # var game = parseInputGame(winningScore = 21)
  # for roll in 1..3:
  #   let wins = playUntilWon(game)
  # while not game.won:
  #   inc game.round

  #   if game.round mod 2 == 1:
  #     game.p1.pos = ((game.p1.pos - 1 + move(game.round)) mod 10) + 1
  #     inc game.p1.score, game.p1.pos
  #   else:
  #     game.p2.pos = ((game.p2.pos - 1 + move(game.round)) mod 10) + 1
  #     inc game.p2.score, game.p2.pos

  # result = (if game.won(game.p1): game.p2 else: game.p1).score * game.round * 3
  echo ""

proc solveDay21*: IntSolution =
  result.part1 = part1()
  result.part2 = part2()

when isMainModule:
  echo solveDay21()
