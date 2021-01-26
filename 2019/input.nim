import os, strformat, strutils

func inputFilePath(day: int): string = joinPath("Input", &"{day}.txt")

proc readInputAsString*(day: int): string =
  readFile(inputFilePath(day))

proc readInputAsLines*(day: int): seq[string] =  
  for line in inputFilePath(day).lines:
    result.add(line)

proc readInputAsInts*(day: int): seq[int] =  
  for line in inputFilePath(day).lines:
    result.add(parseInt(line))