# Git Hooks for C/C++ Formatting Using `clang-format`

## Summary

- Ensures consistent C/C++ formatting across the repository
- Enforces formatting automatically during git commit
- Prevents formatting-related noise in code reviews
- Improves developer productivity and code readability


This document currently targets Ubuntu Linux.
Support for Windows will be added in the future.

## Reference
- [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html)
- [Clang-Format Style Options](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
- [Customizing Git - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)



## 1.a Ubuntu: Install `clang-format` tool

The `clang-format` **checks and enforces code formatting** for C/C++ files using.

```bash
sudo apt-get install clang-format
```

Verify the installation:

```bash
clang-format --version
```

## 1.b Windows: Install `clang-format` tool

Open **PowerShell** (or Windows Terminal) and run:

```bash
winget install -e --id LLVM.ClangFormat
```

### Verify `clang-format` is available in your Git terminal
```bash
clang-format --version
which clang-format
```

## 2. Create a `.clang-format` configuration file

If you do not already have a `clang-format` configuration file, generate one and save it in the **root of your Git repository**:

```bash
clang-format -style=llvm -dump-config > .clang-format
```

This command generates a configuration based on the **LLVM** style.
Other predefined styles include:
- Chromium
- GNU
- Google
- LLVM
- Microsoft
- Mozilla
- WebKit

You can customise the generated `.clang-format` file to match your project’s coding standards.

For more details, visit the [clang-format official documentation](https://clang.llvm.org/docs/ClangFormat.html).

## 3. Format a file by `clang-format` command

Create the following intentionally ill-formatted C file and save it as test_format.c:

```bash
#include<stdio.h>

// Programmers should focus on the logic rather than where to add brackets, whitespace, or break a long line. Distraction kills productivity and logical thinking. 
      //Let's make clang-format do this boring formatting task while we focus on interesting stuff.  

int   add(int a,int b){
return a+b;}

int main( ){
int x=10 ; // Should we have space before, after?
int yyyy             =20;//or both before and after '='?
 if(x<yyyy){
printf("sum=%d\n",add(x,yyyy));}
else{
printf("no sum\n");}
return 0;}
```

Run the following command:
```bash
clang-format -i -style=file test_format.c
```

This command format the entire file according to the `.clang-format`.



## 4. Automate code format by git hooks

Once Git hooks are installed:
- `git commit` command automatically checks and formats
- Only **modified C/C++ codes** are formatted
- If formatting violations are found:
  - The `git commit` command is **rejected**
  - Clear instructions are printed on how to apply the format or skip if necessary

## 4.1. Clone the git hooks repo

Clone the hooks repository to a local directory:

```bash
git clone git@github.com:vikkitharan/git_hooks.git /home/vikki/source/git_hooks
```


### 2 Apply the hooks to an existing repo or create a new git repo with the hooks

Run this command inside an existing Git repository,
or inside a directory where you want to create a new repository:
```bash
git init --template=/home/vikki/source/git_hooks/template
```

**Note**:
Running `git init` inside an existing repository will **not overwrite existing settings or history**. This step only installs the hooks and supporting scripts.

After this step, the following files should exist:
```bash
$ tree .git/hooks/
.git/hooks/
├── pre-commit
└── scripts
    ├── clang-format-diff.py
    └── format_clang.sh
```

Ensure a `.clang-format` file exists in the repository root (described previously)


### 3 Verify: Automation works

Stage the intentionally ill-formatted file and attempt a commit:

```bash
git add test_format.c
git commit -m "Verify git hooks"
```

If the hooks are working correctly, you should see output similar to:

```bash
ERROR: clang-format check failed

The following file(s) had formatting issues and were automatically fixed:
  - test_format.c

The corrected changes are NOT staged.

Next steps:
  1. Review the formatting changes:
       git difftool
  2. Stage the corrected file(s):
       git add -p test_format.c
  3. Re-run the commit:
       git commit

To bypass this check (if really necessary):
  git commit --no-verify
```

## 6. Troubleshooting: Hooks Not Installed
If the file is not formated or you do not see the message above, the git hook or scripts may not have been copied correctly.

For older git versions, `git init --template` may **not copy hooks and scripts correctly**. In that case, copy them manually


```bash
cp ~/tmp/git_hooks/templates/hooks/pre-commit .git/hooks/
cp -r ~/tmp/git_hooks/templates/hooks/scripts/ .git/hooks/
```

Ensure the hooks are executable:
```bash
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/scripts/*
```
