import fs from "node:fs";
import { MinPriorityQueue } from "@datastructures-js/priority-queue";

enum Direction {
  North = 0,
  East = 1,
  South = 2,
  West = 3,
}

type Crucible = [x: number, y: number, direction: Direction];
type Move = [crucible: Crucible, heatLoss: number];

const mod = (num: number, divisor: number) =>
  ((num % divisor) + divisor) % divisor;
const left = (direction: Direction) => mod(direction - 1, 4);
const right = (direction: Direction) => mod(direction + 1, 4);
const hash = ([x, y, direction]: Crucible): number =>
  x * dimension * dimension + y * dimension + direction;

const deltas: [dx: number, dy: number][] = [
  [0, -1],
  [1, 0],
  [0, 1],
  [-1, 0],
];

const grid = fs
  .readFileSync("input.txt", "ascii")
  .split("\n")
  .map((line) => line.split("").map(Number));
const dimension = grid.length;

const possibleMoves = (
  minSteps: number,
  maxSteps: number,
  [x, y, direction]: Crucible
): Move[] => {
  const [dx, dy] = deltas[direction];
  const moves: Move[] = [];
  let heatLoss = 0;

  for (let steps = 1; steps <= maxSteps; steps++) {
    const moveX = x + steps * dx;
    const moveY = y + steps * dy;
    if (moveX < 0 || moveX >= dimension || moveY < 0 || moveY >= dimension)
      break;

    heatLoss += grid[moveY][moveX];

    if (steps < minSteps) continue;

    [left(direction), right(direction)].forEach((moveDirection) =>
      moves.push([[moveX, moveY, moveDirection], heatLoss])
    );
  }

  return moves;
};

const solve = (minSteps: number, maxSteps: number): number => {
  const startEast: Crucible = [0, 0, Direction.East];
  const startSouth: Crucible = [0, 0, Direction.South];

  const queue = new MinPriorityQueue<Crucible>(
    (crucible: Crucible) => crucible[0] + crucible[1]
  );
  queue.enqueue(startEast);
  queue.enqueue(startSouth);

  const processed = new Map<number, number>();
  processed.set(hash(startEast), 0);
  processed.set(hash(startSouth), 0);

  let current: Crucible | undefined;
  while ((current = queue.pop())) {
    const elemHeatLoss = processed.get(hash(current))!;

    for (const [next, heatLoss] of possibleMoves(minSteps, maxSteps, current)) {
      const nextHash = hash(next);
      const newHeatloss = elemHeatLoss + heatLoss;

      if (newHeatloss < (processed.get(nextHash) ?? Number.MAX_VALUE)) {
        processed.set(nextHash, newHeatloss);
        queue.enqueue(next);
      }
    }
  }

  return Math.min(
    ...[Direction.North, Direction.East, Direction.South, Direction.West].map(
      (direction) =>
        processed.get(hash([dimension - 1, dimension - 1, direction])) ??
        Number.MAX_VALUE
    )
  );
};

console.log("part A:", solve(1, 3));
console.log("part B:", solve(4, 10));
