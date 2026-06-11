name: Feature request
description: 提议新功能
title: "[Feature] "
labels: ["enhancement"]
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        想加什么功能？先描述你的用例，让 maintainer 评估。

  - type: textarea
    id: problem
    attributes:
      label: 用例 / 痛点
      description: 你想解决什么问题？现在怎么做？有多痛？
      placeholder: |
        我有 50 个笔记，全量加载 token 太贵。想搜"svn 相关的"，但不想
        每次都输"加载包含 svn 的笔记"。能不能加个 tag 系统？

  - type: textarea
    id: solution
    attributes:
      label: 提议方案
      description: 你觉得怎么实现？
      placeholder: |
        1. 笔记 frontmatter 加 `tags: [svn, devops]`
        2. 新增动作 5: "按 tag 加载"
        3. 触发: "加载 svn 标签的笔记"

  - type: textarea
    id: alternatives
    attributes:
      label: 备选方案
      description: 还有别的实现方式吗？

  - type: textarea
    id: context
    attributes:
      label: 附加信息
      description: 截图、原型、相关 issue 等
