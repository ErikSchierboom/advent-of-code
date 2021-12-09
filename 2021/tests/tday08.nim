import day08, unittest

suite "day 8":
  test "part 1":
    let solution = solveDay8()
    check: 381 == solution.part1

  test "part 2":
    let solution = solveDay8()
    check: 1023686 == solution.part2
