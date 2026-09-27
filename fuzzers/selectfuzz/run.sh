#!/bin/bash

mkdir -p "$SHARED/findings"

export AFL_SKIP_CPUFREQ=1
export AFL_NO_AFFINITY=1
"$FUZZER/repo/afl-fuzz" -m 100M -z exp -c 45m \
    -i "$TARGET/corpus/$PROGRAM" -o "$SHARED/findings" \
    $FUZZARGS -- "$OUT/$PROGRAM" $ARGS 2>&1
