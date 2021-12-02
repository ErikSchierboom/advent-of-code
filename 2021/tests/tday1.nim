import day1, unittest

suite "day 1":
  test "part 1":
    let solution = solve()
    check: 1121 == solution.part1

  test "part 2":
    let solution = solve()
    check: 1065 == solution.part2
