import helpers, std/[deques, math, sequtils, strscans, strutils, strformat, tables]

proc readInstructionBlocks: seq[seq[seq[string]]] =
  for line in readInputStrings(day = 24):
    let instruction = line.splitWhitespace
    if instruction[0] == "inp": result.add(newSeq[seq[string]]())
    result[result.high].add instruction

proc run(state: Table[string, int], instructions: seq[seq[string]], input: int): Table[string, int] =
  result = state

  for instruction in instructions:
    case instruction[0]
      of "inp":
        result[instruction[1]] = input
      of "add":
        result[instruction[1]] = result[instruction[1]] + (if instruction[2][0].isAlphaAscii: result[instruction[2]] else: parseInt(instruction[2]))
      of "mul":
        result[instruction[1]] = result[instruction[1]] * (if instruction[2][0].isAlphaAscii: result[instruction[2]] else: parseInt(instruction[2]))
      of "div":
        result[instruction[1]] = result[instruction[1]] div (if instruction[2][0].isAlphaAscii: result[instruction[2]] else: parseInt(instruction[2]))
      of "mod":
        result[instruction[1]] = result[instruction[1]] mod (if instruction[2][0].isAlphaAscii: result[instruction[2]] else: parseInt(instruction[2]))
      of "eql":
        result[instruction[1]] = 
          if result[instruction[1]] == (if instruction[2][0].isAlphaAscii: result[instruction[2]] else: parseInt(instruction[2])):
            1
          else:
            0

proc solveDay24*: Solution[int64, int64] =
  let instructions = readInstructionBlocks()
  echo instructions.len

  const initialState = {"w": 0, "x": 0, "y": 0, "z": 0}.toTable

  for d1 in 1..9:
    let state1 = run(initialState, instructions[0], d1)
    for d2 in 1..9:
      let state2 = run(state1, instructions[1], d2)
      for d3 in 1..9:
        let state3 = run(state2, instructions[2], d3)
        for d4 in 1..9:
          let state4 = run(state3, instructions[3], d4)
          for d5 in 1..9:
            let state5 = run(state4, instructions[4], d5)
            for d6 in 1..9:
              let state6 = run(state5, instructions[5], d6)
              for d7 in 1..9:
                let state7 = run(state6, instructions[6], d7)
                for d8 in 1..9:
                  let state8 = run(state7, instructions[7], d8)
                  for d9 in 1..9:
                    let state9 = run(state8, instructions[8], d9)
                    for d10 in 1..9:
                      let state10 = run(state9, instructions[9], d10)
                      for d11 in 1..9:
                        let state11 = run(state10, instructions[10], d11)
                        for d12 in 1..9:
                          let state12 = run(state11, instructions[11], d12)
                          for d13 in 1..9:
                            let state13 = run(state12, instructions[12], d13)
                            for d14 in 1..9:
                              let state14 = run(state13, instructions[13], d14)
                              if state14["z"] == 0:
                                result.part1 = max(result.part1, parseInt(&"{d1}{d2}{d3}{d4}{d5}{d6}{d7}{d8}{d9}{d10}{d11}{d12}{d13}{d4}"))

when isMainModule:
  echo solveDay24()
