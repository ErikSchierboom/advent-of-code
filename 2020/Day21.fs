module AdventOfCode.Day21

open System.Text.RegularExpressions

let foods =
    let parse (line: string) =
        let m = Regex.Match(line, "^((?<ingredient>\w+)( |$))+(\(contains ((?<allergen>\w+)|(, |\)$))+)?")
        let captures (name: string) = m.Groups.[name].Captures |> Seq.map (fun capture -> capture.Value) |> Set.ofSeq
        captures "ingredient", captures "allergen"
    
    Input.asLines 21 |> Array.map parse

let allergensToIngredients =
    let rec buildMapping mapping remainder =
        match remainder |> List.sortBy (snd >> Set.count) with
        | [] -> mapping
        | (ingredient, allergens)::xs ->
            let allergen = Seq.head allergens
            let updatedRemainder = xs |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
            buildMapping ((ingredient, allergen)::mapping) updatedRemainder

    foods
    |> Seq.collect (fun (ingredients, allergens) -> allergens |> Seq.map (fun allergen -> allergen, ingredients))
    |> Seq.groupBy fst
    |> Seq.map (fun (allergen, group) -> allergen, group |> Seq.map snd |> Seq.reduce Set.intersect)
    |> Seq.toList
    |> buildMapping []

let part1 =
    let hasAllergen ingredient =
        allergensToIngredients
        |> Seq.map snd
        |> Seq.contains ingredient

    foods
    |> Seq.collect fst
    |> Seq.filter (hasAllergen >> not)
    |> Seq.length
    
let part2 =
    allergensToIngredients
    |> Seq.sortBy fst
    |> Seq.map snd
    |> String.concat ","

let solution = part1, part2
