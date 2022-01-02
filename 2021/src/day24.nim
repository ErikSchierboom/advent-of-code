import helpers, std/[algorithm, deques, math, sequtils, strscans, strutils, strformat, tables]

type Instructions = tuple[param1, param2: int]

# 0:inp w
# 1:mul x 0
# 2:add x z
# 3:mod x 26
# 4:div z 26 (or div z 1)
# 5:add x -14 (or add x ...) (if < 0 then div z 26 else div z 1)
# 6:eql x w
# 7:eql x 0
# 8:mul y 0
# 9:add y 25
# 10:mul y x
# 11:add y 1
# 12:mul z y
# 13:mul y 0
# 14:add y w
# 15:add y 10 (or add y ...)
# 16:mul y x
# 17:add z y

# w = NUM
# x = 0
# x = x + z
# x = x mod 26
# z = z div 1 (or z = z div 26)
# x = x + PARAM1
# x = x == w (1 if true, 0 if false)
# x = x == 0 
# y = 0
# y = y + 25
# y = y * x
# y = y + 1
# z = z * y
# y = 0
# y = y + w
# y = y + PARAM2
# y = y * x
# z = z + y

# w = NUM
# x = z
# x = x mod 26
# z = z div 1 (or z = z div 26)
# x = x + PARAM1
# x = x == w (1 if true, 0 if false)
# x = x == 0 
# y = (25 * x) + 1
# z = z * y
# y = (w + PARAM2) * x
# z = z + y

# SIMPLIFIED
# PATH 1: div 1
# w = NUM
# x = if z mod 26 + PARAM1 == w: 0 else: 1
#
# PATH 2: div 26
# w = NUM
# x = if z mod 26 + PARAM1 == w: 0 else: 1
# z = z div 26

# TWO PATHS: x = 0 and x = 1
#
# PATH 1: x = 0
# NOTHING CHANGES
#
# PATH 2: x = 1
# z = (z * 26) + w + PARAM2

func eval(instructions: Instructions, w, z: int): int =
  let x =  if (z mod 26) + instructions.param1 == w: 0 else: 1
  var z = if instructions.param1 < 0: z div 26 else: z
  if x == 1: z = (z * 26) + w + instructions.param2
  z

  # SIMPLIFIED
# PATH 1: div 1
# w = NUM
# x = if z mod 26 + PARAM1 == w: 0 else: 1
#
# PATH 2: div 26
# w = NUM
# x = if z mod 26 + PARAM1 == w: 0 else: 1
# z = z div 26

# TWO PATHS: x = 0 and x = 1
#
# PATH 1: x = 0
# NOTHING CHANGES
#
# PATH 2: x = 1
# z = (z * 26) + w + PARAM2

proc readInstructions: seq[Instructions] =
  let lines = readInputStrings(day = 24).toSeq
  for instructions in lines.distribute(lines.len div 18):
    let param1 = parseInt(instructions[5].splitWhitespace[^1])
    let param2 = parseInt(instructions[15].splitWhitespace[^1])
    result.add (param1: param1, param2: param2)


proc solveDay24*: Solution[int64, int64] =
  let instructions = readInstructions()

  for num in 11111111111111 .. 11111111111111:
    let digits = ($num).toSeq.mapIt(parseInt($it))
    echo digits
  # const initialState = {"w": 0, "x": 0, "y": 0, "z": 0}.toTable

when isMainModule:
  echo solveDay24()
