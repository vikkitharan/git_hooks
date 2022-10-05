#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#     	File: fix_multiple_whitespaces.sh
#             (1) Substitute two or more spaces or tab between words by single space or tab
#             (2) Remove leading space(s) followed by tab(s)
#             need to support
#             (1) update files after staged by map_cached_to_local()
#             (2) include other file types in find_cached_files_lines()
#   Created by: vikki
#   Created on: 2022/09/27
#  Modified by: vikki
#  Modified on: 2022/10/06
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
#  (1) No action for trailing whitespaces
#  (2) Do not remove leading multiple spaces, tabs or tabs followed by spaces
#  (3) Substitute two or more spaces or tab between words by single space or tab
#  (4) Remove leading space(s) followed by tab(s)
###########################################
fix_white_space() {
  for file_line in $(echo "$files_lines" | tr " " "\n");
  do
    file=$(echo "$file_line" | cut -d "," -f1)
    line_number_cached=$(echo "$file_line" | cut -d "," -f2)
    line_number_local=$(map_cached_to_local "$line_number_cached")

    # substitute two or more spaces or tab between words by single space or tab
    sed -i "${line_number_local}s/\>\([[:blank:]]\)\{2,\}/\1/g" "$file"

    # remove leading space(s) followed by tab(s)
    sed -i "${line_number_local}s/^ \{1,\}\(\t\{1,\}\)/\1/g" "$file"
  done
}

files_lines=$(find_cached_files_lines)

echo $files_lines

fix_white_space
