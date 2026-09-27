#!/bin/bash
set -e

if [ ! -d "$FUZZER/repo" ]; then
    echo "fetch.sh must be executed first."
    exit 1
fi

cd "$FUZZER/repo"

sed -i "s|/selectfuzz/libDFUZZPASS.so|$FUZZER/repo/libDFUZZPASS.so|g" scripts/genDistance.sh
CC=clang make -j $(nproc)
CC=clang make -j $(nproc) -C llvm_mode || true
test -f llvm_mode/../afl-llvm-pass.so -a -f llvm_mode/../afl-llvm-rt.o

"./afl-clang-fast++" $CXXFLAGS -std=c++11 -c "afl_driver.cpp" -fPIC -o "$OUT/afl_driver.o"
