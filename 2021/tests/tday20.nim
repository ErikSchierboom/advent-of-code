import day20, std/unittest

suite "day 20":
  test "part 1":
    let solution = solveDay20()
    check: 3981 == solution.part1

  test "part 2":
    let solution = solveDay20()
    check: 4687 == solution.part2
