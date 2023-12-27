import gleam/io
import gleam/list
import gleam/dict
import gleam/set
import gleam/string
import gleam/int
import gleam/queue
import gleam/otp/task
import simplifile

pub type Direction {
  Up
  Right
  Down
  Left
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type Beam {
  Beam(position: Position, direction: Direction)
}

pub type State {
  State(beams: queue.Queue(Beam), visited: set.Set(Beam))
}

pub type Layout {
  Layout(cells: dict.Dict(Position, String), dimension: Int)
}

fn move(beam: Beam, cell: String, beams: queue.Queue(Beam)) -> queue.Queue(Beam) {
  case #(beam, cell) {
    #(Beam(Position(x, y), Up), "\\") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
    #(Beam(Position(x, y), Right), "\\") ->
      queue.push_back(beams, Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Down), "\\") ->
      queue.push_back(beams, Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Left), "\\") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
    #(Beam(Position(x, y), Up), "/") ->
      queue.push_back(beams, Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Right), "/") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
    #(Beam(Position(x, y), Down), "/") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
    #(Beam(Position(x, y), Left), "/") ->
      queue.push_back(beams, Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Up), "|") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
    #(Beam(Position(x, y), Right), "|") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
      |> queue.push_back(Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Down), "|") ->
      queue.push_back(beams, Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Left), "|") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
      |> queue.push_back(Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Up), "-") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
      |> queue.push_back(Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Right), "-") ->
      queue.push_back(beams, Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Down), "-") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
      |> queue.push_back(Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Left), "-") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
    #(Beam(Position(x, y), Up), ".") ->
      queue.push_back(beams, Beam(Position(x, y - 1), Up))
    #(Beam(Position(x, y), Right), ".") ->
      queue.push_back(beams, Beam(Position(x + 1, y), Right))
    #(Beam(Position(x, y), Down), ".") ->
      queue.push_back(beams, Beam(Position(x, y + 1), Down))
    #(Beam(Position(x, y), Left), ".") ->
      queue.push_back(beams, Beam(Position(x - 1, y), Left))
    _ -> beams
  }
}

fn simulate(state: State, layout: Layout) -> State {
  case queue.pop_back(state.beams) {
    Ok(#(beam, beams)) -> {
      case
        #(
          set.contains(state.visited, beam),
          dict.get(layout.cells, beam.position),
        )
      {
        #(False, Ok(cell)) ->
          simulate(
            State(
              beams: move(beam, cell, beams),
              visited: set.insert(state.visited, beam),
            ),
            layout,
          )
        _ -> simulate(State(..state, beams: beams), layout)
      }
    }
    Error(_) -> state
  }
}

fn num_energized_tiles(state: State) -> Int {
  state.visited
  |> set.fold(set.new(), fn(positions, beam) {
    set.insert(positions, beam.position)
  })
  |> set.size()
}

fn parse() -> Layout {
  let assert Ok(contents) = simplifile.read(from: "input.txt")
  let rows = string.split(contents, on: "\n")
  let cells =
    rows
    |> list.index_map(fn(row, y) {
      row
      |> string.to_graphemes()
      |> list.index_map(fn(col, x) { #(Position(x, y), col) })
    })
    |> list.flatten()
    |> dict.from_list()
  Layout(cells, list.length(rows))
}

fn initial_state(position: Position, direction: Direction) -> State {
  let initial_beam = Beam(position, direction)
  State(beams: queue.from_list([initial_beam]), visited: set.new())
}

pub fn main() {
  let layout = parse()
  let part_a =
    simulate(initial_state(Position(0, 0), Right), layout)
    |> num_energized_tiles()

  let assert Ok(part_b) =
    list.range(from: 0, to: layout.dimension - 1)
    |> list.flat_map(fn(n) {
      [
        initial_state(Position(n, 0), Down),
        initial_state(Position(0, n), Right),
        initial_state(Position(layout.dimension - 1, n), Left),
        initial_state(Position(n, layout.dimension - 1), Up),
      ]
    })
    |> list.map(fn(state) {
      task.async(fn() {
        simulate(state, layout)
        |> num_energized_tiles()
      })
    })
    |> list.map(task.await_forever)
    |> list.reduce(int.max)

  io.println("part a: " <> int.to_string(part_a))
  io.println("part b: " <> int.to_string(part_b))
}
