module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") with
    | [| ingredientsStr |] -> words ingredientsStr, Set.empty  
    | [| ingredientsStr; allergensStr |] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood

let allergies =
    foods
    |> Seq.collect (fun (ingredients, allergens) -> allergens |> Seq.map (fun allergen -> allergen, ingredients))
    |> Seq.groupBy fst
    |> Seq.map (fun (allergen, group) -> allergen, group |> Seq.map snd |> Seq.reduce Set.intersect)
    |> Map.ofSeq

let rec loop mapping remainder =
    match remainder with
    | [] ->
        mapping
    | (ingredient, allergens)::xs ->
        let allergen = Seq.head allergens
        let updated =
            xs
            |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
            |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens)
        loop (Map.add ingredient allergen mapping) updated
    
loop Map.empty (allergies |> Map.toList |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens))
|> Map.toSeq
|> Seq.sortBy fst
|> printfn "%A"

let allergens = allergies |> Map.toSeq |> Seq.map fst
let ingredients = allergies |> Map.toSeq |> Seq.collect snd

let part1 =
    let ingredientsWithAllergens = ingredients |> Set.ofSeq

    let ingredientsWithoutAllergens =
        foods
        |> Seq.collect fst
        |> Set.ofSeq
        |> fun ingredients -> Set.difference ingredients ingredientsWithAllergens 
    
    foods
    |> Seq.collect fst
    |> Seq.filter (fun ingredient -> Set.contains ingredient ingredientsWithoutAllergens)
    |> Seq.length
    
let part2 =
    let rec loop mapping remainder =
        match remainder with
        | [] ->
            mapping
        | (ingredient, allergens)::xs ->
            let allergen = Seq.head allergens
            let updated =
                xs
                |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
                |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens)
            loop (Map.add ingredient allergen mapping) updated
        
    loop Map.empty (allergies |> Map.toList |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens))
    |> Map.toSeq
    |> Seq.sortBy fst
    |> Seq.map snd
    |> String.concat ","

let solution = part1, part2
