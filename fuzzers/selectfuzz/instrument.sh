#!/bin/bash
set -e

export CC="$FUZZER/repo/afl-clang-fast"
export CXX="$FUZZER/repo/afl-clang-fast++"
export AS="$FUZZER/repo/afl-as"
export LIBS="$LIBS -l:afl_driver.o -lstdc++"

TMP_DIR="$OUT/selectfuzz-temp"
mkdir -p "$TMP_DIR"

if [ -f "$TARGET/locus.patch" ]; then
    patch -p1 -d "$TARGET/repo" < "$TARGET/locus.patch"
fi

source "$TARGET/configrc"
DRIVER="${PROGRAMS[0]}"

grep -rn "MAGMA_LOG" "$TARGET/repo" --include=*.c --include=*.cc --include=*.cpp --include=*.h \
  | sed "s|^$TARGET/repo/||" | awk -F: '{print $1 ":" $2}' | sort -u > "$TMP_DIR/BBtargets.txt"
if [ $(wc -l < "$TMP_DIR/BBtargets.txt") -ne 1 ]; then
    echo "expected exactly one MAGMA_LOG site, found:"; cat "$TMP_DIR/BBtargets.txt"; exit 1
fi
cp "$TMP_DIR/BBtargets.txt" "$TMP_DIR/real.txt"
: > "$TMP_DIR/indirect.txt"
echo "SelectFuzz target: $(cat "$TMP_DIR/BBtargets.txt")  driver: $DRIVER"

"$MAGMA/build.sh"

SF_ANALYSIS="-targets=$TMP_DIR/BBtargets.txt -outdir=$TMP_DIR -flto -fuse-ld=gold -Wl,-plugin-opt=save-temps"
CFLAGS="$CFLAGS $SF_ANALYSIS" CXXFLAGS="$CXXFLAGS $SF_ANALYSIS" "$TARGET/build.sh"

cat "$TMP_DIR/BBnames.txt" | rev | cut -d: -f2- | rev | sort | uniq > "$TMP_DIR/BBnames2.txt"
mv "$TMP_DIR/BBnames2.txt" "$TMP_DIR/BBnames.txt"
sort -u "$TMP_DIR/BBcalls.txt" -o "$TMP_DIR/BBcalls.txt"

cd "$(dirname "$(find "$TARGET/repo" -name "$DRIVER.0.0.preopt.bc" | head -1)")"
"$FUZZER/repo/scripts/genDistance.sh" "$TARGET/repo" "$TMP_DIR"
grep -q . "$TMP_DIR/distance.cfg.txt" || { echo "distance.cfg.txt is empty"; exit 1; }
echo "distances: $(wc -l < "$TMP_DIR/distance.cfg.txt") lines"

CFLAGS="$CFLAGS -distance=$TMP_DIR/distance.cfg.txt" \
CXXFLAGS="$CXXFLAGS -distance=$TMP_DIR/distance.cfg.txt" "$TARGET/build.sh"
