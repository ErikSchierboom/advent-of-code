import helpers, std/strscans

type 
  Player = tuple[pos, score: int]
  Game = tuple[p1, p2: Player, round, winningScore: int]

func move(round: int): int = (round * 9 - 3) mod 10
func won(game: Game, player: Player): bool = player.score >= game.winningScore
func won(game: Game): bool = game.won(game.p1) or game.won(game.p2)

proc parseInputGame(winningScore: int): Game =
  let (_, p1Pos, p2Pos) = readInputString(day = 21).scanTuple("Player 1 starting position: $i\nPlayer 2 starting position: $i")
  (p1: (pos: p1Pos, score: 0), p2: (pos: p2Pos, score: 0), round: 0, winningScore: winningScore)

proc play(game: var Game) =
  inc game.round

  if game.round mod 2 == 1:
    game.p1.pos = ((game.p1.pos - 1 + move(game.round)) mod 10) + 1
    inc game.p1.score, game.p1.pos
  else:
    game.p2.pos = ((game.p2.pos - 1 + move(game.round)) mod 10) + 1
    inc game.p2.score, game.p2.pos

proc part1: int =
  var game = parseInputGame(winningScore = 1000)
  while not game.won:
    game.play()

  result = (if game.won(game.p1): game.p2 else: game.p1).score * game.round * 3



proc solveDay21*: IntSolution =
  result.part1 = part1()

when isMainModule:
  echo solveDay21()
