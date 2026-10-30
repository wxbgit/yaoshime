# custom/ — 药师输入法 1.0 用户自定义配置

本目录收录 **1.0 版本随附的用户自定义文件**，来源为实际使用中手工修改过的两份目录，
原样留档，方便重装/迁移/回滚。

## custom/data/ —— 词库与方案（原位置：`<安装目录>\data\`）

| 文件 | 相对上游改动 |
|---|---|
| `luna_pinyin.schema.yaml` | 在 `translators` 中新增 `- lua_translator@*date_translator`，启用「日期/时间」快捷输入 |
| `luna_pinyin.dict.yaml` | 词库新增词条 `安瓿	an bu` |

部署方法：覆盖到安装目录的 `data\` 下，然后「重新部署」。

## custom/user/ —— 用户目录（原位置：`%APPDATA%\Yaoshime\`）

| 文件 | 说明 |
|---|---|
| `default.custom.yaml` | 方案清单等全局设定 |
| `weasel.custom.yaml` | 界面样式（字号、配色、候选词数等） |
| `luna_pinyin.custom.yaml` | 朙月拼音方案调整 |
| `luna_pinyin_fluency.custom.yaml` | 语句流方案调整 |
| `luna_pinyin_simp.custom.yaml` | 简体方案调整（含较大改动） |
| `luna_quanpin.custom.yaml` | 全拼方案调整 |
| `custom_phrase.txt` | 自定义短语 |
| `lua/date_translator.lua` | 日期翻译器脚本，配合 `luna_pinyin.schema.yaml` 里的 `lua_translator` 使用 |

**不含**：`build/`（编译缓存，重新部署自动重建）、`*.userdb/`（用户词频数据库，二进制、含个人输入记录）、
`sync/`（同步备份）。

部署方法：覆盖到 `%APPDATA%\Yaoshime\` 下，然后「重新部署」。

## 一键打包

根目录 `_make_bundle_installer.bat`：把 `output\` 产物 + `%APPDATA%\Yaoshime` 配置打成一个
单文件安装程序（含注册表修复）。详见该脚本内注释。
