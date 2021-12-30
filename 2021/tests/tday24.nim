import day24, std/unittest

suite "day 24":
  test "part 1":
    let solution = solveDay24()
    check: 679329 == solution.part1

  test "part 2":
    let solution = solveDay24()
    check: 433315766324816 == solution.part2
