#!/usr/bin/env bash

# Find
files=$(find src -maxdepth 1 -name '*.nim' -not -name 'helpers.nim' | sort)

# Compile
echo $files | xargs -n1 nim c -d:danger

# Benchmark
hyperfine ${files//.nim/} --export-markdown "$(dirname "$0")/benchmark.md"
