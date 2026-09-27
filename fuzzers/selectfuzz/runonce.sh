#!/bin/bash -e

export TIMELIMIT=0.1s
export MEMLIMIT_MB=100

run_limited()
{
    ulimit -Sv $[MEMLIMIT_MB << 10];
    ${@:1}
    test $? -lt 128
}
export -f run_limited

args="${ARGS/@@/"'$1'"}"
if [ -z "$args" ]; then
    args="'$1'"
fi

timeout -s KILL --preserve-status $TIMELIMIT bash -c \
    "run_limited '$OUT/$PROGRAM' $args"
