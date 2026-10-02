# 功能清单（ROADMAP）

> 项目：py-task-cli。状态：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须可判定。

| # | 功能 | 分支 | 状态 | 依赖 | 验收标准 |
|---|------|------|------|------|----------|
| 1 | 增删任务（add / ls） | feature/crud | done | - | `pytest` 通过；`task add` 后 `task ls` 能看到该任务 |
| 2 | 完成状态标记（task done / undo） | feature/done-flag | planned | 1 | `task done <id>` 后 `task ls` 显示 `[x]` |
| 3 | 导出 JSON | feature/export | planned | 1 | `task export` 输出合法 JSON |
| 4 | 彩色输出 | feature/rich-ui | planned | - | `task ls` 输出带颜色 |
