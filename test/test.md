# Verify clang-format
1. .clang-format availability and display proper message if it is unavailable
2. format only C/C++ files
3. format only bad C/C++ files
4. format only staged changes
5. format correctly


# How:
1. Delete .clang-format and commit a C/C++ file
2. Commit dont_format_me.py and check no printing
3. Stage bad_format.c formated files
4. Stage part of .c file and commit
5. Commit bad_format files and compare with good_format files

# Inputs
bad_format.c
bad_format.h
dont_format_me.py


# Verify ctags
1. post-commit
   comit a c file and check tags
2. post-checkout
   checkout a branch and check ctags
3. post-merge
   merge a branch and check ctags
4. post-rewrite
   rebase a branch and check
