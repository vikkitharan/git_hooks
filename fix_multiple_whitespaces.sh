#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#     	File: fix_multiple_whitespaces.sh
#           	Remove multiple whitespaces within the text
#   Created by: vikki
#   Created on: 2022/09/27
#  Modified by: vikki
#  Modified on: 2022/09/27
#  	Version: 1.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


#########################################
# find line numbers which are added or modified in staged below file types
# 1. tex
# 2. txt
#
#########################################

find_cached_files_lines () {
  git diff --cached -U \
  '***.tex' \
  '***.txt' \
  | gawk '
  match($0,"^+++ b/([[:alnum:]/._]+)", files){
  file=files[1]
}

match($0,"^@@ -([0-9]+),([0-9]+) [+]([0-9]+),([0-9]+) @@", chunk_header){
line=chunk_header[3]
}

{ line_conent=substr($0,2) }

/^(---|[^-+ ])/{next }
/^[-]/{ next }
/^[+][^+]/{ printf "%s,%s ",file, line++;next;}
{ line++ }
'
}


###########################################
# map the line number from cached to local
#     	(a) Generate mapper data structure using git diff -U
#     	(b) map using line input and the data structure
###########################################
map_cached_to_local() {
  printf "%s" "$1"
}


###########################################
# Replace non leading multiple white space by a single space
###########################################
fix_white_space() {
  for file_line in $(echo "$files_lines" | tr " " "\n");
  do
    file=$(echo "$file_line" | cut -d "," -f1)
    line_number_cached=$(echo "$file_line" | cut -d "," -f2)
    line_number_local=$(map_cached_to_local "$line_number_cached")
    sed -i "${line_number_local}s/ \{1,\}/ /g" "$file"
  done
}

files_lines=$(find_cached_files_lines)

fix_white_space
