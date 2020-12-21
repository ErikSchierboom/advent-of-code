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
            
//        tiles
//        |> Seq.except [targetTile]
//        |> Seq.collect (fun t -> orientations t.Pixels)
//        |> Seq.map borders
//
        let y =
            targetTileBorders
            |> Seq.map (fun bord -> otherTileBorders |> Seq.filter (fun x -> Array.contains bord x) |> Seq.length)
        let a = y |> Seq.filter ((=) 0) |> Seq.length
        
        a = 2

let part1 =
    tiles
    |> Seq.filter (isCorner tiles)
    |> Seq.map (fun tile -> tile.Id)
    |> Seq.reduce (*)

let part2 = 0

let solution = part1, part2

//
//printfn "%A" (x1.[0..^0, *] |> Array2D.rows)
//printfn "%A" (x1.[0..^0, *] |> Array2D.cols)
//
//printfn "%A" (horizontallyLinedUp x1 x3)
//printfn "%A" (horizontallyLinedUp x1 x2)
//
//printfn "%A" (verticallyLinedUp x1 x3)
//printfn "%A" (verticallyLinedUp x1 x2)

//let x1 = array2D [ ['0'; '1'; '2']; ['3'; '4'; '5']; ['6'; '7'; '8'] ]
//let x2 = array2D [ ['6'; '7'; '8']; ['3'; '4'; '5']; ['0'; '1'; '2'] ]
//let x3 = array2D [ ['2'; '6'; '7']; ['5'; '5'; '5']; ['8'; '4'; '4'] ]
//
//printfn "%A" (x1 |> Array2D.rotate)
//printfn "%A" (x1 |> Array2D.flipHorizontal)
//printfn "%A" (x1 |> Array2D.flipVertical)