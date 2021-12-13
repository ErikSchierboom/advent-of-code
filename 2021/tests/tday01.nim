import day01, std/unittest

suite "day 1":
  test "part 1":
    let solution = solveDay01()
    check: 1121 == solution.part1

  test "part 2":
    let solution = solveDay01()
    check: 1065 == solution.part2
