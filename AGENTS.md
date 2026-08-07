# 代码仓库指南

## 项目概览

本仓库是一个为 **Windows 11 + 小狼毫** 定制的 **Rime 输入法配置**，核心是 **虎码（Tiger code）**。主要包含：

- **tiger** — 单字虎码方案
- **tigress** — 词组虎码方案
- **PY_c** — 带滤镜的拼音++方案
- **easy_english** — 临时英文输入子方案
- 共享 Lua 处理器/翻译器：时间日期、计算器、Unicode 提示、数字转换、符号查找

这 **不是传统软件项目**；没有 package.json、Makefile 或 CI。仓库本质是 **数据/配置 + Lua 脚本**，由 Rime 引擎消费。

---

## 架构与数据流

**高层结构：**

```
用户输入
  → Rime 引擎处理器（ascii_composer, recognizer, key_binder, speller, punctuator, selector, navigator）
  → 翻译器/分段器（punct, reverse_lookup, table, history, lua_translator）
  → 滤镜（core2022, simplifier, pinyin, emoji, chaifen, unicode_display, uniquifier）
  → 候选词输出
```

**关键模块：**

- **方案定义**（`tiger.schema.yaml`, `tigress.schema.yaml`, `PY_c.schema.yaml`, `easy_english.schema.yaml`）— 定义输入行为、处理器、翻译器、滤镜和按键绑定
- **Lua 层**（`lua/*.lua`，由 `rime.lua` 加载）— 为候选词增加时间/日期、计算器、Unicode 提示、数字转换等能力
- **词典**（`*.dict.yaml`）— 编译为 `build/` 下的 `.table.bin` 产物
- **OpenCC 词表**（`opencc/*.json`, `opencc/*.txt`）— 驱动简繁/拼音/表情/拆分滤镜

**数据流说明：**

- `rime.lua` 全局加载所有 Lua 模块
- 每个方案的 `custom.yaml` 通过 patch 修改行为，无需复制完整方案
- `build/` 包含 **编译产物**，供 Rime 运行时消费；这些文件是生成的，不应手改
- `userdb/` 存储用户运行数据，已被 gitignore

---

## 关键目录

| 路径 | 用途 |
|------|------|
| `lua/` | Lua 处理器、滤镜、翻译器 |
| `opencc/` | OpenCC 转换表和文本列表 |
| `build/` | 编译后的方案/词典产物（`.bin`, `.yaml`） |
| `userdb/` | 用户词典运行数据（已 gitignore） |
| 根目录 `*.yaml` | 方案定义、自定义补丁、符号表、配置文件 |

---

## 开发命令

**没有构建/测试/Lint 流程。** 验证方式是通过 Rime UI 重新部署：

1. 修改方案/自定义/Lua 文件
2. **小狼毫托盘菜单 → 重新部署**
3. 在输入法中验证行为

**手动验证示例：**

- 在 tiger 方案中测试 `/date`, `/time`, `/week` 命令
- 使用 `` ` `` 前缀测试拼音反查
- 使用 `=` 前缀测试计算器
- 使用 Ctrl+Y 开关测试 Unicode 显示

**可选：查看编译后的方案**

```bash
# 查看 build/ 中编译后的 tiger 方案
cat build/tiger.schema.yaml
```

---

## 代码约定与常见模式

**YAML 方案：**

- 使用 `patch:` 块覆盖默认配置，避免完整复制方案
- 方案 ID：`tiger`, `tigress`, `PY_c`, `easy_english`, `core2022`
- 自定义补丁放在 `*.custom.yaml` 文件中

**Lua 模块：**

- 在 `rime.lua` 中作为全局变量加载：`shijian2_translator = require("shijian2")`
- 返回单个 `translator(input, seg)` 函数
- 使用 `yield(Candidate(...))` 输出候选词
- 通过 `os.date(...)` 获取时间，通过 `string.gsub` 处理字符串

**按键绑定约定：**

- Ctrl+键在 `composing` 状态下切换滤镜
- `when: has_menu` 用于候选词导航键
- `when: always` 用于全局开关

**识别器模式：**

- `punct: "^/([0-9]0?|[A-Za-z]+)$"` — 斜杠命令
- `reverse_lookup: "^`[a-z]*'?$"` — 拼音反查
- `expression: "^=.*$"` — 计算器

---

## 重要文件

| 文件 | 角色 |
|------|------|
| `rime.lua` | 全局 Lua 引导；注册所有处理器/滤镜/翻译器 |
| `tiger.schema.yaml` | 单字虎码方案定义 |
| `tigress.schema.yaml` | 词组虎码方案定义 |
| `tiger.custom.yaml` | Tiger 用户补丁（外观、补全、标签） |
| `tigress.custom.yaml` | Tigress 用户补丁 |
| `default.custom.yaml` | 全局 Rime UI 自定义 |
| `weasel.custom.yaml` | 小狼毫分发元数据和按键绑定 |
| `symbols.yaml` | 共享符号表，用于 `/` 快捷键 |
| `lua/shijian2.lua` | 时间/日期翻译器，支持农历/节气 |
| `lua/calculator_translator.lua` | 表达式求值器（`=` 前缀） |
| `lua/core2022_filter.lua` | 常用/全集字集过滤 |
| `installation.yaml` | 小狼毫安装元数据 |

---

## 运行时/工具偏好

- **运行时：** Rime 1.13.1 + 小狼毫 0.17.4，Windows 11
- **方案格式：** YAML
- **脚本语言：** Lua 5.1（Rime 内置）
- **字符转换：** OpenCC JSON/TXT 词表
- **无 Node.js/Bun/Python 运行时** — 这是纯配置仓库

---

## 测试与质量保证

- **无自动化测试、CI 或覆盖率工具**
- 验证完全依赖 **小狼毫的手动重新部署流程**
- 添加新功能时：
  1. 修改方案/Lua
  2. 通过小狼毫重新部署
  3. 直接测试输入模式
  4. 检查候选词输出是否正确

---

## 平台说明

- 主要目标：**Windows 11 + 小狼毫 (Weasel)**
- 方案可移植到其他 Rime 平台（macOS Squirrel, Linux ibus-rime），但 `weasel.custom.yaml` 和 `installation.yaml` 是 Windows 专属
- Gitignore 列表：`build/`, `userdb/`, `sync/`, `test/`, `installation.yaml`, `user.yaml`
