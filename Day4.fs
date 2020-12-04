module AdventOfCode.Day4

open System.Text.RegularExpressions

module Map =
    let keys map = map |> Map.toSeq |> Seq.map fst

let batch = Input.asString 4

let requiredFields = set [ "byr"; "iyr"; "eyr"; "hgt"; "hcl"; "ecl"; "pid" ]

let parsePassport (lines: string) =
    Regex.Matches(lines, "([a-z]{3}):([^ \n]+)")
    |> Seq.map (fun m -> (m.Groups.[1].Value, m.Groups.[2].Value))
    |> Map.ofSeq

let passports = batch.Split("\n\n") |> Array.map parsePassport

let hasRequiredFields passport =
    passport
    |> Map.keys
    |> set
    |> Set.isSubset requiredFields

let isValidField field (value: string) =
    let inRange min max n = n >= min && n <= max 
    let color (suffix: string) min max = value.EndsWith(suffix) && int <| value.Replace(suffix, "") >= min && int <| value.Replace(suffix, "") <= max
    
    match field with
    | "byr" -> int value |> inRange 1920 2002 
    | "iyr" -> int value |> inRange 2010 2020
    | "eyr" -> int value |> inRange 2020 2030
    | "hgt" -> color "cm" 150 193 || color "in" 59 76
    | "hcl" -> Regex.IsMatch(value, "^#[a-f0-9]{6}$")
    | "ecl" -> Regex.IsMatch(value, "^(amb|blu|brn|gry|grn|hzl|oth)$")
    | "pid" -> Regex.IsMatch(value, "^\d{9}$")
    | "cid" -> true
    | _ -> failwith "Invalid field"

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