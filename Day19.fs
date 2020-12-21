module AdventOfCode.Day19

open FParsec

type Rule =
    | Constant of char
    | Sequence of int list
    | OneOrOther of int list * int list

let pLetter = asciiLetter
let pNumber = pint32
let pNumbers = sepEndBy1 pint32 (pchar ' ')
let pSeparator = pchar ':' .>> spaces
let pConstant = pNumber .>> pSeparator .>>. (between (pchar '"') (pchar '"') pLetter |>> Constant)
let pSequence = pNumber .>> pSeparator .>>. (pNumbers |>> Sequence)
let pOneOrOther = pNumber .>> pSeparator .>>. (pNumbers .>> spaces .>> pstring "|" .>> spaces .>>. pNumbers |>> OneOrOther)
let pRule = choice [attempt pConstant; attempt pOneOrOther; pSequence]
let pRules = sepEndBy1 pRule newline |>> Map.ofSeq
let pMessage = many1Chars pLetter
let pMessages = sepEndBy1 pMessage newline
let pInput = pRules .>> skipNewline .>>. pMessages

let runParser parser input =
    match run parser input with
    | Success (result, _, _) -> result
    | Failure (error, _, _) -> failwith error

let ruleZeroMatches input =
    let rules, messages = runParser pInput input
    let rulesFromSequence sequence = sequence |> List.map (fun i -> Map.find i rules)
     
    let rec matches remainingRules remainingLetters =
        match remainingRules, remainingLetters with
        | [], [] -> true
        | [], _ -> false
        | _, [] -> false
        | Constant letter::xs, first::remainder when letter = first ->
            matches xs remainder
        | Constant _ :: _, _ -> false
        | Sequence sequence::xs, message ->
            matches (rulesFromSequence sequence @ xs) message
        | OneOrOther (left, right)::xs, message ->
            matches (rulesFromSequence left @ xs) message ||
            matches (rulesFromSequence right @ xs) message

    messages
    |> Seq.filter (Seq.toList >> matches [rules |> Map.find 0])
    |> Seq.length

let part1 = Input.asString 19 |> ruleZeroMatches
    
let part2 = Input.asString 19 |> fun input -> input.Replace("8: 42", "8: 42 | 42 8").Replace("11: 42 31", "11: 42 31 | 42 11 31") |> ruleZeroMatches

let solution = part1, part2
