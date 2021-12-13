import day02, std/unittest

suite "day 2":
  test "part 1":
    let solution = solveDay02()
    check: 1660158 == solution.part1

  test "part 2":
    let solution = solveDay02()
    check: 1604592846 == solution.part2
