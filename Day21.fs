module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") with
    | [| ingredientsStr |] -> words ingredientsStr, Set.empty  
    | [| ingredientsStr; allergensStr |] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood

let ingredients = foods |> Seq.collect fst |> Seq.toList

let allergensToIngredients =
    let allergies =
        foods
        |> Seq.collect (fun (ingredients, allergens) -> allergens |> Seq.map (fun allergen -> allergen, ingredients))
        |> Seq.groupBy fst
        |> Seq.map (fun (allergen, group) -> allergen, group |> Seq.map snd |> Seq.reduce Set.intersect)
        |> Map.ofSeq
    
    let rec loop mapping remainder =
        match remainder |> List.sortBy (snd >> Set.count) with
        | [] ->
            mapping
        | (ingredient, allergens)::xs ->
            let allergen = Seq.head allergens
            let updated =
                xs
                |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
                
            loop (Map.add ingredient allergen mapping) updated
        
    loop Map.empty (allergies |> Map.toList) |> Map.toList

let ingredientsWithAllergen = allergensToIngredients |> Seq.map snd |> Seq.toList

let part1 =
    ingredients
    |> Seq.filter (fun ingredient -> List.contains ingredient ingredientsWithAllergen |> not)
    |> Seq.length
    
let part2 =
    allergensToIngredients
    |> Seq.sortBy fst
    |> Seq.map snd
    |> String.concat ","

let solution = part1, part2
