# Contributing to load-my-notes

🎉 感谢考虑贡献！本文档会帮你快速上手。

## 项目概览

`load-my-notes` 是一个 [Hermes](https://hermes-agent.nousresearch.com/docs) agent skill —— 让用户用自然语言触发 6 个动作，加载 `~/notes/` 下的 markdown 笔记到 AI 对话上下文。

**核心特点**：
- 单文件 `SKILL.md` (9.4KB) + 一键 `install.sh`
- 纯 markdown，**没有编译步骤**
- 用户自己写笔记，agent **不**自动写

## 开发环境

无依赖：

```bash
git clone https://github.com/huacracker/load-my-notes
cd load-my-notes
# 改完跑 CI 检查 (需要 gh CLI 已登录)
gh workflow run ci.yml
# 或者本地跑 CI 等价检查
bash -n install.sh && shellcheck install.sh
```

**本地 lint**：
- `shellcheck install.sh` (CI 跑)
- `bash -n install.sh` (语法)
- frontmatter 解析：手动看 `SKILL.md` 头部 `---` 块

## 提 PR 流程

1. **Fork** 仓库
2. **创建分支**：`git checkout -b feat/your-feature`
3. **修改**：编辑 `SKILL.md` / `install.sh` / `examples/`
4. **本地验证**：
   ```bash
   bash -n install.sh
   shellcheck install.sh
   # 跑 install.sh 测装
   bash install.sh
   ```
5. **commit**：`git commit -m "feat: 描述"`，用 Conventional Commits
6. **push** + 开 PR
7. **CI 自动跑**，绿勾后等 review

## Conventional Commits

```
feat: 新功能
fix: 修 bug
docs: 文档改动
chore: 杂项（CI、依赖、build）
refactor: 重构
test: 加测试
```

## 提 Issue

- **Bug**: 用 [Bug report] 模板，附上 `bash --version` / `hermes --version` / 复现步骤
- **新功能**: 用 [Feature request] 模板，说明用例
- **Skill 行为疑问**: 用 [Question] 模板

## 改动 SKILL.md 的注意

`SKILL.md` 是 skill 主体，agent 启动时按 description 自动加载。改前先想：

| 改动类型 | 是否需要 | 注意 |
|---------|---------|------|
| 修触发语 | ✅ | 同步改 `description:` 里 `Use when the user says: ...` 列表 |
| 修动作行为 | ✅ | 同步改 6 个动作的"触发语"段 + "动作清单"表 |
| 加新动作 | ✅ | 同步加 description 触发词 + 动作清单表 + 测试场景 |
| 改 description | ✅ | 这是 agent **唯一**看到的"何时触发"信号 |
| 改 markdown 排版 | ⚠️ | CI 不会 lint md 排版，但保持跟现有风格一致 |

**CI 强制检查**（6 个动作标题都得在）：
```yaml
for action in "动作 -1" "动作 0" "动作 1" "动作 2" "动作 3" "动作 4"; do
  grep -q "### $action" SKILL.md
done
```

## 改动 install.sh

- 必须 `set -e`
- 不要 hard-code 路径，用 `$HOME`
- 错误信息走 `>&2`
- CI 跑 `bash -n` + `shellcheck`，两个都得过

## 改动 examples/

- **不要**写真实项目/密码/token
- 用 `EXAMPLE-CORP` / `example.com` / RFC 5737 文档 IP (`192.0.2.x` / `198.51.100.x`)
- 改一个文件就同步更新 `INDEX.md`

## 改动 README.md / LICENSE

- README 加新功能时同步加 badge
- LICENSE 只在换协议时改（现在 MIT）

## Release 流程（仅 maintainer）

1. 改代码 + 跑 CI
2. 写 `CHANGELOG.md`（v0.X.0 段）
3. `git tag v0.X.0` + `git push --tags`
4. `gh release create v0.X.0 --notes-file release-notes.md`
5. README badge 自动更新

## 行为准则

- 友好、建设性
- 假设善意
- 对事不对人

## License

贡献者协议：你的贡献按 [MIT](./LICENSE) 协议发布。
