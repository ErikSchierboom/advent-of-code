local function tonumbers(line)
  local numbers = {}

  for number in string.gmatch(line, "%d+") do
    numbers[#numbers + 1] = tonumber(number)
  end

  return numbers
end

local function torange(min, count)
  return { min = min, max = min + count - 1, count = count }
end

local function torangemap(line)
  local numbers = tonumbers(line)
  return { destination = torange(numbers[1], numbers[3]), source = torange(numbers[2], numbers[3]) }
end

local function min_range(range, level, maps)
  local current = range.min
  local min = 99999999999

  if maps[level] == nil then
    return range.min
  end

  while current <= range.max do
    local old_current = current

    for _, map in pairs(maps[level].ranges) do
      if map.source.min <= current and map.source.max >= current then
        local offset = current - map.source.min
        local count = math.min(map.source.count - offset, range.count - (current - range.min))
        min = math.min(min, min_range(torange(map.destination.min + offset, count), level + 1, maps))
        current = current + count
        break
      end
    end

    if old_current == current then
      min = math.min(min, min_range(torange(current, range.max - current + 1), level + 1, maps))
      break
    end
  end

  return min
end

local function parse()
  local result = { seeds = {}, maps = {} }
  local map = { name = nil, ranges = {} }

  for line in assert(io.lines("input.txt")) do
    if string.match(line, "^seeds: ") then
      result.seeds = tonumbers(line)
    elseif string.match(line, "map:$") then
      result.maps[#result.maps + 1] = { name = string.match(line, "^[^ ]+"), ranges = {} }
    elseif string.match(line, "^%d") then
      map = result.maps[#result.maps]
      map.ranges[#map.ranges + 1] = torangemap(line)
    end
  end

  return result
end

local parsed = parse()

local part_a = 99999999999
local part_b = 99999999999

for _, seed in pairs(parsed.seeds) do
  part_a = math.min(part_a, min_range(torange(seed, 1), 1, parsed.maps))
end

for i = 1, #parsed.seeds, 2 do
  part_b = math.min(part_b, min_range(torange(parsed.seeds[i], parsed.seeds[i + 1]), 1, parsed.maps))
end

print("part a: ", part_a)
print("part b: ", part_b)
