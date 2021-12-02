import macros, strformat

macro solveDay(day: untyped): untyped =
  let dayStr = day.toStrLit

  quote do: 
    import `day`
    echo `dayStr` & ": " & $(`day`.solve())

solveDay(day1)
solveDay(day2)
