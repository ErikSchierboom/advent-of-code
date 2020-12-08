module AdventOfCode.Day8

type Operation =
    | Acc
    | Jmp
    | Nop

type Instruction =
    { Operation: Operation
      Argument: int }

type ExecutionState =
    { Offset: int
      Accumulator: int }

type ExecutionResult =
    | Terminated of ExecutionState
    | InfiniteLoop of ExecutionState

let parseInstruction (line: string) =
    match line.Split(' ') with
    | [| "acc"; arg |] -> { Operation = Acc; Argument = int arg }
    | [| "jmp"; arg |] -> { Operation = Jmp; Argument = int arg }
    | [| "nop"; arg |] -> { Operation = Nop; Argument = int arg }
    | _ -> failwith "Invalid instruction"

let parsedInstructions = Input.asLines 8 |> Array.map parseInstruction

let executeInstruction state instruction =
    match instruction.Operation with
    | Acc -> { state with Offset = state.Offset + 1; Accumulator = state.Accumulator + instruction.Argument }
    | Jmp -> { state with Offset = state.Offset + instruction.Argument }
    | Nop -> { state with Offset = state.Offset + 1 }

let execute instructions =
    let rec inner state processed =
        if state.Offset >= Array.length instructions then
            Terminated state
        elif Set.contains state.Offset processed then
            InfiniteLoop state
        else
            inner (instructions.[state.Offset] |> executeInstruction state) (Set.add state.Offset processed)
    
    let initialState = { Offset = 0; Accumulator = 0 }
    inner initialState Set.empty

let part1 =
    match execute parsedInstructions with
    | InfiniteLoop state -> state.Accumulator
    | Terminated _ -> failwith "Parsed instructions should be infinite loop"

let modifiedInstructions =
    parsedInstructions
    |> Seq.indexed
    |> Seq.choose (fun (i, instruction) ->
        match instruction.Operation with
        | Jmp ->
            let modifiedInstructions = Array.copy parsedInstructions
            modifiedInstructions.[i] <- { instruction with Operation = Nop }
            Some modifiedInstructions
        | Nop ->
            let modifiedInstructions = Array.copy parsedInstructions
            modifiedInstructions.[i] <- { instruction with Operation = Jmp }
            Some modifiedInstructions
        | Acc -> None
    )

let part2 =
    modifiedInstructions
    |> Seq.pick (fun instructions ->
        match execute instructions with
        | Terminated state -> Some state.Accumulator
        | InfiniteLoop _ -> None)

let solution = part1, part2