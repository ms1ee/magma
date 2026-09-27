#!/bin/bash
set -e

apt-get update && \
    apt-get install -y make build-essential git wget \
        clang-4.0 llvm-4.0 llvm-4.0-dev binutils-gold \
        python python-pip python3 python3-pip

pip  install --no-cache-dir networkx pydotplus pydot
pip3 install --no-cache-dir networkx pydotplus pydot

ln -sf /usr/lib/llvm-4.0/lib/LLVMgold.so /usr/lib/bfd-plugins/LLVMgold.so

update-alternatives \
  --install /usr/bin/clang      clang      /usr/bin/clang-4.0      20 \
  --slave   /usr/bin/clang++    clang++    /usr/bin/clang++-4.0 \
  --slave   /usr/bin/clang-cpp  clang-cpp  /usr/bin/clang-cpp-4.0

update-alternatives \
  --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-4.0 20 \
  --slave   /usr/bin/opt         opt         /usr/bin/opt-4.0 \
  --slave   /usr/bin/llvm-link   llvm-link   /usr/bin/llvm-link-4.0 \
  --slave   /usr/bin/llvm-dis    llvm-dis    /usr/bin/llvm-dis-4.0 \
  --slave   /usr/bin/llvm-ar     llvm-ar     /usr/bin/llvm-ar-4.0 \
  --slave   /usr/bin/llvm-nm     llvm-nm     /usr/bin/llvm-nm-4.0
