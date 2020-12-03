module AdventOfCode.Input

open System.IO

let private inputFilePath day = Path.Combine("Input", $"{day}.txt")

let lines day = File.ReadAllLines(inputFilePath day)

let integers day = lines day |> Array.map int
