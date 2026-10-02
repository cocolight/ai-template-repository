# 贡献指南

> 项目：py-task-cli

## 分支策略
- `main` 为保护分支，不要直接推送。
- 从 `main` 切 `feature/<名称>` 分支，一个功能一个分支。

## 提交规范
- Conventional Commits：`feat:` `fix:` `docs:` `test:` `chore:` `refactor:` `ci:`（英文前缀）。
- 描述可用中文，简明；标题总长 ≤ 72 字符。

## Pull Request
- 向 `main` 提 PR，说明做了什么、为什么，并关联 `ROADMAP.md` 对应行。
- 本地检查必须全过：

```bash
ruff check .
ruff format --check .
pytest
```

## 红线与完成定义
- 提交前请阅读 `AGENTS.md` 的「红线」。

## 许可证
MIT
