import day18, std/unittest

suite "day 18":
  test "part 1":
    let solution = solveDay18()
    check: 3981 == solution.part1

  test "part 2":
    let solution = solveDay18()
    check: 4687 == solution.part2
