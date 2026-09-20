# Rime

我的 Rime 配置： 虎码。基于[官网](https://www.tiger-code.com/docs/introduction)的配置修改而来。
仅在windows11下使用，其他平台没用过，但应该也能用。
**本仓库以打单为主。**

安装方法：
1. 安装小狼毫（Rime在windows下的发行版）
2. 将此库克隆到`C:\Users\<用户名>\AppData\Roaming\`目录下（即`···\Roaming\Rime`的形式），重新部署下小狼毫就可以了。

## 维护指南

同步官方词库只需替换：
	- tiger.dict.yaml
	- tigress.dict.yaml
	- tigress_ci.dict.yaml

如果只用一个模式只更新对应文件。

## 自定义配置指南

`tiger`前缀的文件用于配置单字模式，`tigeress`前缀的文件用于配置字词模式。先确定自己使用哪种模式，再找对应的配置文件。

- `tiger.custom.yaml`文件主要修改“外观”方面的配置。
- `tiger.schema.yaml`文件主要修改“功能”方面的配置。

其他文件基本上不需要动。具体内容在对应文件中有注释说明。

## 如何加入自定义字词？

1. 建立码表文件，如本仓库中的`personal_word.dict.yaml`文件。**注意分隔符是tab，不是空格**
2. 在`*.extended.dict.yaml`文件中导入码表。
3. 如果启用了表情滤镜，想调整自定义词跟emoji出现顺序则要在`opencc/emoji.txt`文件中修改。
4. 重新部署Rime。

## 分号快符组合（仅 tiger / tigress）

在当前配置下，`;` 被加入 `speller.alphabet`，因此 `;` 与其他字母键组合可一键上屏标点或符号。该机制由 `tiger.schema.yaml:115`、`tigress.schema.yaml:116` 以及 `auto_select_pattern: ^;\w+` 共同驱动，实际码位定义在 `tiger.extended.dict.yaml` / `tigress.extended.dict.yaml` 的「标点符号 快符」区。

| 组合 | 输出 | 组合 | 输出 |
|------|------|------|------|
| `;q` | `："` | `;a` | `！` |
| `;w` | `？` | `;s` | `……` |
| `;e` | `（` | `;d` | `、` |
| `;r` | `）` | `;f` | `“` |
| `;t` | `→` | `;g` | `”` |
| `;y` | `·` | `;h` | `『` |
| `;u` | `~` | `;j` | `』` |
| `;i` | `——` | `;k` | `￥` |
| `;o` | `〖` | `;l` | `%` |
| `;p` | `〗` | `;;` | `：` / `；` |
| `;z` | `\|` | `;x` | `【` |
| `;c` | `】` | `;v` | `《` |
| `;b` | `》` | `;n` | `「` |
| — | — | `;m` | `」` |

### 各方案说明

- **tiger / tigress**：启用 `;` 快符，见上表。
- **PY_c**：`alphabet` 不含 `;`（`PY_c.schema.yaml:115`），不生效。
- **easy_english**：`alphabet` 同样不含 `;`，且 `;` 被设为 `delimiter`（`easy_english.schema.yaml:61`），不进入编码。
