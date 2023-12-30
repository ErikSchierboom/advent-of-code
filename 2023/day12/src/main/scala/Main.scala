import scala.io.Source
import scala.collection.mutable

case class Record(conditions: List[Char], damagedCounts: List[Int])

object Record {
  def parseAll(repetitions: Int): Iterator[Record] =
    Source.fromResource("input.txt").getLines().map(parse(repetitions, _))

  private def parse(repetitions: Int, line: String): Record =
    val parts = line.split(' ')
    val conditions = List.fill(repetitions)(parts(0)).mkString("?").toList
    val damagedGroups = List.fill(repetitions)(parts(1)).mkString(",").split(',').map(_.toInt).toList
    Record(conditions, damagedGroups)
}

def solve(repetitions: Int) =
  val cache = mutable.Map[String, Long]()

  def numOperationalArrangements(current: Record, currentDamagedCount: Int): Long =
    cache.getOrElseUpdate(s"${current}-${currentDamagedCount}",
      (current.conditions, current.damagedCounts) match
        case (Nil, Nil) if currentDamagedCount == 0 => 1
        case (Nil, `currentDamagedCount` :: Nil) => 1
        case ('.' :: xs, `currentDamagedCount` :: ys) =>
          numOperationalArrangements(current.copy(conditions = xs, damagedCounts = ys), 0)
        case ('.' :: xs, _) if currentDamagedCount == 0 =>
          numOperationalArrangements(current.copy(conditions = xs), 0)
        case ('#' :: xs, damageCount :: _) if currentDamagedCount < damageCount =>
          numOperationalArrangements(current.copy(conditions = xs), currentDamagedCount + 1)
        case ('?' :: xs, _) =>
          numOperationalArrangements(current.copy(conditions = '.' :: xs), currentDamagedCount) +
          numOperationalArrangements(current.copy(conditions = '#' :: xs), currentDamagedCount)
        case _ => 0)

  Record.parseAll(repetitions).map(numOperationalArrangements(_, 0)).sum

@main def main: Unit =
  println("part a: " + solve(1))
  println("part b: " + solve(5))
