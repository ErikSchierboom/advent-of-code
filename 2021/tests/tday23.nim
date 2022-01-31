import day23, std/unittest

suite "day 23":
  test "part 1":
    let solution = solveDay23()
    check: 11417 == solution.part1

  test "part 2":
    let solution = solveDay23()
    check: 49529 == solution.part2
