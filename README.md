# cmake std

## 项目简介
本仓库演示了一套基于 CMake 的多组件构建流程。根项目 `Example` 会按照依赖顺序配置并构建两个子仓库：

- `repo_2`：提供静态库 `mod_2`，对外暴露 `print_mod_2()`。
- `repo_1`：包含可执行程序 `mod_1`，依赖自身的静态库 `mod_1_1`、`mod_1_2` 以及上游的 `mod_2`。

通过自定义的 `config_comp()`、`devops_basic_setup()`、`devops_post_setup()` 等宏，可以在构建阶段决定组件是以源码形式参与编译还是直接引用预先安装的产物，从而模拟多团队/多仓库协同的场景。

## 目录结构
```
├── build.sh                 # 一键构建脚本
├── cmake/
│   └── utils.cmake          # 自定义宏与构建工具函数
├── CMakeLists.txt           # 顶层 CMake 配置
├── repo_1/
│   ├── CMakeLists.txt
│   └── mod_1/
│       ├── CMakeLists.txt
│       ├── export/          # 对外分发的头文件、源码
│       ├── mod_1_1/         # 静态库 + 示例 codegen 目标
│       └── mod_1_2/         # 静态库
└── repo_2/
    ├── CMakeLists.txt
    └── mod_2/               # 静态库及导出头
```

> `export/` 目录中的文件会在构建脚本执行时同步到安装目录，用于模拟产物下发。

## 构建方式
推荐直接执行 `build.sh`，脚本会完成以下步骤：

1. 扫描所有 `export/` 目录，将头文件与源码复制到 `build/<类型>/[repo]/include|src/`。
2. 调用 `cmake` 生成构建目录，默认使用：
   - 构建类型：`release`
   - C/C++ 编译器：`/depot/opensource/gcc/v10.3.0`
   - 安装路径：`build/release`
   - 自定义变量：
     - `COMP_LIST`：默认 `ALL`，可指定单个组件名称（如 `repo_1`）来只构建特定组件。
     - `UV_REF_BUILD`：引用型组件的安装位置，用于模拟外部依赖。
3. 执行 `cmake --build` 和 `cmake --install`，完成目标产物构建及安装。

```bash
./build.sh            # 构建所有组件
./build.sh repo_1     # 仅构建 repo_1，repo_2 以依赖形式引用
```

构建结束后，可执行文件与静态库会安装在 `build/release/[repo]/` 下：

- `bin/mod_1`：示例入口程序。
- `lib/libmod_*.a`：各模块静态库。
- `include/`、`src/`：从 `export/` 同步的头文件与源码。

## 组件关系
- `mod_1`（可执行文件）链接 `mod_1_1`、`mod_1_2` 以及 `mod_2`。
- `mod_1_1` 暴露 `print_mod_1_1()`，并定义示例 `mod_1_1_gen` 代码生成目标，用来展示 `CODEGEN` 依赖汇聚功能。
- `mod_1_2` 暴露 `print_mod_1_2()`。
- `mod_2` 暴露 `print_mod_2()`，供 `repo_1` 通过导出的头文件与静态库调用。

顶层脚本会把所有显式声明在 `EXPORT_LIB_LIST`、`EXPORT_BIN_LIST`、`CODEGEN_LIST` 中的目标分别安装/聚合，确保引用组件可以拿到正确的产物路径（通过 `DEPENDED_LIB_*`、`DEPENDED_BIN_*` 变量传递）。

## 开发小贴士
- 修改 CMake 宏时建议配合 `cmake --trace-expand` 等选项调试，便于观察宏展开细节。
- 如需接入新的组件或仓库，仿照 `repo_1` 结构添加子目录，并在顶层 `COMP_DEPS` 中声明即可。
- 若要模拟依赖已安装的外部库，可在构建时把目标组件从 `COMP_LIST` 中剔除，CMake 会调用 `export_deps()` 直接引用安装产物。

希望本工程能帮助你快速了解多组件 CMake 项目的组织方式与常见自定义宏写法。
