"""基础设施层：任务数据的 JSON 文件持久化。"""

from __future__ import annotations

import json
import os
from pathlib import Path


def _store() -> Path:
    """任务数据文件路径；可用环境变量 PY_TASK_CLI_STORE 覆盖（便于测试隔离）。"""
    return Path(os.environ.get("PY_TASK_CLI_STORE", Path.home() / ".py_task_cli.json"))


def load() -> list[dict]:
    store = _store()
    if store.exists():
        return json.loads(store.read_text(encoding="utf-8"))
    return []


def save(tasks: list[dict]) -> None:
    _store().write_text(json.dumps(tasks, ensure_ascii=False, indent=2), encoding="utf-8")
