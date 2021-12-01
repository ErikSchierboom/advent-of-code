#!/usr/bin/env bash

find . -maxdepth 1 -name '*.nim' | xargs nimpretty
