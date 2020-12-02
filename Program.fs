open System.IO

let readInput day =
    let inputFilePath = Path.Combine("Input", $"{day}.txt")
    File.ReadAllLines(inputFilePath)

let readInputAsIntegers day = readInput day |> Array.map int

let solveDay1 () =
    let numbers = readInputAsIntegers 1        
    numbers
    |> Array.pick (fun first -> numbers |> Array.tryPick(fun second -> if first + second  = 2020 then Some (first * second) else None))

[<EntryPoint>]
let main _ =
    printfn $"Day 1: {solveDay1()}"
    0