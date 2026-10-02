# 功能清单（ROADMAP）

> 项目：rust-slint-counter。状态：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须可判定。

| # | 功能 | 分支 | 状态 | 依赖 | 验收标准 |
|---|------|------|------|------|----------|
| 1 | 计数加减 | feature/counter-ops | done | - | 点击 +/- 后界面计数正确变化；`cargo test` 通过 |
| 2 | 计数持久化（落盘） | feature/persist | planned | 1 | 重启后计数保留 |
| 3 | 深色主题 | feature/dark-theme | planned | - | 可切换深色 / 浅色主题 |
| 4 | 多窗口 | feature/multi-window | planned | - | 可同时打开多个计数窗口 |
