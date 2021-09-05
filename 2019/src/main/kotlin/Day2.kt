object Day2 {
     private val instructions = readResourceAsText("day2.txt").split(',').map(String::toInt)

     class Program(val state: MutableList<Int>, var instructionPointer: Int = 0) {
         fun execute(): Unit = when (state[instructionPointer]) {
             1 -> executeBinaryInstruction(Int::plus).also { execute() }
             2 -> executeBinaryInstruction(Int::times).also { execute() }
             99 -> {}
             else -> throw IllegalStateException("Invalid opcode")
         }

         private fun executeBinaryInstruction(op: (Int, Int) -> Int) {
             val left = state[state[instructionPointer + 1]]
             val right = state[state[instructionPointer + 2]]
             val address = state[instructionPointer + 3]
             state[address] = op(left, right)
             instructionPointer += 4
         }
     }

     fun part1() = executeWithNounAndVerb(12, 2)

     fun part2() = 0.rangeTo(99)
         .product()
         .first { executeWithNounAndVerb(it.first, it.second) == 19690720 }
         .let { 100 * it.first + it.second }

    private fun executeWithNounAndVerb(noun: Int, verb: Int): Int {
        val state = instructions.toMutableList()
        state[1] = noun
        state[2] = verb

        val program = Program(state, 0)
        program.execute()
        return program.state[0]
    }

     private fun IntRange.product() = flatMap { x -> this.map { y -> x to y } }
 }
