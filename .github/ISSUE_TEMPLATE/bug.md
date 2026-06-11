name: Bug report
description: 报告 skill 行为异常
title: "[Bug] "
labels: ["bug"]
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        感谢你提 bug！请尽量提供复现步骤和环境信息。

  - type: input
    id: version
    attributes:
      label: Hermes 版本
      description: 跑 `hermes --version` 复制输出
      placeholder: "Hermes Agent 2.x.x"

  - type: input
    id: os
    attributes:
      label: 操作系统
      description: 例如 Ubuntu 24.04, macOS 14.5, Windows 11
      placeholder: "Ubuntu 24.04"

  - type: input
    id: shell
    attributes:
      label: Shell
      description: bash / zsh / fish / 其他
      placeholder: "bash 5.2"

  - type: dropdown
    id: actions
    attributes:
      label: 哪个动作有 bug
      description: 选一个
      options:
        - 动作 -1: 查看帮助
        - 动作 0: 查看笔记列表
        - 动作 1: 全量加载
        - 动作 2: 搜索关键字
        - 动作 3: 加载单文件
        - 动作 4: 按关键字部分加载
        - install.sh
        - CI workflow
        - 其他

  - type: textarea
    id: steps
    attributes:
      label: 复现步骤
      description: 一行一步，越具体越好
      placeholder: |
        1. mkdir -p ~/notes
        2. nano ~/notes/test.md
        3. 在 hermes REPL 说: 加载我的笔记
        4. 看到 xxx 错误

  - type: textarea
    id: expected
    attributes:
      label: 期望行为
      description: 你期望发生什么

  - type: textarea
    id: actual
    attributes:
      label: 实际行为
      description: 实际发生什么（贴错误输出）

  - type: textarea
    id: notes
    attributes:
      label: 附加信息
      description: 其他可能有用的（截图、其他 skill 冲突等）
      placeholder: |
        ~/notes/ 结构:
        ```
        README.md
        INDEX.md
        test.md
        ```
