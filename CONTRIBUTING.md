# 贡献指南

## 分支策略
- `main` 为保护分支，不要直接推送。
- 从 `main` 切 `feature/<名称>` 分支，一个功能一个分支。

## 提交规范
- Conventional Commits，type 用英文前缀：
  `feat:`（新功能）`fix:`（修复）`docs:`（文档）`test:`（测试）`chore:`（杂项）
- 描述用中文，简明，英文计数 <= 72 字符。

## Pull Request
- 向 `main` 提 PR，说明做了什么、为什么，关联 ROADMAP 对应行。
- 确保本地检查通过后再提。

## 本地检查
（按技术栈补充，例如：shellcheck src/*.sh / pytest / cargo test）
