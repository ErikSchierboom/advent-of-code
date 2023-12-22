import "io" for File

class Day11 {
    construct new() {
        _lines = File.read("input.txt").split("\n")
        _dimension = _lines.count
    }

    solve() {
        System.print("part a: %(minSteps(1))")
        System.print("part b: %(minSteps(999999))")
    }

    minSteps(emptyIncrement) {
        var rowOffsets = calcOffsets(emptyIncrement) { |a, b| _lines[a][b] }
        var colOffsets = calcOffsets(emptyIncrement) { |a, b| _lines[b][a] }
        var xs = []
        var ys = []

        for (row in 0..._dimension) {
            for (col in 0..._dimension) {
                if (_lines[row][col] == ".") continue

                ys.add(row + rowOffsets[row])
                xs.add(col + colOffsets[col])
            }
        }

        return distanceSum(xs) + distanceSum(ys)
    }

    calcOffsets(emptyIncrement, fn) {
        return (0..._dimension).reduce([]) { |offsets, a| 
            var emptyOffset = (0..._dimension).all {|b| fn.call(a, b) == "." } ? emptyIncrement : 0
            return offsets + [offsets.isEmpty ? 0 : offsets[-1] + emptyOffset]
        }
    }

    distanceSum(coords) {
        var sortedCoords = coords.sort()
        var res = 0
        var sum = 0
        for (i in 0...sortedCoords.count) {
            res = res + (sortedCoords[i] * i - sum)
            sum = sum + sortedCoords[i]
        }

        return res
    }
}

Day11.new().solve()
