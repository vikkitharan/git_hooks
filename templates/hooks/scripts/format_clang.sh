#!/bin/bash

GIT_DIR=$(git rev-parse --git-dir)
CLANG_FORMAT_CONFIG_FILE=".clang-format"
CLANG_FORMAT_DIFF="$GIT_DIR/hooks/scripts/clang-format-diff.py"

# Check if clang-format is installed
if ! command -v clang-format >/dev/null 2>&1; then
    echo
    echo "ERROR: clang-format is not installed."
    echo
    echo "Install it (Ubuntu/Debian):"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install clang-format"
    echo
    exit 1
fi

# Check if .clang-format file exists
if [ ! -f "$CLANG_FORMAT_CONFIG_FILE" ]; then
    echo
    echo "ERROR: Missing .clang-format in the repository root."
    echo
    echo "Create one (example using LLVM style):"
    echo "  clang-format -style=llvm -dump-config > .clang-format"
    echo
    exit 1
fi

# Get staged files with relevant extensions (Added/Copied/Modified)
# Use '|| true' so grep not matching doesn't cause failure.
staged_files=$(git diff --name-only --cached --diff-filter=ACM | grep -E '\.(c|h|cpp|hpp)$' || true)

if [ -z "$staged_files" ]; then
    exit 0
fi


bad_formatted_files=()

for file in $staged_files; do
    # If clang-format-diff produces output, formatting is needed.
    if [[ $(git diff -U0 --no-color --cached "$file" | "$CLANG_FORMAT_DIFF" -style=file -p1) ]]; then
        bad_formatted_files+=("${file}")
        git diff -U0 --no-color --cached "${file}" | "$CLANG_FORMAT_DIFF" -style=file -p1 -i
    fi
done

if [ ${#bad_formatted_files[@]} -ne 0 ]; then
    echo
    echo "ERROR: clang-format check failed"
    echo
    echo "The following file(s) had formatting issues and were automatically fixed:"
    for f in "${bad_formatted_files[@]}"; do
        echo "  - $f"
    done
    echo
    echo "The corrected changes are NOT staged."
    echo
    echo "Next steps:"
    echo "  1. Review the formatting changes:"
    echo "       git difftool"
    echo "  2. Stage the corrected file(s):"
    for f in "${bad_formatted_files[@]}"; do
        echo "       git add -p $f"
    done
    echo "  3. Re-run the commit:"
    echo "       git commit"
    echo
    echo "To bypass this check (if really necessary):"
    echo "  git commit --no-verify"
    echo
    exit 1
fi

exit 0
