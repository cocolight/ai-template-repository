# rust-slint-counter

用 Rust + [Slint](https://slint.dev/) 写的跨平台桌面计数器。

## 功能
- 点击按钮累加 / 递减计数
- 纯本地运行，无后台服务

## 环境
- Rust 1.75+
- Slint 1.8

## 构建与运行

```bash
cargo run
```

需要优化构建时：

```bash
cargo run --release
```

## 检查

```bash
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test
```

## 目录
- `ui/` — Slint 界面定义（`*.slint`）
- `src/` — Rust 逻辑（`src/main.rs` 含单元测试）
- `tests/` — 集成测试目录（当前为占位）
- `build.rs` — 编译 `.slint` 并生成 Rust 绑定

## 许可证
MIT
