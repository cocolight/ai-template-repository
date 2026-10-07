# 贡献指南

> 项目：{{PROJECT_NAME}}

> 🤖 使用 AI 编码助手开发时，请先阅读 [AGENTS.md](AGENTS.md)（规则与红线）。

## 分支策略

- `main` 为保护分支，不要直接推送。
- 从 `main` 切 `feature/<名称>` 分支，一个功能一个分支。

## 提交规范

- Conventional Commits，type 用英文前缀：
  `feat:`（新功能）`fix:`（修复）`docs:`（文档）`test:`（测试）`chore:`（杂项）`refactor:`（重构）`ci:`（CI）。
- 描述可用中文，简明；标题总长 ≤ 72 字符。

## Pull Request

- 向 `main` 提 PR，说明做了什么、为什么，并关联 `ROADMAP.md` 对应行。
- 确保本地检查通过（见下）后再提。

## 本地检查

（按本项目技术栈填写，须与 `AGENTS.md` §2「常用命令」完全一致）

## 红线与完成定义

- 提交前请阅读 `AGENTS.md` 的「红线」。
- 功能是否算完成，以 `docs/definition-of-done.md` 为准。

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
