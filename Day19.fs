module AdventOfCode.Day19

open FParsec

type Rule =
    | Constant of int * char
    | Sequence of int * int list
    | OneOrOther of int * int list * int list

let ruleNumber = function
    | Constant (number, _)
    | Sequence (number, _)
    | OneOrOther (number, _, _) -> number

let pLetter = asciiLetter
let pNum = pint32
let pNums = sepEndBy1 pint32 (pchar ' ')
let pSep = pchar ':' .>> spaces
let pCons = pNum .>> pSep .>>. (between (pchar '"') (pchar '"') pLetter) |>> Constant
let pSeq = pNum .>> pSep .>>. pNums |>> Sequence
let pOpt = pNum .>> pSep .>>. pNums .>> spaces .>> pstring "|" .>> spaces .>>. pNums |>> fun ((number, left), right) -> OneOrOther (number, left, right)
let pRule = choice [attempt pCons; attempt pOpt; pSeq]
let pMsg = many1Chars pLetter
let pInput = sepEndBy1 pRule newline .>> skipNewline .>>. sepEndBy1 pMsg newline

let runParser parser input =
    match run parser input with
    | Success (result, _, _) -> result
    | Failure (error, _, _) -> failwith error

let ruleZeroMatches input =
    let rules, messages = runParser pInput input
    let rules = rules |> Seq.map (fun rule -> ruleNumber rule, rule) |> Map.ofSeq
    let rulesFromSequence sequence = sequence |> List.map (fun i -> Map.find i rules)
    let ruleZero = rules |> Map.find 0 
    
    let rec matches remainingRules (message: string) =
        match remainingRules with
        | _ when message = "" -> List.isEmpty remainingRules
        | [] -> message.Length = 0
        | Constant (_, letter)::xs when letter = message.[0] ->
            matches xs message.[1..]
        | Constant _ :: _ -> false
        | Sequence (_, sequence)::xs ->
            matches (rulesFromSequence sequence @ xs) message
        | OneOrOther (_, left, right)::xs ->
            matches (rulesFromSequence left @ xs) message ||
            matches (rulesFromSequence right @ xs) message

    messages
    |> Seq.filter (matches [ruleZero])
    |> Seq.length

let part1 = Input.asString 19 |> ruleZeroMatches
    
let part2 = Input.asString 19 |> fun input -> input.Replace("8: 42", "8: 42 | 42 8").Replace("11: 42 31", "11: 42 31 | 42 11 31") |> ruleZeroMatches

let solution = part1, part2
