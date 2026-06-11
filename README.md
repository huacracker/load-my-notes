# load-my-notes

[![GitHub stars](https://img.shields.io/github/stars/huacracker/load-my-notes?style=social)](https://github.com/huacracker/load-my-notes/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/huacracker/load-my-notes)](https://github.com/huacracker/load-my-notes/releases)
[![CI](https://github.com/huacracker/load-my-notes/actions/workflows/ci.yml/badge.svg)](https://github.com/huacracker/load-my-notes/actions/workflows/ci.yml)
[![Hermes skill](https://img.shields.io/badge/Hermes-skill-blueviolet)](https://hermes-agent.nousresearch.com/docs)

[English](#english) · [中文](#中文)

---

# 中文

> 绕 hermes memory 2,200 字符上限的额外记忆加载 skill。

一个 hermes agent skill，让你的"额外记忆"能像手册一样随手加载、搜索、按需部分加载到 AI 对话上下文。

## 解决什么问题

hermes 自带的 `~/.hermes/memories/` 有 2,200 字符上限。项目背景、密码备忘、踩坑记录塞不下。

`load-my-notes` skill 在 `~/notes/` 建一个**无限容量**的 markdown 笔记库，通过自然语言触发 6 个动作：

| #  | 动作 | 触发语 |
|----|------|--------|
| -1 | 查看帮助 | "查看笔记帮助" / "笔记怎么用" |
| 0  | 查看笔记列表 | "查看笔记列表" / "list my notes" |
| 1  | 全量加载 | "加载我的笔记" / "load my notes" |
| 2  | 搜索关键字 | "搜索我的笔记：svn" |
| 3  | 加载单文件 | "加载笔记：<文件名>" |
| 4  | 按关键字部分加载 | "加载包含 ccb 的笔记" |

## 安装

```bash
git clone https://github.com/huacracker/load-my-notes
cd load-my-notes
bash install.sh
```

或者手动：

```bash
mkdir -p ~/.hermes/skills/load-my-notes
cp SKILL.md ~/.hermes/skills/load-my-notes/SKILL.md
```

## 使用

1. 在家目录建 `~/notes/`（**自己**建，agent 不自动建避免污染）
2. 用 `nano` / `vi` 写笔记：`nano ~/notes/2026-06-12-某话题.md`
3. 在 hermes REPL（或任何接入 hermes 的地方）说 "查看笔记帮助"

```bash
mkdir -p ~/notes
nano ~/notes/2026-06-12-hello.md
# 写完后: 在 hermes REPL 说 "加载我的笔记"
```

## 设计原则

- **用户写，agent 不写**：避免 agent 自动污染笔记库
- **默认不加载进 context**：你说"加载"才进，token 友好
- **跨会话、跨项目**：跟 hermes memory 互补，memory 装精炼 facts，~/notes 装详细背景
- **不强制格式**：纯 markdown，文件名自由，子目录自由

## 为什么不用 Obsidian

hermes 自带 `obsidian` skill。如果你已经在用 Obsidian vault，**优先用 `obsidian` skill**（它有 wikilink / edit / graph 工具）。`load-my-notes` 是给"我就想要个纯 markdown 目录"的轻量场景。

## 例子

看 [`examples/`](./examples/) 目录，3 个示范笔记 + 索引模板。

## 贡献

欢迎贡献！流程见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

提 issue / feature request / question 都有模板（点 "New issue" 自动选）。

## 配合 hermes memory

- `~/.hermes/memories/`（2,200 字）：精炼 user preferences / 跨项目 facts
- `~/notes/`（无限）：详细项目背景 / 密码 / 备忘 / 流程

两者互补。memory 是 agent 启动时**自动**注入；notes 是你**显式**触发才进。

---

# English

> A Hermes skill that bypasses the 2,200-character memory cap by loading markdown notes from `~/notes/`.

A [Hermes](https://hermes-agent.nousresearch.com/docs) agent skill that lets you load, search, and selectively inject your "extra memory" into the AI conversation context — on demand, in plain language.

## What problem does it solve

Hermes's built-in `~/.hermes/memories/` has a hard 2,200-character cap. Project backgrounds, password notes, and "things I keep forgetting" don't fit.

`load-my-notes` lets you keep a **markdown note library of any size** at `~/notes/`, and trigger 6 actions via natural language:

| #  | Action | Trigger |
|----|--------|---------|
| -1 | Help | "查看笔记帮助" / "笔记怎么用" |
| 0  | List notes | "查看笔记列表" / "list my notes" |
| 1  | Load all | "加载我的笔记" / "load my notes" |
| 2  | Search by keyword | "搜索我的笔记：svn" |
| 3  | Load one file | "加载笔记：<filename.md>" |
| 4  | Load by keyword match | "加载包含 ccb 的笔记" |

## Install

```bash
git clone https://github.com/huacracker/load-my-notes
cd load-my-notes
bash install.sh
```

Or manually:

```bash
mkdir -p ~/.hermes/skills/load-my-notes
cp SKILL.md ~/.hermes/skills/load-my-notes/SKILL.md
```

## Usage

1. Create `~/notes/` yourself (the skill does **not** auto-create it, to avoid pollution)
2. Write notes with `nano` / `vi`: `nano ~/notes/2026-06-12-topic.md`
3. In the Hermes REPL (or anywhere a Hermes agent is running), say "查看笔记帮助"

```bash
mkdir -p ~/notes
nano ~/notes/2026-06-12-hello.md
# Then in Hermes REPL: "加载我的笔记"
```

## Design principles

- **You write, the agent doesn't** — no silent pollution
- **Not loaded by default** — context is only injected when you say "load", saving tokens
- **Cross-session, cross-project** — complements Hermes memory (facts) with deep notes (background)
- **No format lock-in** — pure markdown, free filenames, free subdirs

## Why not Obsidian

Hermes ships with an `obsidian` skill. If you already use an Obsidian vault, **prefer the `obsidian` skill** — it has wikilinks, edit, graph tools, etc. `load-my-notes` is for the "I just want a plain markdown directory" lightweight case.

## Examples

See [`examples/`](./examples/) — 3 sample notes + an INDEX template.

## Contributing

PRs welcome! See [CONTRIBUTING.md](./CONTRIBUTING.md).

Bug reports, feature requests, and questions each have a structured template (auto-selected when you click "New issue").

## Works with Hermes memory

- `~/.hermes/memories/` (2,200 chars): refined user prefs / cross-project facts
- `~/notes/` (unlimited): detailed project backgrounds / passwords / runbooks

They complement each other. Memory is **auto-injected** at agent startup; notes are **explicitly triggered** by you.

## License

MIT
