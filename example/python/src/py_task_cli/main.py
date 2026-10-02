"""py-task-cli — 命令行任务管理工具。"""
from __future__ import annotations

import json
from pathlib import Path

import typer

APP = typer.Typer(help="简单的命令行任务管理")
STORE = Path.home() / ".py_task_cli.json"


def _load() -> list[dict]:
    if STORE.exists():
        return json.loads(STORE.read_text(encoding="utf-8"))
    return []


def _save(tasks: list[dict]) -> None:
    STORE.write_text(json.dumps(tasks, ensure_ascii=False, indent=2), encoding="utf-8")


@APP.command()
def add(name: str) -> None:
    """新增一个任务。"""
    tasks = _load()
    tasks.append({"id": len(tasks) + 1, "name": name, "done": False})
    _save(tasks)
    typer.echo(f"added: {name}")


@APP.command()
def ls() -> None:
    """列出所有任务。"""
    for task in _load():
        mark = "x" if task["done"] else " "
        typer.echo(f"[{mark}] {task['id']} {task['name']}")


if __name__ == "__main__":
    APP()
