import day09, std/unittest

suite "day 9":
  test "part 1":
    let solution = solveDay09()
    check: 570 == solution.part1

  test "part 2":
    let solution = solveDay09()
    check: 899392 == solution.part2
