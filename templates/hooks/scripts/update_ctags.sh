#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/update_ctags.sh
#               List files and create tags
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikki
#  Modified on: 2023/07/25
#      Version: 1.4.1
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
CURRENT_DIR=$(pwd)
GIT_DIR=$(git rev-parse --git-dir)

cd "${GIT_DIR}"
cd ..

# List all c and c++ files (git tracked)
c_files=$(git ls-files | grep "\(\.h$\|\.cpp$\|\.c$\)")

if [ -n "$c_files" ]
then
  # Run background and sequencially below two commands
  { echo "$c_files" | tr " " "\n" > files_c.txt; \
    ctags -n -L files_c.txt -f tags_c; } &
fi

cd "${CURRENT_DIR}"
