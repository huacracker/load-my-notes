name: Question
description: 问 skill 行为 / 用法
title: "[Question] "
labels: ["question"]
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        用法上的问题。先搜 [README](./README.md) 和 [SKILL.md](./SKILL.md)。

  - type: input
    id: question
    attributes:
      label: 你的问题
      description: 一句话描述
      placeholder: "skill 装好后我看不到怎么办？"

  - type: textarea
    id: detail
    attributes:
      label: 详细信息
      description: 你的环境、你试过什么、卡在哪

  - type: textarea
    id: tried
    attributes:
      label: 已试过
      description: 你已经试过哪些方法？避免重复建议
      placeholder: |
        - 跑了 `bash install.sh`，输出"installed"
        - 重启了 hermes
        - 看 ~/.hermes/skills/load-my-notes/ 有 SKILL.md
