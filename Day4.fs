module AdventOfCode.Day4

open System

let batch = Input.asString 4

let requiredFields = set [ "byr"; "iyr"; "eyr"; "hgt"; "hcl"; "ecl"; "pid" ]

let parseField (field: string) =
    let keyAndValue = field.Split(':')
    (keyAndValue.[0], keyAndValue.[1])

let parsePassport (lines: string) =
    lines.Split([| '\n'; ' ' |], StringSplitOptions.RemoveEmptyEntries)
    |> Seq.map parseField
    |> Map.ofSeq

let parsePassports = batch.Split("\n\n") |> Array.map parsePassport

let hasRequiredFields passport =
    let fields = 
        passport
        |> Map.toSeq
        |> Seq.map fst
        |> set

    requiredFields.IsSubsetOf(fields)

let isValidField field (value: string) =
    let inRange min max = int value >= min && int value <= max
    let color (suffix: string) min max = value.EndsWith(suffix) && int value.[0..value.Length - 3] >= min && int value.[0..value.Length - 3] <= max
    let isHex c = Char.IsDigit(c) || List.contains c ['a'..'f'] 
    
    match field with
    | "byr" -> inRange 1920 2002
    | "iyr" -> inRange 2010 2020
    | "eyr" -> inRange 2020 2030
    | "hgt" -> color "cm" 150 193 || color "in" 59 76
    | "hcl" -> value.StartsWith('#') && value.Length = 7 && Seq.forall isHex value.[1..]
    | "ecl" -> List.contains value ["amb";"blu";"brn";"gry";"grn";"hzl";"oth"]
    | "pid" -> value.Length = 9 && Seq.forall Char.IsDigit value
    | "cid" -> true
    | _ -> failwith "Invalid field"

let passports = parsePassports

let hasValidFields passport =
    passport
    |> Map.forall isValidField

let part1 =
    passports
    |> Seq.filter hasRequiredFields
    |> Seq.length

let part2 =
    passports
    |> Seq.filter hasRequiredFields
    |> Seq.filter hasValidFields
    |> Seq.length

let solution = part1, part2