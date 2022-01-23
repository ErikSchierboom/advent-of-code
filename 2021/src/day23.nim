import helpers, std/[heapqueue, options, sequtils, strformat, tables]

# 0 1 4 7 10 13 14
#    2 5 8 11
#    3 6 9 12

type
  State = tuple[grid: string, energy: int]

func `<` (a, b: State): bool = a.energy < b.energy

const amphipods = "ABCD"
const organizedGrid = "..AA.BB.CC.DD.."

const hallway = [0, 1, 4, 7, 10, 13, 14]
const roomTops = [2, 5, 8, 11]
const roomBottoms = [3, 6, 9, 12]

func `$`(state: State): string =
  result.add "Energy: " & $state.energy
  result.add '\n'
  result.add "#############\n#"
  result.add state.grid[0]
  result.add state.grid[1]
  result.add '.'
  result.add state.grid[4]
  result.add '.'
  result.add state.grid[7]
  result.add '.'
  result.add state.grid[10]
  result.add '.'
  result.add state.grid[13]
  result.add state.grid[14]
  result.add "#\n###"
  result.add state.grid[2]
  result.add '#'
  result.add state.grid[5]
  result.add '#'
  result.add state.grid[8]
  result.add '#'
  result.add state.grid[11]
  result.add '#'
  result.add "##\n  #"
  result.add state.grid[3]
  result.add '#'
  result.add state.grid[6]
  result.add '#'
  result.add state.grid[9]
  result.add '#'
  result.add state.grid[12]
  result.add '#'
  result.add "\n  #########  "
  result.add '\n'

func cost(amphipod: char): int = 
  const costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }.toTable
  costs[amphipod]

proc moves(state: State): seq[State] =
  for i, c in state.grid:
    if c != '.':
      if i in roomTops:
        if organizedGrid[i] == c:
          if state.grid[i + 1] == c:
            echo &"moves for room top {i} ({c}): top and bottom are correct"
          else:
            var moves = 0
            for j in countdown(i - 1, state.grid.low):
              if j in hallway:
                if state.grid[j] == '.':
                  echo &"moves for room top {i} ({c}): top is correct but bottom isn't, move to hallway {j}"
                  inc moves, (if j in [0, 14]: 1 else: 2)
                  var newState = state
                  newState.grid[j] = c
                  newState.grid[i] = '.'
                  inc newState.energy, (moves * c.cost)
                  echo newState
                else:
                  break

            moves = 0
            for j in countup(i + 1, state.grid.high):
              if j in hallway:
                if state.grid[j] == '.':
                  echo &"moves for room top {i} ({c}): top is correct but bottom isn't, move to hallway {j}"
                  inc moves, (if j in [0, 14]: 1 else: 2)
                  var newState = state
                  newState.grid[j] = c
                  newState.grid[i] = '.'
                  inc newState.energy, (moves * c.cost)
                  echo newState
                else:
                  break
        else:
          var moves = 0
          for j in countdown(i - 1, state.grid.low):
            if j in hallway:
              if state.grid[j] == '.':
                echo &"moves for room top {i} ({c}): top is incorrect, move to hallway {j}"
                inc moves, (if j in [0, 14]: 1 else: 2)
                var newState = state
                newState.grid[j] = c
                newState.grid[i] = '.'
                inc newState.energy, (moves * c.cost)
                echo newState
              else:
                break

          moves = 0
          for j in countup(i + 1, state.grid.high):
            if j in hallway:
              if state.grid[j] == '.':
                echo &"moves for room top {i} ({c}): top is incorrect, move to hallway {j}"
                inc moves, (if j in [0, 14]: 1 else: 2)
                var newState = state
                newState.grid[j] = c
                newState.grid[i] = '.'
                inc newState.energy, (moves * c.cost)
                echo newState
              else:
                break
      elif i in roomBottoms:
        if organizedGrid[i] == c:
          echo &"moves for room bottom {i} ({c}): bottom is correct"
        elif state.grid[i - 1] == '.':
          var moves = 1
          for j in countdown(i - 1, state.grid.low):
            if j in hallway:
              if state.grid[j] == '.':
                echo &"moves for room bottom {i} ({c}): bottom is incorrect but not blocked, move to hallway {j}"
                inc moves, (if j in [0, 14]: 1 else: 2)
                var newState = state
                newState.grid[j] = c
                newState.grid[i] = '.'
                inc newState.energy, (moves * c.cost)
                echo newState
              else:
                break

          moves = 1
          for j in countup(i + 1, state.grid.high):
            if j in hallway:
              if state.grid[j] == '.':
                echo &"moves for room bottom {i} ({c}): bottom is incorrect but not blocked, move to hallway {j}"
                inc moves, (if j in [0, 14]: 1 else: 2)
                var newState = state
                newState.grid[j] = c
                newState.grid[i] = '.'
                inc newState.energy, (moves * c.cost)
                echo newState
              else:
                break
        else:
          echo &"moves for room bottom {i} ({c}): bottom is incorrect and blocked"
      else:
        let roomTopIdx = roomTops[amphipods.find(c)]
        let roomBottomIdx = roomBottoms[amphipods.find(c)]

        if state.grid[roomTopIdx] == '.':
          if state.grid[roomBottomIdx] == '.':
            let traversable = hallway.filterIt(it > min(i, roomTopIdx) and it < max(i, roomTopIdx)).allIt(state.grid[it] == '.')
            if traversable:
              echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} and bottom are empty and hallway empty"
            else:
              echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} and bottom are empty but hallway blocked"
          elif state.grid[roomBottomIdx] == c:
            let traversable = hallway.filterIt(it > min(i, roomTopIdx) and it < max(i, roomTopIdx)).allIt(state.grid[it] == '.')
            if traversable:
              echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} is empty and bottom is correct and hallway empty"
            else:
              echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} is empty and bottom is correct but hallway blocked"
          else:
            echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} is empty and bottom is incorrect"
        else:
          echo &"moves for hallway {i} ({c}): target room top {roomTopIdx} is blocked"

proc part1(state: State): int =
  var queue: HeapQueue[State]
  var energyCounts = initCountTable[string]()

  energyCounts[state.grid] = 0
  queue.push state

  while queue.len > 0:
    let current = queue.pop()

    if current.grid == organizedGrid:
      echo "organized"
      echo current.grid
      return current.energy

    if current.energy > energyCounts.getOrDefault(current.grid, high(int)):
      continue

    for move in current.moves:
      if move.energy < energyCounts.getOrDefault(move.grid, high(int)):
        queue.push move
        energyCounts[move.grid] = move.energy



proc readInputState: State =
  let lines = readInputStrings(day = 23).toSeq
  # TODO: refactor
  result.grid.add lines[1][1]
  result.grid.add lines[1][2]
  result.grid.add lines[2][3]
  result.grid.add lines[3][3]
  result.grid.add lines[1][4]
  result.grid.add lines[2][5]
  result.grid.add lines[3][5]
  result.grid.add lines[1][6]
  result.grid.add lines[2][7]
  result.grid.add lines[3][7]
  result.grid.add lines[1][8]
  result.grid.add lines[2][9]
  result.grid.add lines[3][9]
  result.grid.add lines[1][10]
  result.grid.add lines[1][11]

proc solveDay23*: IntSolution =
  let state = readInputState()
  result.part1 = part1(state)

when isMainModule:
  echo solveDay23()

# 0 1 4 7 10 13 14
#    2 5 8 11
#    3 6 9 12