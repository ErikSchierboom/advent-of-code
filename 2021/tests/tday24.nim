import day24, std/unittest

suite "day 24":
  test "part 1":
    let solution = solveDay24()
    check: 59996912981939 == solution.part1

  test "part 2":
    let solution = solveDay24()
    check: 17241911811915 == solution.part2
