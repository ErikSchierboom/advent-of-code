import day08, unittest

suite "day 8":
  test "part 1":
    let solution = solveDay8()
    check: 335330 == solution.part1

  test "part 2":
    let solution = solveDay8()
    check: 92439766 == solution.part2
