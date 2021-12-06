import day06, unittest

suite "day 6":
  test "part 1":
    let solution = solveDay6()
    check: 5934 == solution.part1

  test "part 2":
    let solution = solveDay6()
    check: 20500 == solution.part2
