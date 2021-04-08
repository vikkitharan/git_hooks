#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/format_clang_c_cpp.sh
#               Format C/C++ staged sections
#   Created by: vikgna
#   Created on: 2021/01/15
#  Modified by: vikgna
#  Modified on: 2021/04/08
#      Version: 1.2.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

GIT_DIR=$(git rev-parse --git-dir)

staged_files=$(git diff --name-only --staged | grep -E '\.(c|h|cpp|hpp)$')

CLANG_FORMAT_CONFIG_FILE=".clang-format"
if [ -n "$staged_files" ]; then
  if [ ! -f $CLANG_FORMAT_CONFIG_FILE ]; then
    printf "Error: missing clang-format configuration file.\n \
      You can create by bellow command.\n \
      clang-format -style=llvm -dump-config > %s\n" $CLANG_FORMAT_CONFIG_FILE

    exit 1
  fi

  echo "Formatting C/C++ files using clang-format ..."

  bad_format_files=()

  for file in $staged_files; do
    # 1. git diff get changes in cached files
    # 2. clang-format-diff.py formats those changes
    # But changes are not staged automatically
    if [[ $(git diff -U0 --no-color --cached $file | \
      $GIT_DIR/hooks/clang-format-diff.py -style=file -p1) ]]; then

      bad_format_files+=("${file}")
      git diff -U0 --no-color --cached $file | \
        $GIT_DIR/hooks/clang-format-diff.py -style=file -p1 -i
   fi
  done

  if [ -n "${bad_format_files}" ]; then
    printf "Error: bad format in \n %s.\n \
      They are formatted now.\n \
      Please stage them by git add -p, before commit.\n" \
      "${bad_format_files[@]}"

    exit 1
  fi

fi
