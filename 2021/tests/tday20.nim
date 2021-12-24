import day20, std/unittest

suite "day 20":
  test "part 1":
    let solution = solveDay20()
    check: 5571 == solution.part1

  test "part 2":
    let solution = solveDay20()
    check: 17965 == solution.part2
