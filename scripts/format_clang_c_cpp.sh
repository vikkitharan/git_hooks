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

CLANG_FORMAT_CONFIG_FILE="scripts/.clang-format"
if [ -n "$staged_files" ]; then
  if [ ! -f $CLANG_FORMAT_CONFIG_FILE ]; then
    printf "Error: missing clang-format configuration file.\n \
      You can create by bellow command.\n \
      clang-format -style=llvm -dump-config > %s\n" $CLANG_FORMAT_CONFIG_FILE

    exit 1
  fi

  echo "Formating C/C++ files using clang-formater ..."

  if [ $? -ne 0 ]; then
    echo "Error: wrong format. The files are formated now. \
    Please add them by git add -p"

    exit 1
  fi
fi
