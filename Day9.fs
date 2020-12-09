module AdventOfCode.Day9

let numbers = Input.asInt64s 9

let part1 =
    let preambleLength = 25
    
    numbers
    |> Seq.skip preambleLength
    |> Seq.indexed
    |> Seq.pick (fun (i, number) ->
        let preamble = numbers.[i .. i + preambleLength - 1]
        let validNumber = preamble |> Seq.exists (fun x -> preamble |> Seq.exists (fun y -> x + y = number))
        if validNumber then None else Some number)

let part2 =
    let continuousSeries (i, _) =
        numbers
        |> Seq.skip i
        |> Seq.indexed
        |> Seq.map (fun (j, _) -> numbers.[i .. i + j])
        |> Seq.map (fun series -> (Array.sum series, Array.min series, Array.max series))

    numbers
    |> Seq.indexed
    |> Seq.collect continuousSeries
    |> Seq.pick (fun (sum, min, max) -> if sum = part1 then Some(min + max) else None)

let solution = part1, part2