import day05, unittest

suite "day 5":
  test "part 1":
    let solution = solveDay5()
    check: 4655 == solution.part1

  test "part 2":
    let solution = solveDay5()
    check: 1353024 == solution.part2
