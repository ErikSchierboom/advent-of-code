#!/usr/bin/env bash

# Find
day_files=$(find . -maxdepth 1 -name 'day*.nim')

# Compile
echo $day_files | xargs -n1 nim c

# Benchmark
hyperfine --prepare 'sync; echo 3 | sudo tee /proc/sys/vm/drop_caches' ${day_files//.nim/} --export-markdown benchmark.md
