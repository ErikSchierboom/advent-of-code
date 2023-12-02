import initWabt from "wabt";
import { readFileSync } from "node:fs";

const wabt = await initWabt();
const wat = readFileSync("day02.wat", "utf8");
const { buffer } = wabt.parseWat("day02.wat", wat).toBinary({});

const module = await WebAssembly.compile(buffer);
const instance = await WebAssembly.instantiate(module, {});

const input = readFileSync("input.txt", "utf8");
const encodedInput = new TextEncoder().encode(input);

const memoryBuffer = new Uint8Array(instance.exports.mem.buffer);
memoryBuffer.set(encodedInput);

const [part_a, part_b] = instance.exports.solve(encodedInput.length);
console.log(`part a: ${part_a}`);
console.log(`part b: ${part_b}`);
