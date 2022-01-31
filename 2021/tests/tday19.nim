import day19, std/unittest

suite "day 19":
  test "part 1":
    let solution = solveDay19()
    check: 3981 == solution.part1

  test "part 2":
    let solution = solveDay19()
    check: 4687 == solution.part2
