import day24, std/unittest

suite "day 24":
  test "part 1":
    let solution = solveDay24()
    check: 11417 == solution.part1

  test "part 2":
    let solution = solveDay24()
    check: 49529 == solution.part2
