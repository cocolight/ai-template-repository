# AGENTS.md

## 项目
rust-slint-counter — Rust + Slint 跨平台桌面计数器。

## 语言与风格
- 代码：Rust。遵守 `cargo fmt`，通过 `cargo clippy`（无 warning）。
- GUI：Slint，界面定义在 `ui/*.slint`。改界面后跑 `cargo build` 重新生成绑定。
- 文档：中文为主。提交类型用 Conventional Commits 的英文前缀。

## 工作流
- 保护分支 `main`。一个功能 = 一个 `feature/<名>` 分支 = 一个 PR。
- 提交前必须通过 `cargo fmt --check`、`cargo clippy`、`cargo test`。

## 安全
- 绝不提交密钥 / token。
- `tests/` 必须保持可运行。
