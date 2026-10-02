# AGENTS.md

## 项目
py-task-cli — Python + Typer 命令行任务管理工具。

## 上下文入口
按顺序读：`AGENTS.md`（本文件）→ `ROADMAP.md` → `README.md` → 相关源码与测试。

## 语言与风格
- 代码：Python 3.10+，含类型注解。用 `ruff check` 检查、`ruff format` 格式化。
- 文档：中文为主。提交类型用 Conventional Commits 的英文前缀。

## 工作流
- 保护分支 `main`。一个功能 = 一个 `feature/<名>` 分支 = 一个 PR。
- 提交前必须通过 `ruff check .`、`ruff format --check .`、`pytest`。
- 每完成一项，更新 `ROADMAP.md` 对应行状态。

## 红线
- 不得删除 / 跳过测试（含 `skip` / `xfail`）或改断言来骗过 CI；不得伪造「测试已通过」。
- 大改动（>5 文件或 >200 行）先确认。
- 不擅自 `git commit` / `push`；不提交密钥。

## 测试隔离
- 测试通过环境变量 `PY_TASK_CLI_STORE` 指向临时路径，**不要**依赖 `HOME`（Windows 上无效）。

## 安全
- 绝不提交密钥 / token。
- `tests/` 必须保持可运行。
