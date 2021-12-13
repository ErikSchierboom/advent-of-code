import day03, std/unittest

suite "day 3":
  test "part 1":
    let solution = solveDay3()
    check: 1082324 == solution.part1

  test "part 2":
    let solution = solveDay3()
    check: 1353024 == solution.part2
