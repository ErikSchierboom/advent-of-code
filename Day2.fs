module AdventOfCode.Day2

open System.Text.RegularExpressions
  
type private PasswordEntry =
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