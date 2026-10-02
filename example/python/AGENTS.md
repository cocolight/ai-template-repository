# AGENTS.md

## 项目
py-task-cli — Python + Typer 命令行任务管理工具。

## 语言与风格
- 代码：Python 3.10+，含类型注解。`ruff` 检查、`black` 风格。
- 文档：中文为主。提交类型用 Conventional Commits 的英文前缀。

## 工作流
- 保护分支 `main`。一个功能 = 一个 `feature/<名>` 分支 = 一个 PR。
- 提交前过 `ruff check`、`pytest`。

## 安全
- 绝不提交密钥 / token。
- `tests/` 必须保持可运行。
