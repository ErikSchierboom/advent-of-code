module AdventOfCode

open System.IO

module Input =
    let private inputFilePath day = Path.Combine("Input", sprintf "%d.txt" day)

    let lines day = File.ReadAllLines(inputFilePath day)

    let integers day = lines day |> Array.map int

module Day1 =
    let solve () =
        let numbers = Input.integers 1
        
        let part1 =
            [ for n1 in numbers do
                for n2 in numbers do
                    if n1 + n2 = 2020 then yield n1 * n2 ]
            |> List.head

        let part2 =
            [ for n1 in numbers do
                for n2 in numbers do
                    for n3 in numbers do
                        if n1 + n2 + n3 = 2020 then yield n1 * n2 * n3 ]
            |> List.head

        (part1, part2)
        
module Day2 =
    open System.Text.RegularExpressions
  
    type PasswordEntry =
        { Min: int
          Max: int
          Letter: char
          Password: string }
        
    let private parsePasswordEntry line =        
        let m = Regex.Match(line, @"^(\d+)-(\d+) ([a-z]): ([a-z]+)$")
        { Min = int m.Groups.[1].Value
          Max = int m.Groups.[2].Value
          Letter = m.Groups.[3].Value.[0]
          Password = m.Groups.[4].Value }
    
    let private isValidOldPassword entry =        
        let letterCounts = entry.Password |> Seq.filter (fun l -> l = entry.Letter) |> Seq.length
        letterCounts >= entry.Min && letterCounts <= entry.Max
        
    let private isValidNewPassword entry =        
        (entry.Password.[entry.Min - 1] = entry.Letter) <> (entry.Password.[entry.Max - 1] = entry.Letter)
    
    let solve() =
        let passwordEntries = Input.lines 2 |> Seq.map parsePasswordEntry
        
        let part1 =
            passwordEntries
            |> Seq.filter isValidOldPassword
            |> Seq.length
            
        let part2 =
            passwordEntries
            |> Seq.filter isValidNewPassword
            |> Seq.length
            
        part1, part2

[<EntryPoint>]
let main _ =
    printfn "Day 1: %A" (Day1.solve ())
    printfn "Day 2: %A" (Day2.solve ())

    0