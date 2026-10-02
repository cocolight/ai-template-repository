"""py-task-cli — 命令行任务管理工具。"""

from __future__ import annotations

import json
import os
from pathlib import Path

import typer

app = typer.Typer(help="简单的命令行任务管理")


def _store() -> Path:
    """任务数据文件路径；可用环境变量 PY_TASK_CLI_STORE 覆盖（便于测试隔离）。"""
    return Path(os.environ.get("PY_TASK_CLI_STORE", Path.home() / ".py_task_cli.json"))


def _load() -> list[dict]:
    store = _store()
    if store.exists():
        return json.loads(store.read_text(encoding="utf-8"))
    return []


def _save(tasks: list[dict]) -> None:
    _store().write_text(json.dumps(tasks, ensure_ascii=False, indent=2), encoding="utf-8")


@app.command()
def add(name: str) -> None:
    """新增一个任务。"""
    tasks = _load()
    tasks.append({"id": len(tasks) + 1, "name": name, "done": False})
    _save(tasks)
    typer.echo(f"added: {name}")


@app.command()
def ls() -> None:
    """列出所有任务。"""
    for task in _load():
        mark = "x" if task["done"] else " "
        typer.echo(f"[{mark}] {task['id']} {task['name']}")


if __name__ == "__main__":
    app()
