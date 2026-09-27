#!/bin/bash

CRASH_DIR="$SHARED/findings/crashes"

if [ ! -d "$CRASH_DIR" ]; then
    exit 1
fi

find "$CRASH_DIR" -type f -name 'id:*'
