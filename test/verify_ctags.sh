#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: test/verify_ctags.sh
#               Verify ./scripts/ctags.sh functionality
#   Created by: vikgna
#   Created on: 2021/01/19
#  Modified by: vikgna
#  Modified on: 2021/01/19
#      Version: 0.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# Test 1. post-commit
mkdir -p ./test/output/
git checkout -b Test1 &> /dev/null
rm files.txt tags
cp ./test/data/input/ctag_commit.c ./test/output/ctag_commit.c

git add ./test/output/ctag_commit.c

git commit -m "commit a file; now check files.txt and tags"
if [ -f files.txt ] && [ -f tags ]; then
  echo "TEST 1 PASSED: tags updated after commit"
else
  echo "TEST 1 FAILED: tags not updated after commit"
fi

git checkout - &> /dev/null

git branch -D Test1 &> /dev/null

rm -rf ./test/output/



# Test 2. post-checkout

rm files.txt tags
git checkout -b Test2 &> /dev/null

if [ -f files.txt ] && [ -f tags ]; then
  echo "TEST 2 PASSED: tags updated after checkout a branch"
else
  echo "TEST 2 FAILED: tags not updated after checkout a branch"
fi

git checkout - &> /dev/null

git branch -D Test2 &> /dev/null

#Test 3. post-merge
mkdir -p ./test/output/
git checkout -b Test3A &> /dev/null

cp ./test/data/input/ctag_commit.c ./test/output/ctag_merge1.c

git add ./test/output/ctag_merge1.c

git commit -m "commit a file"

git checkout - &> /dev/null

git checkout -b Test3B &> /dev/null
cp ./test/data/input/ctag_commit.c ./test/output/ctag_merge2.c

git add ./test/output/ctag_merge2.c

git commit -m "commit a file"
rm files.txt tags

git merge Test3A

if [ -f files.txt ] && [ -f tags ]; then
  echo "TEST 3 PASSED: tags updated after merge"
else
  echo "TEST 3 FAILED: tags not updated after merge"
fi

git checkout - &> /dev/null

git branch -D Test3A &> /dev/null
git branch -D Test3B &> /dev/null

rm -rf ./test/output/

#Test 4. post-rewrite
mkdir -p ./test/output/
git checkout -b Test4A &> /dev/null

cp ./test/data/input/ctag_commit.c ./test/output/ctag_rebase1.c

git add ./test/output/ctag_rebase1.c

git commit -m "commit a file"

git checkout - &> /dev/null

mkdir -p ./test/output/
git checkout -b Test4B &> /dev/null
cp ./test/data/input/ctag_commit.c ./test/output/ctag_rebase2.c

git add ./test/output/ctag_rebase2.c

git commit -m "commit a file"
rm files.txt tags

git rebase Test4A

if [ -f files.txt ] && [ -f tags ]; then
  echo "TEST 4 PASSED: tags updated after rebase"
else
  echo "TEST 4 FAILED: tags not updated after rebase"
fi

git checkout - &> /dev/null

git branch -D Test4A &> /dev/null
git branch -D Test4B &> /dev/null

rm -rf ./test/output/
