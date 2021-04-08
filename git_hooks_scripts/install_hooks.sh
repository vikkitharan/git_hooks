#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/install_hooks.sh
#               Add symbolic link
#   Created by: vikgna
#   Created on: 2021/01/15
#  Modified by: vikgna
#  Modified on: 2021/04/08
#      Version: 1.2.0
#   How to run: bash ./install_hooks.sh
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."

cp ./git_hooks_scripts/clang-format-diff.py $GIT_DIR/hooks/
cp ./git_hooks_scripts/format_clang_c_cpp.sh $GIT_DIR/hooks/
cp ./git_hooks_scripts/update_ctags.sh $GIT_DIR/hooks/

cp ./git_hooks_scripts/pre-commit $GIT_DIR/hooks/pre-commit

cp ./git_hooks_scripts/post-checkout $GIT_DIR/hooks/post-checkout
cp ./git_hooks_scripts/post-commit $GIT_DIR/hooks/post-commit
cp ./git_hooks_scripts/post-merge $GIT_DIR/hooks/post-merge
cp ./git_hooks_scripts/post-rewrite $GIT_DIR/hooks/post-rewrite
echo "Done!"
