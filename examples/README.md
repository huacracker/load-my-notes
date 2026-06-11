# examples/ — 示范笔记目录

把 `examples/` 当成你自己 `~/notes/` 的**起步模板**。

## 装好 skill 后的步骤

1. 装好 load-my-notes skill（看主 README）
2. 在你**自己**的家目录建 `~/notes/`：
   ```bash
   mkdir -p ~/notes
   ```
3. 复制本目录的 `INDEX.md` 作为你的索引模板：
   ```bash
   cp examples/INDEX.md ~/notes/INDEX.md
   ```
4. 用 `nano` 写你的笔记（**agent 不自动写**，你决定内容）

## examples 包含什么

| 文件 | 用途 |
|------|------|
| `INDEX.md` | 索引模板（手写一行行加新笔记） |
| `2026-06-12-EXAMPLE-项目.md` | 一个虚构项目的背景示范 |
| `svn-cache-陷阱.md` | 一个**通用**的踩坑笔记（svn 缓存陷阱，不含敏感信息） |
| `临时/scratch.md` | 草稿示范 |

**注意**：所有 examples 用的是虚构公司名 `EXAMPLE-CORP` / 假域名 `example.com` / RFC 5737 文档 IP `192.0.2.1`，**不含任何真实信息**。
