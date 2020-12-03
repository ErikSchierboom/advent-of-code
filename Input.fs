module AdventOfCode.Input

open System.IO

let forDay day =
    Path.Combine("Input", $"{day}.txt")
    |> File.ReadAllLines
