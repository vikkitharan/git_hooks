# Git Hooks for C/C++ Formatting Using `clang-format`

This repository provides Git hooks to automatically check and enforce code formatting for C and C++ files using `clang-format`.

## Prerequisites

1. **Install `clang-format`**
   Use the following command to install `clang-format` on your system:
   ```bash
   sudo apt-get install clang-format
   ```

2. **Create a `.clang-format` Configuration File**
   Generate a `clang-format` configuration file and save it in your Git repository directory:
   ```bash
   clang-format -style=llvm -dump-config > ./.clang-format
   ```
   The above command generates a configuration using the LLVM style. Other available styles include Google, Chromium, Mozilla, and WebKit. For more information, visit the [clang-format documentation](https://clang.llvm.org/docs/ClangFormat.html).

   Or you can update the Configurations as you wish.

## Adding Git Hooks

1. **Clone This Repository**
   Clone this repository to a directory, for example, `~/tmp/git_hooks`:
   ```bash
   git clone git@github.com:vikkitharan/git_hooks.git ~/tmp/git_hooks
   ```

2. **Apply the Hooks to Your Repository**
   Create or update your repository by running the following command:
   ```bash
   git init --template ~/tmp/git_hooks/template
   ```
   **Note**: Running `git init` in an existing repository will not overwrite existing settings. This step is to apply the newly added hooks and auxiliary files.

   **If hooks and auxiliary files are not updated**, remove the existing hooks and auxiliary files before rerunning the command:
   ```bash
   rm .git/hooks/pre-commit .git/hooks/scripts/*
   ```

   **For some version of git `git init` does not copy the hools and script. You may copy the scripts as in the following instruciton. I will check when time permits
   ```bash
   cp ~/tmp/git_hooks/templates/hooks/pre-commit .git/hooks/

   cp ~/tmp/git_hooks/templates/hooks/scripts/ .git/hooks/ -r
   ```

   **Note**: This step only adds hooks; it does not update Git tracking.

## Checking Formatting During `git commit`

Once the hooks are added, they will automatically check the formatting of any modified C/C++ files during the commit process. If there are any formatting violations, the commit will be rejected, and instructions will be provided to fix them.

**Note**: Only modified lines are checked and corrected (though some surrounding code might also be updated).

## Formatting a File Manually

If you need to format an existing file, use the following command:
```bash
clang-format -i -style=file <file-path>
```
This command applies the formatting rules defined in the `.clang-format` file to the entire file.
---

