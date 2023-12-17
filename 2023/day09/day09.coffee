fs = require 'fs'

parse = ->
  fs.readFileSync("input.txt", "ascii")
    .split("\n")
    .map (line) -> line.split(" ").map (num) -> parseInt num

solve = (lines) ->
  lines.reduce (acc, line) ->
    while not line.every (num) -> num is 0
      acc += line[line.length - 1]

      for i in [0...line.length - 1]
        line[i] = line[i + 1] - line[i]

      line.pop()

    acc
  , 0

console.log "part_a:", solve(parse())
console.log "part_b:", solve(parse().map (line) -> line.reverse())
