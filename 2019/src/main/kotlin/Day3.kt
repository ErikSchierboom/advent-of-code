import kotlin.math.abs

data class Coordinate(val x: Int, val y: Int) {
    fun manhattanDistance() = abs(x) + abs(y)
}

class Wire {
    var visited = mutableListOf(Coordinate(0, 0))

    fun travel(path: String): Wire {
        val distance = path.substring(1).toInt()
        val (dx, dy) = when (path[0]) {
            'U' ->  0 to  1
            'D' ->  0 to -1
            'R' ->  1 to  0
            'L' -> -1 to  0
            else -> throw IllegalStateException("Invalid instruction")
        }

        1.rangeTo(distance).forEach {
            val current = visited.last()
            visited.add(Coordinate(current.x + dx, current.y + dy))
        }

        return this
    }

    fun steps(coordinate: Coordinate) = visited.indexOf(coordinate)

    infix fun intersect(other: Wire) = visited.toSet().intersect(other.visited.toSet())

    companion object {
        fun fromPaths(paths: List<String>) = paths.fold(Wire()) { path, change -> path.travel(change) }
    }
}

object Day3 {
    private val paths = getResourceAsLines("day3.txt").map { it.split(',') }
        private val firstWire = Wire.fromPaths(paths[0])
        private val secondWire = Wire.fromPaths(paths[1])
        private val intersections = firstWire.intersect(secondWire).minus(Coordinate(0, 0))

        fun part1() = intersections.minOf { it.manhattanDistance() }
        fun part2() = intersections.minOf { firstWire.steps(it) + secondWire.steps(it) }
    }