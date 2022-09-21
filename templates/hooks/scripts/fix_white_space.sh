#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: fix_white_space.sh
#               Fix new trailing whitespaces and blank lines at end of file.
#   Created by: vikki
#   Created on: 2022/09/21
#  Modified by: vikki
#  Modified on: 2022/09/24
#      Version: 1.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

#test cases
# 1. Adding file s
#   a. no trailing whitespace or blank lines: no action
#   b. with a trailing whitespace: remove the traling whitespace
#   c. with a blank line at EOF: remove the balnk line EOF
#   d. with multiple traling whitespaces and multiple blank lines: remove the traling whitespalces and blank lines
#   e. with multiple traling whitespaces and multiple blank lines on multiple files: remove the traling whitespalces and blank lines
# 2. Editing an existing file
#   A. no new trailing whitespace or blank lines: no action
#   B. with a new trailing whitespace: remove the new traling whitespace
#   C. with a new blank line at EOF: remove the new balnk line EOF
#   D. with new multiple traling whitespaces and multiple blank lines: remove the traling new whitespalces and blank lines
#   E. with new multiple traling whitespaces and multiple blank lines on multiple files: remove new the traling whitespalces and blank lines


# Set the  internal field separator to split lines by new line character.
IFS=$'\n'

# get reference commit id, if it is new get empty tree object
if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	against=$(git hash-object -t tree /dev/null)
fi


# array of badly formated files
bad_files=()


for line in `git diff-index --check --cached $against -- | sed '/^[+-]/d'` ; do
  file=($(echo $line | sed -r 's/:[0-9]+: .*//'))
  bad_files+=("${file}")
  line_number=($(echo $line | sed -r 's/.*:([0-9]+).*/\1/'))

  last_non_blank=($(awk 'NF{c=FNR}END{print c}' "${file}"))

  if (( line_number > last_non_blank ))
  then
    echo -e "Removing blank line(s) at EOF: \033[31m$file\033[0m:$line_number"
    sed -i "${line_number},\$d" "$file"
  else
    echo -e "Removing trailing white space: \033[31m$file\033[0m:$line_number"
    sed -i "${line_number}s/[[:space:]]*$//" "$file"
  fi
done

# Remove duplicated files
formated_files=($(echo "${bad_files[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

if (( ${#bad_files[@]} != 0 )); then
  printf "\nWhitespace(s) is/are fixed: add the patch by \"git add -p %s\"\n" \
    "${formated_files[@]}"
  printf "To neglect whitespace error, run  \"git commit --no-verify\"\n"
      exit 1
fi

exit
