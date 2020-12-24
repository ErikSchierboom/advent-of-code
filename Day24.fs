module AdventOfCode.Day24

open System.Text.RegularExpressions

let followDirections directions =
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

let neighborCoordinates (x, y) =
    [ (x + 1, y - 1)
      (x - 1, y - 1)
      (x - 1, y + 1)
      (x + 1, y + 1)
      (x + 2, y    )
      (x - 2, y    ) ]
    |> Set.ofList

let blackTileCoordinates =
    Input.asLines 24
    |> Seq.map (fun line -> Regex.Matches(line, "(se|sw|nw|ne|e|w)") |> Seq.map (fun m -> m.Value) |> Seq.toList)
    |> Seq.map followDirections
    |> Seq.groupBy id
    |> Seq.filter (fun (_, tileFlips) -> Seq.length tileFlips % 2 = 1)
    |> Seq.map fst
    |> Set.ofSeq

let part1 = blackTileCoordinates |> Set.count

let part2 =
    let blackTileCoordinatesWithNeighbors =
        blackTileCoordinates
        |> Seq.map (fun blackTileCoordinate -> blackTileCoordinate, neighborCoordinates blackTileCoordinate)
        |> Seq.toArray
    
    let adjacentBlackTileCount neighbors =
        neighbors
        |> Set.intersect blackTileCoordinates
        |> Set.count
    
    let blackTileCoordinatesThatRemainBlack =
        blackTileCoordinatesWithNeighbors
        |> Seq.filter (fun (_, neighbors) -> adjacentBlackTileCount neighbors |> fun count -> count = 1 || count = 2)
        |> Seq.map fst
        |> Set.ofSeq
        
    let whiteTileCoordinatesThatBecomeBlack =
        let whiteTileNeighbors =
            blackTileCoordinatesWithNeighbors
            |> Seq.map snd
            |> Seq.reduce Set.union
        
        Set.difference whiteTileNeighbors blackTileCoordinates
        |> Set.filter (fun neighbor -> neighbor |> neighborCoordinates |> adjacentBlackTileCount |> fun count -> count = 2)
  
    let newBlackCoordinates = Set.union blackTileCoordinatesThatRemainBlack whiteTileCoordinatesThatBecomeBlack      
    
    printfn "%A" newBlackCoordinates
    0
//Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
//Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.

let solution = part1, part2
