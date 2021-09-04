object Day1 {
    private val fuelPerModule = getResourceAsInts("day1.txt")

    fun part1() = fuelPerModule.sumOf(this::fuelRequirement)
    fun part2() = fuelPerModule.sumOf(this::cumulativeFuelRequirement)

    private fun fuelRequirement(fuel: Int) = fuel / 3 - 2
    private fun cumulativeFuelRequirement(fuel: Int) = generateSequence(fuelRequirement(fuel)) {
        fuelRequirement(it).takeIf { it > 0 }
    }.sum()
}
