object Day6 {
    private val map = readResourceAsLines("day6.txt")
        .associate { line -> line.split(')').let { it[1] to it[0] } }

    fun part1() = 0 /*map.asSequence().fold(mapOf("COM" to 0)) { counts, orbit ->
        counts + (orbit.key to counts.getValue(orbit.value) + 1)
    }.values.sum()*/

    fun part2(): Int {
        val pathFromYou = pathToRoot("YOU")
        val pathFromSan = pathToRoot("SAN")

        val beforeSplit = pathFromYou.takeWhile { it !in pathFromSan }
        val split = pathFromYou[beforeSplit.size]
        val afterSplit = pathFromSan.takeWhile { it != split }
        val path = beforeSplit + listOf(split) + afterSplit
        return path.size - 1
    }

    private fun pathToRoot(from: String) = generateSequence(map[from]) { map[it] }.toList()
}