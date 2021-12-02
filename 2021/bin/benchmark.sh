#!/usr/bin/env bash

# Find
day_files=$(find src -maxdepth 1 -name 'day*.nim')

# Compile
echo $day_files | xargs -n1 nim c -d:danger

# Benchmark
hyperfine ${day_files//.nim/} --export-markdown "$(dirname "$0")/benchmark.md"
