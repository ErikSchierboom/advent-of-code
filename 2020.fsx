open System.IO

let readInput day =
    let inputFilePath =
        Path.Combine("2020", sprintf "%d.txt" day)

    File.ReadAllLines(inputFilePath)

let readInputAsIntegers day = readInput day |> Array.map int

let solveDay1 () =
    let numbers = readInputAsIntegers 1

    let part1 =
        [ for n1 in numbers do
            for n2 in numbers do
                if n1 + n2 = 2020 then yield n1 * n2 ]
        |> List.head

    let part2 =
        [ for n1 in numbers do
            for n2 in numbers do
                for n3 in numbers do
                    if n1 + n2 + n3 = 2020 then yield n1 * n2 * n3 ]
        |> List.head

    (part1, part2)


printfn "Day 1: %A" (solveDay1 ())
