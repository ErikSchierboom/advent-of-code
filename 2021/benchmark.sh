#!/usr/bin/env bash

# Find
day_files=$(find . -maxdepth 1 -name 'day*.nim')

# Compile
echo $day_files | xargs -n1 nim c

# Benchmark
hyperfine ${day_files//.nim/} --export-markdown benchmark.md
