# AGENTS.md

## 项目
rust-slint-counter — Rust + Slint 跨平台桌面计数器。

## 上下文入口
按顺序读：`AGENTS.md`（本文件）→ `ROADMAP.md` → `README.md` → 相关源码与测试。

## 语言与风格
- 代码：Rust。遵守 `cargo fmt`，通过 `cargo clippy --all-targets -- -D warnings`（无 warning）。
- GUI：Slint，界面定义在 `ui/*.slint`。改界面后跑 `cargo build` 重新生成绑定。
- 文档：中文为主。提交类型用 Conventional Commits 的英文前缀。

## 工作流
- 保护分支 `main`。一个功能 = 一个 `feature/<名>` 分支 = 一个 PR。
- 提交前必须通过 `cargo fmt --check`、`cargo clippy --all-targets -- -D warnings`、`cargo test`。
- 每完成一项，更新 `ROADMAP.md` 对应行状态。

## 红线
- 不得删除 / 跳过测试（含 `#[ignore]`）或改断言来骗过 CI；不得伪造「测试已通过」。
- 大改动（>5 文件或 >200 行）先确认。
- 不擅自 `git commit` / `push`；不提交密钥。

## 安全
- 绝不提交密钥 / token。
- `tests/` 必须保持可运行。
