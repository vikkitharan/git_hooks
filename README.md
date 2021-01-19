Git hooks for automation

# 1. Format C/C++ files using clang-format

## Steps to install
1. Create the clang-format configuration file.
```
clang-format -style=llvm -dump-config > ./.clang-format
```

Above command creates llvm style. Other styles are Google, Chromium, Mozilla, WebKit.
For further details are available in clang-format [webpage](https://clang.llvm.org/docs/ClangFormat.html)

2. Install the hooks by bellow command
```
bash ./install_hooks.sh
```


# 2. Update ctags

## Steps to install
1. Install the hooks by bellow command
```
bash ./install_hooks.sh
```
