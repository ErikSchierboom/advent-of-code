import day12, unittest

suite "day 12":
  test "part 1":
    let solution = solveDay12()
    check: 4773 == solution.part1

  test "part 2":
    let solution = solveDay12()
    check: 314 == solution.part2
