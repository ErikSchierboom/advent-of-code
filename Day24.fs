module AdventOfCode.Day24

open System.Text.RegularExpressions

let instructionsToTile directions =
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

let blackTilesOnFirstDay =
    Input.asLines 24
    |> Seq.map (fun line -> Regex.Matches(line, "(se|sw|nw|ne|e|w)") |> Seq.map (fun m -> m.Value) |> Seq.toList)
    |> Seq.map instructionsToTile
    |> Seq.groupBy id
    |> Seq.filter (fun (_, tileFlips) -> Seq.length tileFlips % 2 = 1)
    |> Seq.map fst
    |> Set.ofSeq

let part1 = blackTilesOnFirstDay |> Set.count

let neighborCoordinates (x, y) =
    [ (x + 1, y - 1)
      (x - 1, y - 1)
      (x - 1, y + 1)
      (x + 1, y + 1)
      (x + 2, y    )
      (x - 2, y    ) ]

let becomesBlackTile blackTileCoordinates coordinate =
    let adjacentBlackTileCount =
        neighborCoordinates coordinate
        |> Seq.filter (fun neighborCoordinate -> Set.contains neighborCoordinate blackTileCoordinates)
        |> Seq.length

    adjacentBlackTileCount = 2 ||
    adjacentBlackTileCount = 1 && Set.contains coordinate blackTileCoordinates

let blackTilesAfterDays numberOfDays =
    let rec simulateDay blackTiles day =
        if day = numberOfDays then
            blackTiles
        else
            let newBlackTiles = 
                blackTiles
                |> Seq.collect neighborCoordinates
                |> Seq.append blackTiles
                |> Seq.distinct
                |> Seq.filter (becomesBlackTile blackTiles)
                |> Set.ofSeq
           
            simulateDay newBlackTiles (day + 1)

    simulateDay blackTilesOnFirstDay 0

let part2 = blackTilesAfterDays 100 |> Set.count

let solution = part1, part2
