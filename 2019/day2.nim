import input, strformat, strutils

proc program(): seq[int] =
  for str in readInputAsString(2).split(','):
    result.add(parseInt(str))

var state = program()

func run(initialState: seq[int], noun, verb: int): int =
  var state = initialState
  state[1] = noun
  state[2] = verb

  var idx = 0

  while true:
    case state[idx]
      of 99: 
        return state[0]
      of 1: 
        state[state[idx + 3]] = state[state[idx + 1]] + state[state[idx + 2]]
        idx.inc(4)
      of 2: 
        state[state[idx + 3]] = state[state[idx + 1]] * state[state[idx + 2]]
        idx.inc(4)
      else:
        quit(1)

proc part1(): int = run(state, 12, 2)

proc part2(): int =
  for noun in 0..99:
    for verb in 0..99:
      if run(state, noun, verb) == 19_690_720:
        return 100 * noun + verb

echo &"day 2: {part1()}, {part2()}"