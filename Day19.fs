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

let rules, messages = runParser pInput (Input.asString 19)

let parserForRules =
    let parsers = rules |> List.fold (fun acc rule -> Map.add (ruleNumber rule) (createParserForwardedToRef<unit, unit>()) acc) Map.empty
    let parserUpdate i p = do Map.find i parsers |> snd := p

    let pLetter letter = pchar letter >>% ()
    let pSequence sequence = sequence |> Seq.map (fun i -> Map.find i parsers |> fst) |> Seq.reduce ((.>>))
     
    rules
    |> List.map (fun rule ->
        match rule with
        | Constant (i, letter) -> i, pLetter letter
        | Sequence (i, sequence) -> i, pSequence sequence
        | OneOrOther (i, left, right) -> i, choice [pSequence left |> attempt; pSequence right |> attempt]
    )
    |> List.iter (fun (i, p) -> parserUpdate i p)

    parsers

let ruleZeroMatches =
    let pRuleZero = parserForRules |> Map.find 0 |> fst .>> notFollowedBy anyChar
    let matchesRuleZero message =
        match run pRuleZero message with
        | Success _ -> true
        | Failure _ -> false
    
    messages
    |> Seq.filter matchesRuleZero
    |> Seq.length

let part1 = ruleZeroMatches
    
let part2 = 0

let solution = part1, part2
