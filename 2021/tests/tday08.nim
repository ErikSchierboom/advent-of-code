import day08, std/unittest

suite "day 8":
  test "part 1":
    let solution = solveDay08()
    check: 381 == solution.part1

  test "part 2":
    let solution = solveDay08()
    check: 1023686 == solution.part2
