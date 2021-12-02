import day2, unittest

suite "day 2":
  test "part 1":
    let solution = solve()
    check: 1660158 == solution.part1

  test "part 2":
    let solution = solve()
    check: 1604592846 == solution.part2
