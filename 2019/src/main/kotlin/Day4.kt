object Day4 {
    private val passwordRange = readResourceAsText("day4.txt")
        .split("-")
        .let { it[0].toInt() .. it[1].toInt() }
        .map { it.digits() }

    fun part1() = passwordRange.count { it.incrementing() && it.counts().any { count -> count.value >= 2 }}
    fun part2() = passwordRange.count { it.incrementing() && it.counts().containsValue(2)}

    private fun Int.digits() = toString().map { it.digitToInt() }
    private fun List<Int>.incrementing() = windowed(2).all { it[0] <= it[1] }
    private fun List<Int>.counts() = groupingBy { it }.eachCount()
}