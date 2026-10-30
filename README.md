# 药师输入法 · Yaoshime

> 一款基于 **中州韵输入法引擎（Rime）** 的 Windows 中文输入法。

药师输入法（项目代号 `yaoshime`）是 [Rime 输入法引擎](https://rime.im/) 在 Windows 平台上的**社区衍生发行版**，
由 [rime/weasel](https://github.com/rime/weasel)（小狼毫）分支而来，在保留原有引擎能力的基础上，
完成了品牌重塑、安装体系解耦与工程化整理。

> **本项目不是 Rime 官方项目。** 上游版权归 RIME Developers 所有，详见 [许可证与来源](#许可证与来源) 一节。

---

## 目录

- [项目定位](#项目定位)
- [与上游项目的关系](#与上游项目的关系)
- [来源说明](#来源说明)
- [功能特性](#功能特性)
- [系统要求](#系统要求)
- [安装](#安装)
- [从源码构建](#从源码构建)
- [目录结构](#目录结构)
- [本项目的改动](#本项目的改动)
- [许可证与来源](#许可证与来源)
- [致谢](#致谢)

---

## 项目定位

药师输入法面向 Windows 8.1 及以上系统，提供：

- 完整的**拼音、注音、仓颉、五笔、粤拼**等多种输入方案支持（方案随 Rime 生态提供）
- 基于 TSF（Text Services Framework）的现代输入法框架，同时兼容 32 位与 64 位程序
- 高度可定制的界面风格、候选词数量、快捷键与词库
- 跨版本词库同步与用户词典管理

本项目在功能上与上游保持一致，**不修改输入法引擎核心逻辑**，改动仅涉及品牌标识、
安装路径隔离与工程配置，详见 [本项目的改动](#本项目的改动)。

---

## 与上游项目的关系

Rime 输入法在 Windows 平台的实现叫 **Weasel（小狼毫）**，由 `rime/weasel` 仓库维护。

```
rime/librime          输入法引擎核心（跨平台 C++ 库）
        │
        ├── rime/weasel       Windows 平台实现 —— 小狼毫
        │        │
        │        └── wxbgit/weasel    上游分支（fork）
        │                 │
        │                 └── 【 本项目 】药师输入法 / yaoshime
        │
        └── rime/plum         配置与词库管理工具（构建期依赖）
```

三者的职责划分：

| 仓库 | 职责 | 本项目中的形态 |
|---|---|---|
| [rime/librime](https://github.com/rime/librime) | 输入法引擎核心，提供 `rime.dll` 与 C API | 位于 `librime/` 目录，随仓库分发 |
| [rime/weasel](https://github.com/rime/weasel) | Windows TSF 输入法外壳、服务端、部署器、安装程序 | 本项目的直接上游 |
| [rime/plum](https://github.com/rime/plum) | 词库方案安装脚本 | 位于 `plum/` 目录，随仓库分发 |

---

## 来源说明

本项目的代码基线、版本号与来源信息如下，可逐项核验：

| 项目 | 内容 |
|---|---|
| 上游原始项目 | [rime/weasel](https://github.com/rime/weasel) |
| 直接分支来源 | [wxbgit/weasel](https://github.com/wxbgit/weasel)（`master` 分支） |
| 基线提交 | `82b50c9e9b9ee0bd31357db6f25ddc804546c7f7` |
| 基线提交说明 | `Guard optional preedit cursor field` |
| 基线提交时间 | 2026-10-08 |
| 对应版本号 | `0.17.4` |
| 引擎版本 | librime `1.17.0` |
| 构建产物版本 | `1.0.0` |
| 本项目版本 | **`1.0`** |

> 上述提交可通过以下命令核验：
>
> ```bash
> git clone https://github.com/wxbgit/weasel.git
> cd weasel
> git log -1 --format="%H %s"
> ```

### 本项目对上游的继承

- **代码主体**：直接继承 `wxbgit/weasel` 的 `master` 分支代码，未删减任何功能模块。
- **引擎依赖**：`librime` 与 `plum` 按其原始版本随仓库一并分发，未做修改。
- **版本演进**：版本号体系（`主.次.修订.构建`）沿用上游约定。

### 本项目相对上游的差异

所有改动均为品牌与工程层面的调整，**不涉及输入法算法与引擎逻辑**：

1. **品牌重塑**：界面文案、版本资源、语言栏描述由「小狼毫」改为「药师输入法」。
2. **安装隔离**：注册表键由 `Software\Rime\Weasel` 改为 `Software\Yaoshime\Input`，
   安装目录由 `Program Files\Rime` 改为 `Program Files\Yaoshime`，
   用户数据目录由 `%APPDATA%\Rime` 改为 `%APPDATA%\Yaoshime`。
   这样可与原版小狼毫**并行安装、互不干扰**。
3. **工程整理**：解决方案文件更名为 `yaoshime.sln`，构建脚本同步更新。
4. **文档**：重写本 README，补充来源与许可证说明。

> **说明**：为保持二进制兼容与稳定，可执行文件名（`WeaselServer.exe`、`WeaselDeployer.exe`、
> `WeaselSetup.exe`）与 TSF 组件文件名（`weasel.dll`、`weaselx64.dll`）**保持上游命名不变**。
> 这些文件名参与系统注册与程序间调用，改动需同步重新编译并重新注册组件。

---

## 功能特性

- **多方案支持**：拼音（全拼/双拼）、注音、仓颉、五笔、粤拼、地球拼音等
- **智能组句**：基于语言模型的整句输入与动态调频
- **可视化定制**：候选窗样式、字号、配色、圆角、阴影等可通过图形界面调整
- **用户词典**：自动学习用户用词习惯，支持导入导出
- **跨设备同步**：词库与配置可通过同步目录在多台机器间共享
- **简繁转换**：基于 OpenCC 的简繁、港台异体字转换
- **32/64 位兼容**：同时向原生 32 位与 64 位应用提供输入能力

---

## 系统要求

| 项目 | 要求 |
|---|---|
| 操作系统 | Windows 8.1 / Windows 10 / Windows 11 |
| 架构 | x86（32 位）、x64（64 位） |
| 磁盘空间 | 约 60 MB（含词库与用户数据） |
| 权限 | 安装与卸载需要管理员权限 |

> ARM64 平台暂未提供预编译包，如需使用请自行编译。

---

## 安装

1. 运行安装程序 `yaoshime-<版本>-installer.exe`。
2. 按向导选择安装目录与要注册的输入语言（简体中文 / 繁体中文等）。
3. 安装完成后，在系统「设置 → 时间和语言 → 语言」中添加「药师输入法」。
4. 使用 `Ctrl + 空格` 或 `Win + 空格` 切换输入法。

卸载：从「设置 → 应用」中找到「药师输入法」卸载，或运行安装目录下的 `uninstall.exe`。

---

## 从源码构建

### 环境准备

| 工具 | 版本要求 | 说明 |
|---|---|---|
| Visual Studio | 2019 / 2022，需勾选「使用 C++ 的桌面开发」、ATL、MFC | 提供 MSVC 工具链 |
| Windows SDK | 10.0.19041 或更高 | |
| Boost | 1.78 及以上 | 仅需头文件；需设置 `BOOST_ROOT` |
| CMake | 3.12 及以上 | 构建 librime 时需要 |
| NSIS | 3.x | 仅生成安装包时需要 |

### 构建步骤

```bat
:: 1. 设置环境变量（复制模板后修改 BOOST_ROOT）
copy env.bat.template env.bat

:: 2. 构建全部组件与安装包
build.bat all

:: 3. 产物位置
::    output\archives\yaoshime-<版本>-installer.exe
```

若已自备预编译的 librime 二进制，可将 `rime.dll` / `rime.lib` 分别放入
`output\` 与 `lib\` 目录，然后跳过 `all`：

```bat
build.bat boost data opencc
build.bat weasel
```

详细说明参见 [INSTALL.md](INSTALL.md)。

---

## 目录结构

```
yaoshime/
├── RimeWithWeasel/     引擎与输入法框架的桥接层
├── WeaselIPC/          进程间通信协议
├── WeaselIPCServer/    IPC 服务端
├── WeaselServer/       后台服务（系统托盘、会话管理）
├── WeaselTSF/          TSF 输入法组件（weasel.dll / weaselx64.dll）
├── WeaselUI/           候选窗口与界面渲染
├── WeaselDeployer/     部署器（词库编译、设置界面）
├── WeaselSetup/        安装选项配置工具
├── include/            公共头文件
├── resource/           图标与界面资源
├── output/             构建产物、数据文件、安装脚本
├── librime/            输入法引擎（上游 rime/librime）
├── plum/               词库安装工具（上游 rime/plum）
├── test/               单元测试
├── yaoshime.sln        Visual Studio 解决方案
├── build.bat           构建脚本
└── LICENSE.txt         GPLv3 许可证全文
```

---

## 本项目的改动

本项目相对上游 `wxbgit/weasel@82b50c9` 的完整差异可通过以下方式查看：

```bash
git diff 82b50c9e9b9ee0bd31357db6f25ddc804546c7f7 --stat
```

改动文件清单（均为品牌与路径层面）：

| 文件 | 改动内容 |
|---|---|
| `include/WeaselConstants.h` | 新增显示名宏，注册表键改为 `Software\Yaoshime\Input` |
| `include/WeaselUtility.h` | 注册表键路径 |
| `RimeWithWeasel/WeaselUtility.cpp` | 注册表键路径 |
| `WeaselSetup/WeaselSetup.cpp` | 注册表键、默认用户目录 `%APPDATA%\Yaoshime` |
| `WeaselSetup/imesetup.cpp` | 注册表键路径 |
| `WeaselServer/WeaselServerApp.{h,cpp}` | 注册表键、更新检查路径 |
| `WeaselTSF/WeaselTSF.cpp`、`LanguageBar.cpp`、`Globals.h` | 注册表键、语言栏显示名 |
| `WeaselDeployer/SwitcherSettingsDialog.cpp`、`Configurator.cpp` | 注册表键 |
| `WeaselDeployer/*.rc`、`WeaselServer/*.rc`、`WeaselSetup/*.rc`、`WeaselTSF/*.rc` | 界面文案、版本资源 |
| `output/install.nsi` | 安装包名称、显示名、安装目录、卸载项、启动项 |
| `output/data/weasel.yaml` | 配置注释 |
| `build.bat` | 解决方案文件名引用 |
| `weasel.sln` → `yaoshime.sln` | 解决方案重命名 |
| `README.md` | 重写 |

---

## 许可证与来源

### 本项目遵守 GPLv3

本项目作为 [rime/weasel](https://github.com/rime/weasel) 的衍生作品，**依据上游许可证要求，
整体以 [GNU General Public License v3.0](LICENSE.txt) 发布**。

这意味着您可以自由地使用、修改、分发本项目，但**必须遵守 GPLv3 的传染性条款**：

- 分发本项目的修改版本时，**必须同样以 GPLv3 开源**，并提供完整源代码；
- 必须保留原始版权声明与许可证文本；
- 必须标明所做的修改；
- 不得附加额外限制条款。

> **注意**：本项目**不采用 MIT 许可证**。上游 Weasel 的主体代码为 GPLv3，
> 将衍生作品改标为 MIT 属于违反上游许可证的行为。

### 各组件的许可证

本项目内含多个来源不同的组件，各自遵循其原始许可证：

| 组件 | 许可证 | 版权 |
|---|---|---|
| 本项目（Weasel 衍生部分） | **GPLv3** | 基于 RIME Developers 的代码 |
| [librime](https://github.com/rime/librime) | **BSD 3-Clause** | Copyright (c) 2014, RIME Developers |
| [plum](https://github.com/rime/plum) | **LGPLv3** | RIME Developers |
| Boost | Boost Software License 1.0 | Boost 社区 |
| yaml-cpp | MIT | Jesse Beder 等 |
| leveldb | BSD 3-Clause | Google Inc. |
| marisa-trie | BSD 2-Clause / LGPL | Susumu Yata |
| OpenCC | Apache License 2.0 | BYVoid 等 |
| glog | BSD 3-Clause | Google Inc. |
| WinSparkle | MIT | Václav Slavík |
| 7-Zip | LGPL / unRAR 限制 | Igor Pavlov |
| curl | MIT-like (curl license) | Daniel Stenberg 等 |

各许可证全文可于对应组件目录或官方网站查阅。

### 版权声明

- **原始代码版权**：Copyright (c) RIME Developers —— 参见各源文件头部的版权声明。
- **本衍生项目**：品牌名称「药师输入法 / Yaoshime」及本项目所做的修改，
  由本项目维护者负责，同样以 GPLv3 授权。

「Rime」「中州韵」「小狼毫」「Weasel」等名称属于其各自权利人，本项目使用这些名称
仅用于**说明代码来源与技术依赖**，不代表任何官方认可或关联。

---

## 致谢

本项目完全建立在以下开源项目的工作之上，谨致谢意：

- **[RIME / 中州韵输入法引擎](https://rime.im/)** —— 提供跨平台的输入法引擎与设计理念
- **[rime/weasel（小狼毫）](https://github.com/rime/weasel)** —— 本项目直接上游，Windows 平台实现
- **[rime/librime](https://github.com/rime/librime)** —— 输入法引擎核心
- **[rime/plum](https://github.com/rime/plum)** —— 词库与方案管理
- **RIME 社区** —— 词库、输入方案与长期维护
- **[佛振（lotem）](https://github.com/lotem)** 及所有 RIME Developers —— 项目创始与持续贡献

以及 Boost、yaml-cpp、leveldb、marisa-trie、OpenCC、WinSparkle 等所有依赖库的作者。

---

## 相关链接

- Rime 项目主页：<https://rime.im/>
- Rime 官方文档：<https://rime.im/docs/>
- 上游 Weasel 仓库：<https://github.com/rime/weasel>
- 引擎核心 librime：<https://github.com/rime/librime>
- 本项目 GitHub：<https://github.com/wxbgit/yaoshime>
- 本项目 Gitee：<https://gitee.com/wxb22/yaoshime>
