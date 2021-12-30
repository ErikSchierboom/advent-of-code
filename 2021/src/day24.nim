import helpers, std/[deques, math, sequtils, strscans, strutils, tables]

proc solveDay24*: Solution[int64, int64] =
  let instructions = readInputStrings(day = 24).toSeq.mapIt(it.splitWhitespace)

  # TODO: chunk, such that we re-use previously calculated values

  for model in 11111111111111 .. 99999999999999:
    var digits = ($model).mapIt(parseInt($it)).toDeque
    var state = {"w": 0, "x": 0, "y": 0, "z": 0}.toTable
    
    for instruction in instructions:
      case instruction[0]
        of "inp":
          state[instruction[1]] = digits.popFirst
        of "add":
          state[instruction[1]] = state[instruction[1]] + (if instruction[2][0].isAlphaAscii: state[instruction[2]] else: parseInt(instruction[2]))
        of "mul":
          state[instruction[1]] = state[instruction[1]] * (if instruction[2][0].isAlphaAscii: state[instruction[2]] else: parseInt(instruction[2]))
        of "div":
          state[instruction[1]] = state[instruction[1]] div (if instruction[2][0].isAlphaAscii: state[instruction[2]] else: parseInt(instruction[2]))
        of "mod":
          state[instruction[1]] = state[instruction[1]] mod (if instruction[2][0].isAlphaAscii: state[instruction[2]] else: parseInt(instruction[2]))
        of "eql":
          state[instruction[1]] = 
            if state[instruction[1]] == (if instruction[2][0].isAlphaAscii: state[instruction[2]] else: parseInt(instruction[2])):
              1
            else:
              0

    if state["z"] == 0:
      result.part1 = max(result.part1, model)
    # echo digits

when isMainModule:
  echo solveDay24()
