import helpers, std/[math, sequtils, strutils]

proc readInitialState: array[9, uint64] =
  for timer in readInputString(day = 6).split(',').mapIt(parseBiggestUInt($it)):
    inc result[timer]

func simulateDay(state: var array[9, uint64]) =
  let old = state

  for i in countdown(state.high, state.low):
    # TODO: mod
    if i == 0:
      state[8] = old[0]
      state[6] += old[0]
    else:
      state[i - 1] = old[i]

proc part1(state: var array[9, uint64]): uint64 =
  for i in 0..<80:
    echo state
    state.simulateDay()

  result = state.sum
  echo result

proc part2(state: var array[9, uint64]): uint64 =
  for i in 0..<256:
    echo state
    state.simulateDay()

  result = state.sum
  echo result

proc solveDay6*: Solution[uint64, uint64] =
  var state = readInitialState()
  for i in 1..256:
    state.simulateDay()

    if i == 80:
      result.part1 = state.sum
    elif i == 256:
      result.part2 = state.sum

  # result.part1 = part1(state)
  # result.part2 = part2(state)

when isMainModule:
  echo solveDay6()
