"""py-task-cli — 命令行任务管理工具（入口层：CLI 接线）。"""

from __future__ import annotations

import typer

from py_task_cli import domain, storage

app = typer.Typer(help="简单的命令行任务管理")


@app.command()
def add(name: str) -> None:
    """新增一个任务。"""
    tasks = storage.load()
    task = domain.add_task(tasks, name)
    storage.save(tasks)
    typer.echo(f"added: {task['name']}")


@app.command()
def ls() -> None:
    """列出所有任务。"""
    for line in domain.render(storage.load()):
        typer.echo(line)


if __name__ == "__main__":
    app()
