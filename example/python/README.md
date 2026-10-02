# py-task-cli

命令行任务管理工具（Python + Typer）。

## 安装

```bash
pip install .
```

## 用法

```bash
task add "写文档"
task ls
```

## 开发

```bash
pip install -e ".[dev]"
ruff check .
ruff format --check .
pytest
```

> 任务数据默认存于 `~/.py_task_cli.json`；可用环境变量 `PY_TASK_CLI_STORE` 覆盖（测试即用它做隔离）。

## 目录

- `src/py_task_cli/` — 源码
- `tests/` — 测试
- `docs/` — 文档

## 许可证

MIT
