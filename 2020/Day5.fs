module AdventOfCode.Day5

let boardingPasses = Input.asLines 5

let seatId (boardingPass: string) =
    boardingPass
    |> Seq.fold (fun acc elem -> if elem = 'B' || elem = 'R' then acc <<< 1 ||| 1 else acc <<< 1) 0

let seatIds = boardingPasses |> Seq.map seatId

let part1 = seatIds |> Seq.max

let part2 =
    seatIds
    |> Seq.sort
    |> Seq.pairwise
    |> Seq.pick (fun (left, right) -> if right - left = 2 then Some(left + 1) else None)

let solution = part1, part2
