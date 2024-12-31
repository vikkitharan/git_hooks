#!/bin/bash

GIT_DIR=$(git rev-parse --git-dir)
CLANG_FORMAT_CONFIG_FILE=".clang-format"
CLANG_FORMAT_DIFF="$GIT_DIR/hooks/scripts/clang-format-diff.py"

# Check if clang-format is installed
if ! command -v clang-format &> /dev/null; then
    echo "Prerequisite is not met: clang-format is not installed."
    echo "Please install clang-format using the following command:"
    echo "  sudo apt-get install clang-format    # For Ubuntu/Debian"
    exit 1
fi

# Check if .clang-format file exists
if [ ! -f "$CLANG_FORMAT_CONFIG_FILE" ]; then
    echo "Prerequisite is not met: Missing .clang-format configuration file in the repository root."
    echo "Please create a .clang-format using the following command:"
    echo "clang-format -style=llvm -dump-config > ./.clang-format"
    exit 1
fi

# Get staged files with relevant extensions
staged_files=$(git diff --name-only --cached --diff-filter=ACM | grep -E '\.(c|h|cpp|hpp)$')

if [ -z "$staged_files" ]; then
    exit 0
fi


bad_formatted_files=()

for file in $staged_files; do
  # 1. git diff get changes in cached files
  # 2. clang-format-diff.py formats those changes
  # But changes are not staged automatically
  if [[ $(git diff -U0 --no-color --cached "$file" | "$CLANG_FORMAT_DIFF" -style=file -p1) ]]; then
  bad_formatted_files+=("${file}")
  git diff -U0 --no-color --cached $file | "$CLANG_FORMAT_DIFF" -style=file -p1 -i
  fi
done

if [ ${#bad_formatted_files[@]} -ne 0 ]; then
    echo "Warning: The following file(s) had formatting issues and were corrected:"
    printf '%s\n' "${bad_formatted_files[@]}"
    echo "The changes have been fixed but not staged. Please stage them manually using:"
    printf 'git add -p %s\n' "${bad_formatted_files[@]}"
    exit 1
fi

exit 0
