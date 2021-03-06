#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: scripts/install_hooks.sh
#               Add symbolic link
#   Created by: vikgna
#   Created on: 2021/01/15
#  Modified by: vikgna
#  Modified on: 2021/01/17
#      Version: 1.0.0
#   How to run: bash ./install_hooks.sh
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."

# Create symlink to pre-commit script
ln -s ../../pre-commit.sample $GIT_DIR/hooks/pre-commit
echo "Done!"
