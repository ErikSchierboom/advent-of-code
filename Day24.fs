module AdventOfCode.Day24

open System.Text.RegularExpressions

let toCoordinate directions =
    let rec loop (x, y) remainder =
        match remainder with
        | [] -> (x, y)
        | "se"::xs -> loop (x + 1, y - 1) xs 
        | "sw"::xs -> loop (x - 1, y - 1) xs
        | "nw"::xs -> loop (x - 1, y + 1) xs
        | "ne"::xs -> loop (x + 1, y + 1) xs
        |  "e"::xs -> loop (x + 2, y    ) xs
        |  "w"::xs -> loop (x - 2, y    ) xs
        | _ -> failwith "Invalid direction"
    
    loop (0, 0) directions

let flipped =
    Input.asLines 24
    |> Seq.map (fun line -> Regex.Matches(line, "(se|sw|nw|ne|e|w)") |> Seq.map (fun m -> m.Value) |> Seq.toList)
    |> Seq.map toCoordinate
    |> Seq.groupBy id
    |> Seq.filter (fun (_, tileFlips) -> Seq.length tileFlips % 2 = 1)
    |> Seq.map fst
    |> Set.ofSeq

let part1 = flipped |> Set.count

let part2 = 0

let solution = part1, part2
