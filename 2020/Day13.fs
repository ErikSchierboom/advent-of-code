module AdventOfCode.Day13

let lines = Input.asLines 13
let departAt = int64 lines.[0]

let schedule =
    lines.[1].Split(',')
    |> Seq.indexed
    |> Seq.choose (fun (offset, busId) -> if busId = "x" then None else Some (int64 offset, int64 busId))
    |> Seq.toArray

let part1 =
    let minutesToWait departure busId = busId - (departure % busId)
    
    schedule
    |> Seq.map snd
    |> Seq.minBy (minutesToWait departAt)
    |> fun bus -> bus * (minutesToWait departAt bus)

let part2 =    
    let iterateOverTimeTable (departure, increment) (offset, bus) =
        Seq.initInfinite (fun i -> departure + int64 i * increment)
        |> Seq.find (fun possibleDeparture -> (possibleDeparture + offset) % bus = 0L)
        |> fun validDeparture -> validDeparture, increment * bus

    schedule
    |> Seq.fold iterateOverTimeTable (0L, 1L)
    |> fst

let solution = part1, part2