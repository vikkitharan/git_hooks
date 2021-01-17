#!/bin/bash
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
#         File: test/verify_format_c.sh
#               Verify ./scripts/format_clang_c_cpp.sh functionality
#   Created by: vikgna
#   Created on: 2021/01/16
#  Modified by: vikgna
#  Modified on: 2021/01/17
#      Version: 1.0.0
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# Test 1: .clang-format availability and display proper message if it is unavailable
git checkout -b Test1 &> /dev/null
mkdir -p ./test/output/

clang-format -style=file ./test/data/input/bad_format.c > ./test/output/good.c
# remove trailing white space
sed -i 's/[ \t]*$//' ./test/output/good.c

mv .clang-format ./test

git add ./test/output/good.c
git commit -m "Test 1 failed: commit success without .clang-format" > /dev/null

mv ./test/.clang-format ./

git commit -m "Test 1 passed: commit success with .clang-format" > /dev/null

is_passed=$(git log --grep='Test 1 passed: commit success with .clang-format')
is_failed=$(git log --grep='Test 1 failed: commit success without .clang-format')

if [ -z "$is_failed" ] && [ ! -z "$is_passed" ] ; then
  echo "TEST 1 PASSED: .clang-format availability check"
else
  echo "TEST 1 FAILED: .clang-format availability check"
fi

git checkout - &> /dev/null

git branch -D Test1 &> /dev/null

rm -rf ./test/output/

# Test 2: format only C/C++ files
mkdir -p ./test/output/
git checkout -b Test2 &> /dev/null
cp ./test/data/input/dont_format_me.py ./test/output/format.py
git add ./test/output/format.py
git commit -m "Test 2: Adding a python file" &> ./test/output/message.txt

if grep -q "Error: bad format in" ./test/output/message.txt; then
  echo "TEST 2 FAILED: format only C/C++ files check"
else
  echo "TEST 2 PASSED: format only C/C++ files check"
fi

git checkout - &> /dev/null

git branch -D Test2 &> /dev/null

rm -rf ./test/output/

# Test 3: format only bad C/C++ files
git checkout -b Test3 &> /dev/null
mkdir -p ./test/output/

clang-format -style=file ./test/data/input/bad_format.c > ./test/output/good.c
# remove trailing white space
sed -i 's/[ \t]*$//' ./test/output/good.c

git add ./test/output/good.c
git commit -m "Test 3 passed: commit success with formated C/C++ file" &> /dev/null

cp ./test/data/input/bad_format.c  ./test/output/bad_format.c
git add ./test/output/bad_format.c
git commit -m "Test 3 failed: commit success with unformated C/C++ file" &> /dev/null

is_passed=$(git log --grep='Test 3 passed: commit success with formated C/C++ file')
is_failed=$(git log --grep='Test 3 failed: commit success with unformated C/C++ file')

git reset ./test/output/bad_format.c

if [ -z "$is_failed" ] && [ ! -z "$is_passed" ] ; then
  echo "TEST 3 PASSED: format only bad C/C++ files"
else
  echo "TEST 3 FAILED: format only bad C/C++ files"
fi

git checkout -

git branch -D Test3

rm -rf ./test/output/

# Test 4: format only staged changes
git checkout -b Test4 &> /dev/null
mkdir -p ./test/output/ ./test/ref/

clang-format -style=file ./test/data/input/bad_format.c > ./test/ref/partially_formated.c
# remove trailing white space
sed -i 's/[ \t]*$//' ./test/ref/partially_formated.c

cat ./test/data/input/bad_format.c >>  ./test/ref/partially_formated.c

cp ./test/data/input/bad_format.c  ./test/output/partially_formated.c

git add ./test/output/partially_formated.c

cat ./test/data/input/bad_format.c >>  ./test/output/partially_formated.c

git commit -m "Test 4 failed: commit success with unformated C/C++ file" &> /dev/null

git reset ./test/output/partially_formated.c

if cmp -s ./test/output/partially_formated.c ./test/ref/partially_formated.c; then
  echo "TEST 4 PASSED: format only staged changes"
else
  echo "TEST 4 FAILED: format only staged changes"
fi

git checkout -

git branch -D Test4

rm -rf ./test/output/ ./test/ref/

# Test 5: format correctly
git checkout -b Test5 &> /dev/null
mkdir -p ./test/output/ ./test/ref/

clang-format -style=file ./test/data/input/bad_format.c > ./test/ref/good.c
# remove trailing white space
sed -i 's/[ \t]*$//' ./test/ref/good.c

cp ./test/data/input/bad_format.c  ./test/output/good.c

git add ./test/output/good.c

git commit -m "Test 5 failed: commit success with unformated C/C++ file" &> /dev/null

git add ./test/output/good.c

git commit -m "Test 5 pass: commit success with formated C/C++ file" &> /dev/null

git reset ./test/output/good.c
git checkout ./test/output/good.c

if cmp -s ./test/output/good.c ./test/ref/good.c; then
  echo "TEST 5 PASSED: format correctly"
else
  echo "TEST 5 FAILED: format correctly"
fi

git checkout -

git branch -D Test5

rm -rf ./test/output/ ./test/ref/
