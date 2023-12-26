using OrderedCollections: OrderedDict

hash(txt) = foldl((acc, c) -> (acc + Int(c)) * 17 % 256, txt, init=0)

steps = split(read("input.txt", String), ",")

boxes = [OrderedDict{String,Int}() for _ = 1:256]
for m in map(step -> match(r"(?<label>\w+)(?<operator>[-=])(?<focal_length>\d+)?", step), steps)
    box = hash(m["label"]) + 1
    m["operator"] == "=" ? boxes[box][m["label"]] = parse(Int, m["focal_length"]) : delete!(boxes[box], m["label"])
end

println("part a: ", sum(hash.(steps)))
println("part b: ", sum(box_idx * lens_idx * focal for (box_idx, box) = enumerate(boxes) for (lens_idx, (_, focal)) = enumerate(box)))