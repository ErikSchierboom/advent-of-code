module AdventOfCode.Day20

module Array2D =
    let rotate arr = Array2D.init (Array2D.length2 arr) (Array2D.length1 arr) (fun row col -> Array2D.get arr (Array2D.length1 arr - col - 1) row)
    let flipHorizontal arr = Array2D.init (Array2D.length1 arr) (Array2D.length2 arr) (fun row col -> Array2D.get arr row (Array2D.length2 arr - col - 1))
    let flipVertical arr = Array2D.init (Array2D.length1 arr) (Array2D.length2 arr) (fun row col -> Array2D.get arr (Array2D.length1 arr - row - 1) col)

type Tile = { Id: uint64; Pixels: char[,] }

let borders (pixels: 'T[,]) = [ pixels.[0, *]; pixels.[*, ^0]; pixels.[^0, *]; pixels.[*, 0] ]

let orientations pixels =
    [| pixels
       pixels |> Array2D.rotate
       pixels |> Array2D.rotate |> Array2D.rotate
       pixels |> Array2D.rotate |> Array2D.rotate |> Array2D.rotate |]
    |> Seq.collect (fun orientation -> [|orientation; Array2D.flipHorizontal orientation; Array2D.flipVertical orientation|])
    |> Set.ofSeq    

let parseTile (lines: string[]) =
    let id = uint64 lines.[0].[5..8]
    let pixels = Array2D.init 10 10 (fun row col -> lines.[row + 1].[col])    
    { Id = id; Pixels = pixels }

let tiles =
    Input.asLines 20
    |> Seq.chunkBySize 12
    |> Seq.map parseTile
    |> Seq.toArray
    
let isCorner tiles =    
    let orientationBordersPerTile =
        tiles
        |> Seq.map (fun tile -> tile.Id, tile.Pixels |> orientations |> Seq.collect borders |> Seq.toArray)
        |> Map.ofSeq
        
    fun targetTile ->
        let targetTileBorders = borders targetTile.Pixels
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

let part1 =
    tiles
    |> Seq.filter (isCorner tiles)
    |> Seq.map (fun tile -> tile.Id)
    |> Seq.reduce (*)

let part2 = 0

let solution = part1, part2