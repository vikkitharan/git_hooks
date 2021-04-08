#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/update_ctags.sh
#               Create tag files
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikgna
#  Modified on: 2021/04/08
#      Version: 1.2.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set -e
GIT_DIR=$(git rev-parse --git-dir)

cd "${GIT_DIR}"
cd ../

git ls-files > files.txt
ctags -L files.txt
