#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/update_ctags.sh
#               List files and create tags
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikki
#  Modified on: 2022/09/28
#      Version: 1.3.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set -e
CURRENT_DIR=$(pwd)
GIT_DIR=$(git rev-parse --git-dir)

cd "${GIT_DIR}"
cd ..

# List all c and c++ files (git tracked)
c_files=$(git ls-files | grep "\(\.h$\|\.cpp$\|\.c$\)")

if [ ! -z "$c_files" ]
then
  echo "$c_files" | tr " " "\n" > files_c.txt
  ctags -n -L files_c.txt -f tags_c
fi

cd "${CURRENT_DIR}"
