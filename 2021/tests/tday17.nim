import day17, std/unittest

suite "day 17":
  test "part 1":
    let solution = solveDay17()
    check: 5671 == solution.part1

  test "part 2":
    let solution = solveDay17()
    check: 200476472872 == solution.part2
