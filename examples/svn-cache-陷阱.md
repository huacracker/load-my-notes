# svn commit 缓存陷阱

> 通用经验，2026-06 多次踩坑。**这个例子不含任何敏感信息**（无 IP / 无 token / 无密码），可安全分享。

## 现象

`svn commit` 成功输出 `Committed revision N`，但**之后**：

```bash
$ svn info . | grep "Last Changed Rev"
Last Changed Rev: N-1     # 错的！应该是 N

$ svn log -l 1
rN-1 | ...                 # 错的！应该是 rN
```

`svn log -l 1` 也显示 N-1，**误导你以为 commit 没成功**。

## 原因

working copy 根目录的 metadata 缓存（类似 .git/index）。commit 实际写进了 server，**只是本地缓存没更新**。

## 正确验证

```bash
$ svn update .
Updating '.':
At revision N              # ← 真的 commit 进 N 了
```

## 教训

**永远用 `svn update .` 验证 commit 是否成功**，不要信 `svn info` 或 `svn log -l 1`（它们读本地缓存）。

## 触发场景

- 大文件 commit（>10MB）
- 多文件批量 commit
- 网络慢的时候
- 一天内连续 commit 多次
