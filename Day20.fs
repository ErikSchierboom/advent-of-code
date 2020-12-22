module AdventOfCode.Day20

open System

module Array2D =
    let rotate arr = Array2D.init (Array2D.length2 arr) (Array2D.length1 arr) (fun row col -> Array2D.get arr (Array2D.length1 arr - col - 1) row)
    let flipHorizontal arr = Array2D.init (Array2D.length1 arr) (Array2D.length2 arr) (fun row col -> Array2D.get arr row (Array2D.length2 arr - col - 1))

type Orientation = { Pixels: char[,]; Borders: char[][] }
type Tile = { Id: uint64; Orientations: Orientation[] }

let borders (pixels: 'T[,]) = [| pixels.[0, *]; pixels.[*, ^0]; pixels.[^0, *]; pixels.[*, 0] |]

let rotations pixels =
    [| pixels
       pixels |> Array2D.rotate
       pixels |> Array2D.rotate |> Array2D.rotate
       pixels |> Array2D.rotate |> Array2D.rotate |> Array2D.rotate |]
    |> Seq.collect (fun pixels -> [|pixels; Array2D.flipHorizontal pixels|])

let orientations pixels =
    rotations pixels
    |> Seq.map (fun pixels -> { Pixels = pixels; Borders = borders pixels })
    |> Seq.toArray

let parseTile (lines: string[]) =
    { Id = uint64 lines.[0].[5..8]
      Orientations = Array2D.init 10 10 (fun row col -> lines.[row + 1].[col]) |> orientations }

let tiles =
    Input.asLines 20
    |> Seq.chunkBySize 12
    |> Seq.map parseTile
    |> Seq.toArray

let isCorner tiles =    
    let orientationBordersPerTile =
        tiles
        |> Seq.map (fun tile -> tile.Id, tile.Orientations |> Seq.collect (fun orientation -> orientation.Borders) |> Seq.toArray)
        |> Map.ofSeq
        
    fun targetTile ->
        let targetTileBorders = targetTile.Orientations.[0].Borders
        let otherTileBorders =
            orientationBordersPerTile
            |> Map.filter (fun id _ -> id <> targetTile.Id)
            |> Map.toSeq
            |> Seq.map snd
            |> Seq.toArray

        let targetTileBordersWithoutMatch =
            targetTileBorders
            |> Seq.map (fun targetTileBorder -> otherTileBorders |> Seq.filter (Array.contains targetTileBorder) |> Seq.length)
            |> Seq.filter ((=) 0)
            |> Seq.length
        
        targetTileBordersWithoutMatch = 2

let corners = tiles |> Seq.filter (isCorner tiles) |> Seq.toArray

let dimension = tiles.Length |> float |> sqrt |> int

let part1 =
    corners
    |> Seq.map (fun tile -> tile.Id)
    |> Seq.reduce (*)

let alignedImage =
    let positions =
        [ for row in 0 .. dimension - 1 do
              for col in 0 ..dimension - 1 do
                  yield row, col ]
    
    let rec loop (mapping: Map<int * int, Tile * Orientation>) positions =
        match positions with
        | [] -> mapping
        | (row, col)::xs ->
            let tryAbove = Map.tryFind (row - 1, col) mapping
            let tryLeft = Map.tryFind (row, col - 1)  mapping
            
            let alreadyUsed = mapping |> Map.toSeq |> Seq.map snd |> Seq.map fst
            
            match tryAbove, tryLeft with
            | Some top, Some left ->
                let matchingTile =
                    tiles
                    |> Seq.except alreadyUsed
                    |> Seq.pick (fun tile ->
                        tile.Orientations
                        |> Seq.tryFind (fun orientation ->
                            orientation.Borders.[0] = (snd top).Borders.[2] &&
                            orientation.Borders.[3] = (snd left).Borders.[1])
                        |> Option.map (fun a -> tile, a)
                    )                    
                loop (Map.add (row, col) matchingTile mapping) xs
            | Some top, None ->
                let matchingTile =
                    tiles
                    |> Seq.except alreadyUsed
                    |> Seq.pick (fun tile ->
                        tile.Orientations
                        |> Seq.tryFind (fun orientation -> orientation.Borders.[0] = (snd top).Borders.[2])
                        |> Option.map (fun a -> tile, a)
                    )
                loop (Map.add (row, col) matchingTile mapping) xs
            | None, Some left ->
                let matchingTile =
                    tiles
                    |> Seq.except alreadyUsed
                    |> Seq.pick (fun tile ->
                        tile.Orientations
                        |> Seq.tryFind (fun orientation -> orientation.Borders.[3] = (snd left).Borders.[1])
                        |> Option.map (fun a -> tile, a)
                    )
                    
                loop (Map.add (row, col) matchingTile mapping) xs
            | None, None -> 
                failwith "Should not happen"

    let topLeftCorner: Tile * Orientation =
        corners
        |> Seq.pick (fun tile ->
            let a =
                tile.Orientations
                |> Seq.pick (fun orientation ->
                    let a =
                        tiles
                        |> Seq.except [tile]
                        |> Seq.exists (fun sub -> sub.Orientations |> Seq.exists (fun a -> a.Borders.[0] = orientation.Borders.[2]))

                    let b =
                        tiles
                        |> Seq.except [tile]
                        |> Seq.exists (fun sub -> sub.Orientations |> Seq.exists (fun a -> a.Borders.[3] = orientation.Borders.[1]))
                                                 
                    if a && b then
                        (tile, orientation) |> Some
                    else
                        None
                )
                
            Some a
    )
    let topLeftPosition = (0, 0)
    let initialMapping = Map.add (0, 0) topLeftCorner Map.empty

    let positionToTile = loop initialMapping (positions |> List.except [topLeftPosition])
    Array2D.init dimension dimension (fun row col -> Map.find (row, col) positionToTile |> fun tile -> (snd tile).Pixels)

let part2 =
    let combinedImage = Array2D.zeroCreate (dimension * 8) (dimension * 8)
    
    alignedImage
    |> Array2D.iteri (fun row col value ->
        value.[1..^1, 1..^1]
        |> Array2D.iteri (fun row2 col2 -> Array2D.set combinedImage (row * 8 + row2) (col * 8 + col2)))

    let seaMonsterOffsets =
        ["                  # "
         "#    ##    ##    ###"
         " #  #  #  #  #  #   "]
        |> List.indexed
        |> List.collect (fun (row, str) ->
             str
             |> Seq.indexed
             |> Seq.choose (fun (col, letter) -> if letter = '#' then Some (row, col) else None)
             |> Seq.toList)
    
    let numberOfHashes (image: char[,]) =
        image
        |> Seq.cast
        |> Seq.filter ((=) '#')
        |> Seq.length
        
    let numberOfSeaMonsters (image: char[,]) =
        image
        |> Array2D.mapi (fun row col _ ->
            seaMonsterOffsets
            |> List.forall (fun (dy, dx) ->
                let y = row + dy
                let x = col + dx                
                y < Array2D.length1 image && x < Array2D.length2 image && Array2D.get image y x  = '#'))
        |> Seq.cast
        |> Seq.filter ((=) true)
        |> Seq.length

    combinedImage
    |> rotations
    |> Seq.map (fun rotation -> numberOfSeaMonsters rotation, numberOfHashes rotation)
    |> Seq.find (fun (seaMonsters, _) -> seaMonsters > 0)
    |> fun (seaMonsters, numberOfHashes) -> numberOfHashes - seaMonsterOffsets.Length * seaMonsters
        
let solution = part1, part2
