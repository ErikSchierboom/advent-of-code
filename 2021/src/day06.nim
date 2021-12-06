import helpers, std/[math, sequtils, strutils]

proc readInitialState: array[9, int] =
  for timer in readInputString(day = 6).split(',').mapIt(parseInt($it)):
    inc result[timer]

func simulateDay(state: var array[9, int]) =
  let old = state

  for i in countdown(state.high, state.low):
    # TODO: mod
    if i == 0:
      state[8] = old[0]
      inc state[6], old[0]
    else:
      state[i - 1] = old[i]

proc part1(state: var array[9, int]): int =
  for i in 0..<80:
    echo state
    state.simulateDay()

  result = state.sum
  echo result

proc solveDay6*: IntSolution =
  var state = readInitialState()
  result.part1 = part1(state)
  result.part2 = 1

when isMainModule:
  echo solveDay6()
