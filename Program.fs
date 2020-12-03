open System.IO

module Input =
    let private inputFilePath day = Path.Combine("Input", sprintf "%d.txt" day)

    let lines day = File.ReadAllLines(inputFilePath day)

    let integers day = lines day |> Array.map int

module Day1 =
    let solve () =
        let numbers = Input.integers 1

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

[<EntryPoint>]
let main argv =
    printfn "Day 1: %A" (Day1.solve ())

    0