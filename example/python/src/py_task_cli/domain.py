"""业务逻辑层：任务模型与纯函数，不做 I/O、不接 CLI。"""

from __future__ import annotations


def add_task(tasks: list[dict], name: str) -> dict:
    """追加一个任务并返回它；持久化由调用方负责。"""
    task = {"id": len(tasks) + 1, "name": name, "done": False}
    tasks.append(task)
    return task


def render(tasks: list[dict]) -> list[str]:
    """把任务列表渲染为显示行。纯函数，便于单测。"""
    lines = []
    for task in tasks:
        mark = "x" if task["done"] else " "
        lines.append(f"[{mark}] {task['id']} {task['name']}")
    return lines
