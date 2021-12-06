import day06, unittest

suite "day 6":
  test "part 1":
    let solution = solveDay6()
    check: 355386 == solution.part1

  test "part 2":
    let solution = solveDay6()
    check: 1613415325809 == solution.part2
