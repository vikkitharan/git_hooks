#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/format_clang_c_cpp.sh
#               Format c and cpp staged files using file
#   Created by: vikgna
#   Created on: 2021/01/15
#  Modified by: vikgna
#  Modified on: 2021/01/15
#      Version: 0.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

staged_files=$(git diff --name-only --staged | grep -E '\.(c|h|cpp|hpp)$')

echo $staged_files

