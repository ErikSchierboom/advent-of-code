import day10, std/unittest

suite "day 10":
  test "part 1":
    let solution = solveDay10()
    check: 366027 == solution.part1

  test "part 2":
    let solution = solveDay10()
    check: 1118645287 == solution.part2
