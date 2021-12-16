import day16, std/unittest

suite "day 16":
  test "part 1":
    let solution = solveDay16()
    check: 904 == solution.part1

  test "part 2":
    let solution = solveDay16()
    check: 2899 == solution.part2
