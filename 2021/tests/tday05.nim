import day05, std/unittest

suite "day 5":
  test "part 1":
    let solution = solveDay05()
    check: 4655 == solution.part1

  test "part 2":
    let solution = solveDay05()
    check: 20500 == solution.part2
