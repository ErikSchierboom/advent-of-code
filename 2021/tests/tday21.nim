import day21, std/unittest

suite "day 21":
  test "part 1":
    let solution = solveDay21()
    check: 679329 == solution.part1

  test "part 2":
    let solution = solveDay21()
    check: 1353024 == solution.part2
