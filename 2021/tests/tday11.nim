import day11, unittest

suite "day 11":
  test "part 1":
    let solution = solveDay11()
    check: 366027 == solution.part1

  test "part 2":
    let solution = solveDay11()
    check: 1118645287 == solution.part2
