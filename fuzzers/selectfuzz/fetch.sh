#!/bin/bash
set -e

git clone --no-checkout https://github.com/cuhk-seclab/SelectFuzz.git "$FUZZER/repo"
git -C "$FUZZER/repo" checkout 1f1b5c53de6e85400c5317ac2c1984aea7d20f65

cp "$FUZZER/src/afl_driver.cpp" "$FUZZER/repo/afl_driver.cpp"
