# AGENTS.md（给 AI 的行为规则）

> 本文件供 AI 编码助手（WorkBuddy / Claude Code / Cursor 等）自动读取，
> 让每次对话都自带项目规范，无需重复交代。

## 项目
{{PROJECT_NAME}} — 用一句话说明这个项目做什么。

## 语言与风格
- 文档：默认中文，需要时附英文。简洁、不废话。
- 代码：按本项目技术栈约定（在此补充语言，如 POSIX sh / Python / Rust）。
- 提交：Conventional Commits，type 用英文前缀（feat/fix/docs/test/chore），描述可中文。

## 工作流
- 保护分支：`main`，禁止直接推送。
- 一个功能 = 一个 `feature/<名称>` 分支 = 一个 PR。
- 改动前后跑测试 / 静态检查，确保不破坏现有功能。

## 安全
- 绝不提交密钥 / token / 私钥。用环境变量或仓库外文件。
- `tests/` 必须保持可运行。
