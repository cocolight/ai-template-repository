# 贡献指南

## 分支策略
- `main` 为保护分支，不要直接推送。
- 从 `main` 切 `feature/<名称>` 分支，一个功能一个分支。

## 提交规范
- Conventional Commits：`feat:` `fix:` `docs:` `test:` `chore:`（英文前缀）。
- 描述用中文，简明，英文计数 <= 72 字符。

## Pull Request
- 向 `main` 提 PR，说明做了什么、为什么。
- 本地检查必须全过：

```bash
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test
```
