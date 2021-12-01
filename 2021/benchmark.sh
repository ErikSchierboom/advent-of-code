#!/usr/bin/env bash

day_files=$(find . -maxdepth 1 -name 'day*.nim' | sort)

# Compile each day
for day_file in $day_files; do
    nim c $day_file
done

# Benchmark each day
for day_file in $day_files; do
    hyperfine ${day_file/.nim/}
done
