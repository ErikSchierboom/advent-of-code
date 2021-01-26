module AdventOfCode.Day10

let voltages = Input.asInt64s 10
let chargingOutletVoltage = 0L
let deviceVoltage = Array.max voltages + 3L

let adapters =
    voltages
    |> Seq.append [| chargingOutletVoltage; deviceVoltage |]
    |> Seq.sort

let part1 =
    adapters
    |> Seq.pairwise
    |> Seq.countBy (fun (left, right) -> right - left)
    |> Map.ofSeq
    |> fun counts -> counts.[1L] * counts.[3L]

let part2 =
    adapters
    |> Seq.skip 1
    |> Seq.fold (fun acc elem ->
        acc |> Map.add elem ([1L..3L] |> Seq.sumBy (fun i -> Map.tryFind (elem - i) acc |> Option.defaultValue 0L))) (Map.add 0L 1L Map.empty)
    |> Map.find deviceVoltage

let solution = part1, part2