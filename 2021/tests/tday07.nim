import day07, unittest

suite "day 7":
  test "part 1":
    let solution = solveDay7()
    check: 335330 == solution.part1

  test "part 2":
    let solution = solveDay7()
    check: 1613415325809 == solution.part2
