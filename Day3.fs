module AdventOfCode.Day3

type private Cell =
    | Open
    | Tree

type private Map = Map of Cells: Cell [,]

type private Coordinate = Coordinate of Row: int * Col: int

type private Slope = Slope of Right: int * Down: int

let private parseCell c =
    match c with
    | '.' -> Open
    | '#' -> Tree
    | _ -> failwith "Unknown cell type"

let private parseMap (lines: string []) =
    let rows = lines.Length
    let cols = lines.[0].Length

    Array2D.init rows cols (fun row col -> parseCell lines.[row].[col])
    |> Map

let private rows (Map cells) = cells.GetLength(0)

let private cols (Map cells) = cells.GetLength(1)

let private travel (Coordinate (Row = row; Col = col)) (Slope (Right = right; Down = down)) =
    Coordinate(Row = row + down, Col = col + right)

let private cell map (Coordinate (Row = row; Col = col)) =
    let (Map(Cells = cells)) = map
    Array2D.get cells (row % rows map) (col % cols map)

let private traveledOffMap map (Coordinate(Row = row)) = row >= rows map

let private path slope map =
    let inner coordinate =
        if traveledOffMap map coordinate
        then None
        else Some(coordinate, travel coordinate slope)

    let startCoordinate = Coordinate(Row = 0, Col = 0)
    Seq.unfold inner startCoordinate

let private traverseMap slope map =
    map
    |> path slope
    |> Seq.map (cell map)
    |> Seq.filter (function
        | Tree -> true
        | Open -> false)
    |> Seq.length

let solve () =
    let map = Input.forDay 3 |> parseMap

    let part1 =
        map |> traverseMap (Slope(Right = 3, Down = 1))

    let part2 =
        let slopes =
            [ Slope(Right = 1, Down = 1)
              Slope(Right = 3, Down = 1)
              Slope(Right = 5, Down = 1)
              Slope(Right = 7, Down = 1)
              Slope(Right = 1, Down = 2) ]

        slopes
        |> Seq.map (fun slope -> traverseMap slope map)
        |> Seq.reduce (*)

    part1, part2
