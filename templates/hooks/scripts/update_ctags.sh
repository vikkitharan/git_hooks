#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/update_ctags.sh
#               List files and create tags
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikki
#  Modified on: 2022/09/21
#      Version: 1.2.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set -e
CURRENT_DIR=$(pwd)
GIT_DIR=$(git rev-parse --git-dir)

cd "${GIT_DIR}"
cd ..

# List all c and c++ files (git tracked)
git ls-files | grep "\(\.h\|\.cpp\|\.c\)" > files_c.txt

ctags -n -L files_c.txt -f tags_c

cd "${CURRENT_DIR}"
