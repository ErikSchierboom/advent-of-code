module AdventOfCode.Day11

type Status = Floor | Empty | Occupied

let parseStatus = function
    | '.' -> Floor
    | 'L' -> Empty
    | '#' -> Occupied
    | _   -> failwith "Invalid position"

let lines = Input.asLines 11
let rows, cols = lines.Length, lines.[0].Length

let initialSeatLayout = Array2D.init rows cols (fun row col -> lines.[row].[col] |> parseStatus)
let seatPositions = Array2D.init rows cols (fun row col -> row, col) |> Seq.cast<int * int> |> Seq.toArray
let seatOffsets = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1]

let tryOffsetToPosition (row, col) (dy, dx) =
    let offsetRow, offsetCol = row + dy, col + dx
    let isValidRow = offsetRow >= 0 && offsetRow < rows
    let isValidCol = offsetCol >= 0 && offsetCol < cols    
    if isValidRow && isValidCol then Some (offsetRow, offsetCol) else None
 
let seat seatLayout (row, col) = Array2D.get seatLayout row col
let isOccupied seatLayout position = seat seatLayout position = Occupied
let isFloor seatLayout position = seat seatLayout position = Floor

let occupiedSeats tryOffsetToPositionFunc seatLayout position =
    seatOffsets
    |> Seq.choose (tryOffsetToPositionFunc position)
    |> Seq.filter (isOccupied seatLayout) 
    |> Seq.length

let adjacentOccupiedSeats seatLayout position = occupiedSeats tryOffsetToPosition seatLayout position
    
let diagonalOccupiedSeats seatLayout position =
    let rec firstSeatForOffset currentPosition seatOffset =
        let loop offsetPosition =
            if isFloor seatLayout offsetPosition then
                firstSeatForOffset offsetPosition seatOffset
            else
                Some offsetPosition 
        
        tryOffsetToPosition currentPosition seatOffset
        |> Option.bind loop
    
    occupiedSeats firstSeatForOffset seatLayout position

let updateSeat countOccupiedSeats minOccupiedSeatCount layout row col cell =
    match cell with
    | Empty when countOccupiedSeats layout (row, col) = 0 -> Occupied
    | Occupied when countOccupiedSeats layout (row, col) >= minOccupiedSeatCount -> Empty
    | _ -> cell

let findStableSeating updateSeatFunc =    
    let rec loop currentSeatLayout =    
        let updatedSeatLayout = currentSeatLayout |> Array2D.mapi (updateSeatFunc currentSeatLayout)    
        if updatedSeatLayout = currentSeatLayout then updatedSeatLayout else loop updatedSeatLayout
        
    loop initialSeatLayout

let findStableOccupiedSeatCount updateSeatFunc =
    findStableSeating updateSeatFunc
    |> Seq.cast<Status>
    |> Seq.filter ((=) Occupied)
    |> Seq.length

let part1 = findStableOccupiedSeatCount (updateSeat adjacentOccupiedSeats 4)
let part2 = findStableOccupiedSeatCount (updateSeat diagonalOccupiedSeats 5)

let solution = part1, part2