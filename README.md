Git hooks for automation

# Features

## 1. Format C/C++ files using clang-format
# 2. Update ctags

# Steps to install

1. Copy git_hooks_scripts/ directory in your git repo


2. Create the clang-format configuration file.
```
clang-format -style=llvm -dump-config > ./.clang-format
```

Above command creates llvm style. Other styles are Google, Chromium, Mozilla, WebKit.
For further details are available in clang-format [webpage](https://clang.llvm.org/docs/ClangFormat.html)


3. Install the hooks by bellow command
```
bash ./git_hooks_scripts/install_hooks.sh
```

4. Delete git_hooks_scripts directory
