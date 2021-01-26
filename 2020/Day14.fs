module AdventOfCode.Day14

open System.Text.RegularExpressions

let instructions = Input.asLines 14

let (|Regex|_|) pattern input =
    let m = Regex.Match(input, pattern)
    if m.Success then
        Some (m.Groups |> Seq.map (fun group -> group.Name, group.Value) |> Map.ofSeq)
    else
        None

let (|UpdateMaskInstruction|_|) instruction =
    match instruction with
    | Regex "^mask = (?<mask>[X01]{36})$" groups -> Some (Map.find "mask" groups)
    | _ -> None

let (|WriteToMemoryInstruction|_|) instruction =
    match instruction with
    | Regex "^mem\[(?<address>\d+)\] = (?<value>\d+)$" groups -> Some (Map.find "address" groups |> uint64, Map.find "value" groups |> uint64)
    | _ -> None

let decode mask value =
    mask 
    |> Seq.fold (fun (andMask, orMask) ->
         function
         | 'X' -> andMask <<< 1 ||| 1UL, orMask <<< 1
         | '1' -> andMask <<< 1 ||| 1UL, orMask <<< 1 ||| 1UL
         | '0' -> andMask <<< 1, orMask <<< 1
         | _   -> failwith "Unknown mask"
    ) (0UL, 0UL)
    |> fun (andMask, orMask) -> value &&& andMask ||| orMask 

let encodedValueToInstructions mask (address, value) =
    [address, decode mask value]

let encodedAddressToInstructions mask (address, value) =
    let rec decodeAddressInstructions masks remainder =
        match remainder with
        | [] -> [""]
        | 'X'::xs -> decodeAddressInstructions masks xs |> List.collect (fun x -> ["1" + x; "0" + x])
        | '0'::xs -> decodeAddressInstructions masks xs |> List.map (fun x -> "X" + x)
        | '1'::xs -> decodeAddressInstructions masks xs |> List.map (fun x -> "1" + x)
        | _ -> failwith "Unknown encoding"

    mask
    |> Seq.toList
    |> decodeAddressInstructions []
    |> Seq.map (fun addressMask -> decode addressMask address, value)

let updateMask (memory, _) newMask = memory, newMask

let writeToMemory decodeInstructions (memory, mask) instruction =
    decodeInstructions mask instruction
    |> Seq.fold (fun (memory, mask) (address, value) -> Map.add address value memory, mask) (memory, mask)

let execute decoder =
    instructions
    |> Seq.fold (fun state instruction ->
        match instruction with
        | UpdateMaskInstruction mask -> updateMask state mask
        | WriteToMemoryInstruction instruction -> writeToMemory decoder state instruction 
        | _ -> failwith "Unknown instruction"
    ) (Map.empty, "")
    |> fst
    |> Map.fold (fun acc _ value -> acc + value) 0UL

let part1 = execute encodedValueToInstructions
let part2 = execute encodedAddressToInstructions

let solution = part1, part2
