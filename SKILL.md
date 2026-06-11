---
name: load-my-notes
description: '加载 ~/notes/ 下的额外记忆文件（agent 自由写读，绕 hermes memory 2,200 字符上限）。Use when the user says: "加载我的笔记" / "load my notes" (全量加载), "搜索我的笔记：xxx" / "search notes for xxx" (关键字搜索), "加载笔记：<文件名>" / "load note <文件名>" (单文件加载), "加载包含 xxx 的笔记" / "load notes containing xxx" (按关键字部分加载), "列出我的笔记" / "list my notes" / "我有哪些笔记" (列清单), "查看笔记帮助" / "笔记怎么用" / "load-my-notes help" (列所有动作). Use as FALLBACK when user has ~/notes/ but NOT configured Obsidian vault (if Obsidian vault is set up, prefer the `obsidian` skill which has native wikilink/edit tools). 笔记根目录: ~/notes/ (chmod 700, git 不跟踪), 全是 markdown, agent 不自动写笔记 (避免污染), 用户自己用 nano 写.'
category: note-taking
---

# load-my-notes — 加载 ~/notes/ 额外记忆

**重要**：本 skill 触发后**不**立刻执行命令，先看用户在说什么动作，然后**用对应工具**做。

## 笔记根目录

```
~/notes/
├── README.md      # 系统说明
├── INDEX.md       # 索引（agent 先读这个）
└── *.md           # 用户笔记
```

## 6 个动作

### 动作 -1: 查看帮助

用户说：**"查看笔记帮助"** / **"笔记怎么用"** / **"load-my-notes help"** / **"列出所有动作"**

执行：直接输出下面的"动作清单"表（**不**调任何命令，纯文本回答）。

**动作清单**（用户说"查看笔记帮助"时输出）：

```
load-my-notes — 6 个动作

| #  | 动作           | 触发语                                                  | 行为                          |
|----|----------------|---------------------------------------------------------|-------------------------------|
| -1 | 查看帮助       | "查看笔记帮助" / "笔记怎么用"                           | 列本表（你正在看）            |
|  0 | 查看笔记列表   | "查看笔记列表" / "列出我的笔记" / "list my notes"       | 列文件清单 + INDEX 摘要       |
|  1 | 全量加载       | "加载我的笔记" / "load my notes"                        | 所有 .md 拼到 context         |
|  2 | 搜索关键字     | "搜索我的笔记：xxx"                                     | grep 命中文件 + 行            |
|  3 | 单文件加载     | "加载笔记：<文件名>"                                    | 只读那个文件                  |
|  4 | 按关键字加载   | "加载包含 xxx 的笔记"                                   | 只读含关键字的文件            |

写笔记: `nano ~/notes/<文件名>.md` 自己写，agent 不自动写。
笔记默认不加载进 context, 你说"加载"才进。
```

### 动作 0: 查看笔记列表

用户说：**"查看笔记列表"** / **"列出我的笔记"** / **"list my notes"** / **"我有哪些笔记"**

执行：
```bash
# 1. 列所有 .md 文件（带大小 + 修改时间 + 行数）
find ~/notes -name "*.md" -type f -printf "%TY-%Tm-%Td %TH:%TM  %5s  %p\n" | sort -k3
echo
# 2. 总大小
du -sh ~/notes
echo
# 3. INDEX.md 内容（agent 读这个最准）
echo "===== INDEX.md ====="
cat ~/notes/INDEX.md
```

输出后**不**自动加载任何笔记内容，只列清单 + INDEX 摘要。

如果用户接着说"加载第一个"或"加载包含 svn 的笔记"，**继续**走动作 2/3/4。

### 动作 1: 全量加载

用户说：**"加载我的笔记"** / **"load my notes"** / **"读 ~/notes"**

执行：
```bash
# 1. 拼所有 .md 到单一文件
out=/tmp/notes-snapshot.md
{
  echo "===== ~/notes 全量加载 ($(date +%Y-%m-%d)) ====="
  echo
  for f in $(find ~/notes -name "*.md" -type f | sort); do
    echo "===== FILE: $f ====="
    cat "$f"
    echo
  done
} > "$out"
wc -c "$out"
```

然后 `read_file` 读 `/tmp/notes-snapshot.md` 一次。文件 >50KB 时主动提示"笔记已 X KB，全量加载可能吃 context；要不要按需加载？"。

### 动作 2: 关键字搜索

用户说：**"搜索我的笔记：xxx"** / **"search notes for xxx"** / **"笔记里有没有 xxx"**

执行：
```bash
keyword='xxx'   # 用户的搜索词, 用 shell_quote 转义
# 1. grep 找文件 + 行
grep -rni --color=never -B 1 -A 3 "$keyword" ~/notes/ --include="*.md" 2>/dev/null
```

输出：每个匹配的文件:行号 + 上下文（前后 1 / 3 行）。

agent **不**自动加载内容，只列命中位置。**等用户说"加载这文件"或"加载包含 xxx 的笔记"才**真的读。

如果用户说"列出有哪些文件包含"，用 `grep -lri`：
```bash
grep -lri "$keyword" ~/notes/ --include="*.md" 2>/dev/null
```

### 动作 3: 单文件加载

用户说：**"加载笔记：2026-06-12-ccb-接入-详细.md"** / **"load note <filename>"** / **"打开 ~/notes/xxx"**

