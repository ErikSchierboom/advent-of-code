module AdventOfCode.Day9

let numbers = Input.asInt64s 9 |> List.ofArray

let part1 =
    let preambleLength = 25
    let invalidNumber (window: int64[]) =
        let preamble = window.[..preambleLength - 1]
        let number = window.[preambleLength]

        let validNumbers =
            [for x in preamble do
                 for y in preamble do
                     if x <> y && x + y = number then
                         yield number]
        
        match validNumbers with
        | [] -> Some number
        | _ -> None
    
    numbers
    |> Seq.windowed (preambleLength + 1)
    |> Seq.pick invalidNumber
let part2 =
    let encryptionWeakness i =
        let rec tryFindSeries length =
            let series = numbers.[i..i + length]
            let seriesSum = List.sum series
            
            if seriesSum = part1 then
                Some (List.min series + List.max series)
            elif seriesSum > part1 then
                None
            elif length >= numbers.Length - 2 then
                None
            else
                tryFindSeries (length + 1)
        
        tryFindSeries 2

    [0 .. numbers.Length - 2]
    |> Seq.pick encryptionWeakness

let solution = part1, part2