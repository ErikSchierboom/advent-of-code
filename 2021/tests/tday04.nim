import day04, unittest

suite "day 4":
  test "part 1":
    let solution = solveDay4()
    check: 25410 == solution.part1

  test "part 2":
    let solution = solveDay4()
    check: 2730 == solution.part2
