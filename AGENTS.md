# AGENTS.md — 给 AI 编码助手的行为规则（维护本仓库时）

> 本文件是**工具层**规则，约束的是「改动本模板仓库」这件事。
> 生成的新项目里另有一份 `AGENTS.md`（位于 `template/AGENTS.md`），那份约束的是
> 「开发新项目」。**两者内容不同，不要互相覆盖。**

## 0. 本项目

`ai-template-repository` —— 一个「面向 AI 协作开发」的项目模板，由两层组成：

- **工具层**（仓库根）：本文件、README、TEMPLATE.md、生成脚本、CI、活文档示例
- **数据层**（`template/`）：项目骨架，会被整目录复制进新项目

## 1. 上下文入口（按此顺序阅读）

1. `AGENTS.md`（本文件）— 工具层的规则与红线
2. `README.md` — 仓库自述与目录结构
3. `TEMPLATE.md` — 模板使用手册：开工清单、哪些文件不能改
4. `CONTRIBUTING.md` — 维护自检命令
5. `template/AGENTS.md` — **生成物**里的规则（改模板时看它，别改它）
6. 与任务相关的源码与测试

## 2. 常用命令（可直接复制执行）

| 目的 | 命令 |
|------|------|
| 安装依赖 | 无（仅需 POSIX `sh` + Git ≥ 2.28；Windows 用 Git Bash） |
| 运行 | `./scripts/template-init.sh --dry-run ../demo`（只打印不落盘） |
| 测试 | 见 [CONTRIBUTING.md](CONTRIBUTING.md)「改完模板后的自检」—— 完整 11 条 |
| Lint | `shellcheck scripts/*.sh` |
| 格式化检查 | 无（仓库统一 LF，由 `.gitattributes` 强制） |

Python / Rust 示例的真实检查命令见 `ci.yml` 的 `python-example` / `rust-example` job。

## 3. 工作流

- 保护分支 `main`，禁止直接推送。
- 一个功能 = 一个 `feature/<名称>` 分支 = 一个 PR。
- **推 commit 前先 `gh pr view <n> --json state` 确认 PR 仍 OPEN**；已 merge 就不要再往旧分支 push（commit 会成孤儿、不进 main）。
- 提交：Conventional Commits，type 用英文前缀（`feat`/`fix`/`docs`/`test`/`chore`/`refactor`/`ci`）；描述可用中文；标题总长 ≤ 72 字符。
- 本仓库的架构决策只记在 `CHANGELOG.md`；**不维护工具层 ADR**（`docs/adr/` 已在 `template/` 下，属生成物）。

## 4. 红线（违反即回滚）

1. 不得删除 / 跳过 / 弱化 `ci.yml` 里的任何断言（含 `shellcheck`、smoke test、两个 example 的 lint/test），不得让检查变绿。
2. **不得把 payload 文件放回仓库根目录。** 放错位置会让新项目静默混入工具层文件 —— 这正是本次重构要消除的缺陷。
3. **不得修改 `template/` 内的占位符语义。** `{{PROJECT_NAME}}` 与 `{{YEAR}}` 是生成物的唯一替换源；把占位符字面写进 `template/` 以外的文件是安全的，写进 `template/` 内会在生成时被替换掉。
4. **不得让 `template/` 缺失。** `template-init.sh` 在该目录缺失时以退出码 5 硬失败；新增工具层文件时请确认没误删 `template/`。
5. 不得擅自 `git commit` / `push` / `rebase` / `reset` / `--force`、切分支或改远程；仅在明确要求时执行。
6. 不得为了让检查「变绿」而修改 CI、hook、lint 配置或断言阈值。
7. 不得提交密钥 / token / 私钥 / `.env`。
8. 只改与任务相关的文件，不做无关重构、不顺手改格式。
9. 同一问题连续 2 次修复失败，停下说明现状并求助。

## 5. 完成定义（DoD）

- [ ] `template-init.sh` 能真实生成新项目，产物结构与 `TEMPLATE.md` 描述一致
- [ ] 产物**不含**任何工具层文件（`template/`、`TEMPLATE.md`、`example/`、`scripts/template-init.sh`、`.github/workflows/ci.yml`）
- [ ] 产物**不含** `.gitkeep`，但 `src/` `tests/` `scripts/` 三个目录都在
- [ ] 产物无残留 `{{` 占位符，默认分支为 `main`
- [ ] 根 `.gitattributes` 与 `template/.gitattributes` 内容一致
- [ ] `shellcheck scripts/*.sh` 通过
- [ ] 改动了 `template/` 就已同步 `TEMPLATE.md` 中受影响的路径描述
- [ ] `CHANGELOG.md` 的 `Unreleased` 已记录

## 6. 并发协作

- 一个分支只由一个执行者写入；动手前先 `git fetch`。
- 遇到冲突立即停止并说明，不要擅自 `--force`。

## 7. 安全

- 绝不提交密钥 / token / 私钥。
- `template/` 下的文件会被复制到用户项目里，**写入其中的任何内容都会被用户看到**。不要在 payload 里写本仓库的内部信息、路径或凭据。
