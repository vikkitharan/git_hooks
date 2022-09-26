#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: fix_multiple_whitespaces.sh
#               Remove multiple whitespaces within the text
#   Created by: vikki
#   Created on: 2022/09/27
#  Modified by: vikki
#  Modified on: 2022/09/27
#      Version: 0.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# TODO 1. Identify line numbers which are
#         (a) added or modified in staged and
#         (b) have multiple non leading whitespaces
#      loop over git diff --cached -U output
#         if line is added or modified
#           if the line has multiple non leading whitespaces
#             call map()
# TODO 2. Map the line numbers from staged to local files.
#         (a) Generate mapper data structure using git diff -U
#         (b) map using line input and the data structure
# TODO 3. Replace non leading multiple white space by a single space
