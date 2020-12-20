module AdventOfCode.Day19

open System.Text.RegularExpressions

type Rule =
    | Constant of int * char
    | Sequence of int * int[]
    | Choice of int * int[] * int[]

type Rules = Map<int, Rule>

let (|Regex|_|) pattern input =
    let m = Regex.Match(input, pattern)
    if m.Success then
        Some (m.Groups |> Seq.map (fun group -> group.Name, group.Captures |> Seq.map (fun capture -> capture.Value) |> Seq.toArray) |> Map.ofSeq)
    else
        None

let parseRule rule =
    match rule with
    | Regex "^(?<number>\d+): \"(?<letter>[a-z+])\"$" groups -> Constant (Map.find "number" groups |> Array.head |> int, Map.find "letter" groups |> Array.head |> Seq.head)
    | Regex "^(?<number>\d+): ((?<sequence>\d+) ?)+$" groups -> Sequence (Map.find "number" groups |> Array.head |> int, Map.find "sequence" groups |> Array.map int)
    | Regex "^(?<number>\d+): ((?<left>\d+) ?)+ \| ((?<right>\d+) ?)+$" groups -> Choice (Map.find "number" groups |> Array.head |> int, Map.find "left" groups |> Array.map int, Map.find "right" groups |> Array.map int)
    | _ -> failwith "Invalid rule"

let ruleNumber = function Constant (number, _) | Sequence (number, _) | Choice (number, _, _) -> number

let rules, messages =
    let lines = Input.asLines 19
    let rules = lines |> Seq.takeWhile (fun line -> line.Length <> 0) |> Seq.map parseRule |> Seq.map (fun rule -> ruleNumber rule, rule) |> Map.ofSeq
    let messages = lines |> Seq.skipWhile (fun line -> line.Length <> 0) |> Seq.tail |> Seq.toArray    
    rules, messages

let matches message =
    let rec loop index rule (remainder: string) =
        match Map.find rule rules with
        | Constant (_, letter) -> remainder.[index] = letter
        | Sequence (_, rules) -> false            
        | Choice (_, left, right) -> false 
        
    loop 0 0 message

//0: 4 1 5
//1: 2 3 | 3 2
//2: 4 4 | 5 5
//3: 4 5 | 5 4
//4: "a"
//5: "b"
//
//ababbb
//bababa
//abbbab
//aaabbb
//aaaabbb

let part1 =
    0
    
let part2 = 0

let solution = part1, part2
