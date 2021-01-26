module AdventOfCode.Input

open System.IO

let filePath day = Path.Combine("Input", $"{day}.txt")

let asLines day = filePath day |> File.ReadAllLines

let asString day = filePath day |> File.ReadAllText
    
let asIntegers day =
    filePath day
    |> File.ReadLines
    |> Seq.map int
    |> Seq.toArray
    
let asInt64s day =
    filePath day
    |> File.ReadLines
    |> Seq.map int64
    |> Seq.toArray
