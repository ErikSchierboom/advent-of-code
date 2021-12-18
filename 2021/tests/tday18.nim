import day18, std/unittest

suite "day 18":
  test "part 1":
    let solution = solveDay18()
    check: 5671 == solution.part1

  test "part 2":
    let solution = solveDay18()
    check: 4556 == solution.part2