执行：
```bash
# 1. 找文件 (允许模糊匹配)
target="$HOME/notes/2026-06-12-ccb-接入-详细.md"
# 如果用户给的是模糊名, 用 find 找
find ~/notes -name "*模糊名*" -type f | head -3
# 2. 找到唯一文件后 read_file
```

如果用户给的文件名有多个匹配，先列出来让用户选。

### 动作 4: 按关键字部分加载

用户说：**"加载包含 xxx 的笔记"** / **"load notes containing xxx"** / **"把含 xxx 的笔记读进来"**

执行：
```bash
keyword='xxx'
out=/tmp/notes-partial.md
{
  echo "===== ~/notes 关键字加载: '$keyword' ($(date +%Y-%m-%d)) ====="
  echo
  # 1. 找含 keyword 的文件
  for f in $(grep -lri "$keyword" ~/notes/ --include="*.md" 2>/dev/null | sort); do
    echo "===== FILE: $f ====="
    cat "$f"
    echo
  done
} > "$out"
[ -s "$out" ] && wc -c "$out" && read_file "$out"
```

如果没找到任何文件，提示用户"没找到包含 '$keyword' 的笔记，要不要搜索其他关键字？"。

## 工具选择

- 搜索、查找文件: `terminal` 跑 grep / find
- 读内容: `read_file` 优先（不要用 cat 输出，read_file 计数 + 截断更安全）
- 拼多文件: 写到 `/tmp/notes-snapshot.md` 然后 `read_file` 一次（避免多次 read_file 把每个文件头都打出来）
- 写笔记: **agent 不主动写**。如果用户明确说"帮我在 ~/notes/ 写一个 xxx.md"，**用 write_file 写**，并提醒用户更新 INDEX.md

## 安全注意

- `~/notes/` 是用户私域，agent 假设内容**不**含恶意
- `~/notes/` 不在 git 里（用户自己管理）
- 加载的笔记会被注入到对话上下文，**不**写进 hermes memory
- agent 看到 ~/notes/ 下有**敏感内容**（密码/token）时，主动提醒"这个文件含敏感信息，要不要从 INDEX 移除或加密？"

## 关键路径

- `~/notes/` — 笔记根
- `~/notes/INDEX.md` — 索引（agent 加载笔记时**先**读这个）
- `~/notes/README.md` — 系统说明
- `/tmp/notes-snapshot.md` — 全量加载的临时拼文件
- `/tmp/notes-partial.md` — 部分加载的临时拼文件

## 跟其他系统关系

| 系统 | 角色 | 限制 |
|------|------|------|
| `~/.hermes/memories/` | 跨会话精炼 facts（user preferences, env） | **2,200 字符** |
| `~/.hermes/skills/<name>/SKILL.md` | hermes 自动加载的 skill（agent 行为指导） | 无限制 |
| `~/notes/` | **本 skill 管理**，用户/agent 自由写读的额外记忆 | **无限制** |
| Obsidian vault (`~/Documents/Obsidian Vault/`) | 双向链接 + UI 编辑（obsidian skill 管理） | 无限制 |

**用哪个**：

  - 用户已配 Obsidian vault → 用 `obsidian` skill（更原生，有 wikilink / graph view）
  - 用户**没**Obsidian 但有 `~/notes/` → **本 skill**（plain markdown 即可）
  - 都想用 → `obsidian` skill 可直接读 `~/notes/` 作为 vault（设 `OBSIDIAN_VAULT_PATH=~/notes`）

## INDEX.md 自动维护（pitfall）

**坑**：用户新建一个笔记 `nano ~/notes/<新文件>.md` 但**忘了更新 `INDEX.md`**，下次 agent 全量加载仍然能找到这个文件（因为 `find ~/notes -name "*.md"` 是 glob），但 agent 不知道这个文件存在 / 是什么主题。

**解决**：

  - **用户**自己写笔记时，提示顺手加 INDEX 一行（README.md 里已经说明）
  - **agent 写笔记**时（用户明确说"帮我在 ~/notes/ 写 xxx"），**必须**同步 patch INDEX.md
  - **加载时** INDEX.md 与 `find` 结果**不一致** → agent 主动告诉用户"INDEX 列了 X 个文件，磁盘上有 Y 个，要不要我同步 INDEX？"

**auto-sync 命令**（用户跑或 agent 在合适时跑）：

```bash
# 重生成 INDEX.md 的"笔记列表"段（保留 INDEX 里其他段, 替换 "## 笔记列表" 段）
{
  echo "# ~/notes/ INDEX"
  echo
  echo "> 手动维护的笔记索引。agent 加载笔记时**先**读这个文件，根据用户的搜索/加载请求定位到具体文件。"
  echo
  echo "## 笔记列表"
  echo
  echo '<!-- 每加一个新笔记, 在这里加一行: - `文件名`: 一句话描述 -->'
  echo
  for f in $(find ~/notes -maxdepth 2 -name "*.md" -type f | sort); do
    name=$(basename "$f")
    # 跳过 README/INDEX
    [ "$name" = "README.md" ] || [ "$name" = "INDEX.md" ] && continue
    echo "- \`$name\`: <TODO: 描述>"
  done
  echo
  echo "## 按主题"
  echo
  echo "(略 — 由用户维护)"
} > ~/notes/INDEX.md
```

注意：自动生成的描述是 `<TODO: 描述>` —— 用户**手填**一句话描述（agent 不能瞎写描述，会污染）。
