import helpers, std/math

proc readInitialState: array[9, int] =
  for timer in readInputString(day = 6).splitToInts():
    inc result[timer]

func simulate(state: var array[9, int]) =
  let zeros = state[0]

  for i in 1 .. state.high:
    state[i - 1] = state[i]

  state[8] = zeros
  state[6] += zeros

proc solveDay06*: IntSolution =
  var state = readInitialState()

  for i in 1..256:
    state.simulate()

    if i == 80:
      result.part1 = state.sum
    elif i == 256:
      result.part2 = state.sum

when isMainModule:
  echo solveDay06()
