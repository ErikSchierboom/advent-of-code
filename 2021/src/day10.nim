import helpers, std/[algorithm, deques, sequtils]

const opening = ['(', '[', '{', '<']
const closing = [')', ']', '}', '>']
const scores  = [3, 57, 1197, 25137]

func openingChar(closingChar: char): char {.inline.} = opening[closing.find(closingChar)]
func corruptScore(closingChar: char): int {.inline.} = scores[closing.find(closingChar)]
func incompleteScore(openingChar: char): int {.inline.} = opening.find(openingChar) + 1

proc solveDay10*: IntSolution =
  var incompleteScores: seq[int]

  for line in readInputStrings(day = 10):
    var unclosed: Deque[char]
    var isCorrupted = false
    for c in line:
      if c in closing and unclosed.peekLast != c.openingChar:
        result.part1.inc corruptScore(c)
        isCorrupted = true
        break
      elif c in closing:
        unclosed.popLast()
      elif c in opening:
        unclosed.addLast(c)

    if not isCorrupted and unclosed.len > 0:
      incompleteScores.add unclosed.toSeq.reversed.foldl(a * 5 + incompleteScore(b), 0)

  result.part2 = incompleteScores.sorted[incompleteScores.len div 2]

when isMainModule:
  echo solveDay10()
