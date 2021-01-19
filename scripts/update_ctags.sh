#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/update_ctags.sh
#               Create tag files
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikgna
#  Modified on: 2021/01/19
#      Version: 1.1.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set -e
git ls-files > files.txt
ctags -L files.txt
