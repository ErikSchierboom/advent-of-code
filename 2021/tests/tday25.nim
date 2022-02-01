import day25, std/unittest

suite "day 25":
  test "part 1":
    let solution = solveDay25()
    check: 11417 == solution.part1
