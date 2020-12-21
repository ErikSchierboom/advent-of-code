module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") with
    | [| ingredientsStr |] -> words ingredientsStr, Set.empty  
    | [| ingredientsStr; allergensStr |] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood

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
