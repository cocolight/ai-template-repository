# AGENTS.md — 给 AI 编码助手的行为规则（维护本仓库时）

> 本文件是**工具层**规则，约束的是「改动本模板仓库」这件事。
> 生成的新项目里另有一份 `AGENTS.md`（位于 `template/blank/AGENTS.md`），那份约束的是
> 「开发新项目」。**两者内容不同，不要互相覆盖。**

## 0. 本项目

`ai-template-repository` —— 一个「面向 AI 协作开发」的项目模板，由两层组成：

- **工具层**（仓库根）：本文件、README、TEMPLATE.md、生成脚本、CI、活文档示例
- **数据层**（`template/`，按变体组织：当前含 `blank/`、`general/`）：项目骨架，会被整目录复制进新项目

## 1. 上下文入口（按此顺序阅读）

1. `AGENTS.md`（本文件）— 工具层的规则与红线
2. `README.md` — 仓库自述与目录结构
3. `TEMPLATE.md` — 模板使用手册：开工清单、哪些文件不能改
4. `CONTRIBUTING.md` — 维护自检命令
5. `template/blank/AGENTS.md` — **生成物**里的规则（改模板时看它，别改它）
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
- 本仓库的架构决策只记在 `CHANGELOG.md`；**不维护工具层 ADR**（`template/blank/docs/engineering/adr/` 属生成物，不随工具层维护）。

### 发版（打 tag / 建 Release）

> 本仓库自身也发版（已有 `v0.1.0`）。这份能力与 `template/blank/docs/engineering/releasing.md` 对齐 —— 但工具层不产生 payload、不复制 `releasing.md`，所以要点直接写在这里。

- **前置**：`ci.yml` 全绿；`ROADMAP.md` 无 `in-progress` 行；根 `CHANGELOG.md` 的 `[Unreleased]` 已写全。
- **命名**（三处必须一致）：tag 用 `vX.Y.Z`（带 `v`）；Release title 与 tag 完全相同；根 `CHANGELOG.md` 版本节写 `[X.Y.Z] - 日期`（**不带** `v`）。
- **版本号事实源**：本仓库不维护独立版本号文件，版本只由根 `CHANGELOG.md` 的版本节定义 —— 这是 `template/blank/AGENTS.md` §8 坐标表「版本号」一行在工具层的对应答法。
- **顺序**：改根 `CHANGELOG.md` → 提 PR 合入 `main`（type 用 `chore`）→ **在 `main` 上**打 tag → 建 Release，说明正文取自根 `CHANGELOG.md` 的对应版本节，不另写一套。
- 未经明确要求，不得 `git tag` / 推送 tag / 建 Release —— 见 §4 红线第 5 条。

## 4. 红线（违反即回滚）

1. 不得删除 / 跳过 / 弱化 `ci.yml` 里的任何断言（含 `shellcheck`、smoke test、两个 example 的 lint/test），不得让检查变绿。
2. **不得把 payload 文件放回仓库根目录。** 放错位置会让新项目静默混入工具层文件 —— 这正是本次重构要消除的缺陷。
3. **不得修改任一变体目录（如 `template/blank/`）内的占位符语义。** `{{PROJECT_NAME}}` 与 `{{YEAR}}` 是生成物的唯一替换源；把占位符字面写进变体目录以外的文件是安全的，写进变体内会在生成时被替换掉。
4. **不得让 `template/` 缺失（其下至少含 `blank/` 与 `general/` 两个变体）。** `template-init.sh` 在该目录缺失时以退出码 5 硬失败；新增工具层文件时请确认没误删 `template/`。
5. 不得擅自 `git commit` / `push` / `push --tags` / `tag` / `rebase` / `reset` / `--force`、创建 Release、切分支或改远程；仅在明确要求时执行。**发版尤其如此**：tag 与 Release 对外可见、发布后撤不干净，规则见 §3「发版」。
6. 不得为了让检查「变绿」而修改 CI、hook、lint 配置或断言阈值。
7. 不得提交密钥 / token / 私钥 / `.env`。
8. 只改与任务相关的文件，不做无关重构、不顺手改格式。
9. 同一问题连续 2 次修复失败，停下说明现状并求助。

## 5. 完成定义（DoD）

- [ ] `template-init.sh` 能真实生成新项目，产物结构与 `TEMPLATE.md` 描述一致
- [ ] 产物**不含**任何工具层文件（`template/`、`TEMPLATE.md`、`example/`、`scripts/template-init.sh`、`.github/workflows/ci.yml`）
- [ ] 产物**不含** `.gitkeep`，但 `src/` `tests/` `scripts/` 三个目录都在
- [ ] 产物无残留 `{{PROJECT_NAME}}` / `{{YEAR}}` 占位符，默认分支为 `main`
- [ ] 根 `.gitattributes` 与每个变体的 `.gitattributes`（`template/blank/.gitattributes` 等）内容一致
- [ ] `shellcheck scripts/*.sh` 通过
- [ ] 改动了 `template/<变体>/` 就已同步 `TEMPLATE.md` 中受影响的路径描述
- [ ] 改动了 `template/<变体>/` 的**规则或能力**（红线 / DoD / 工作流 / 矩阵），已同步到根 `AGENTS.md` 的对应章节 —— 见 §8
- [ ] `CHANGELOG.md` 的 `Unreleased` 已记录

## 6. 并发协作

- 一个分支只由一个执行者写入；动手前先 `git fetch`。
- 遇到冲突立即停止并说明，不要擅自 `--force`。

## 7. 安全

- 绝不提交密钥 / token / 私钥。
- `template/<变体>/` 下的文件会被复制到用户项目里，**写入其中的任何内容都会被用户看到**。不要在 payload 里写本仓库的内部信息、路径或凭据。

## 8. 同改矩阵

> 对应 `template/blank/AGENTS.md` §9。适用本仓库的**核心约定**：约束新建项目以 `template/<变体>/` 下的文档为准；变体更新后，**能力必须同步回根仓库** —— 本仓库没有理由不遵守它教人遵守的规则。

| 改了什么 | 同一回合必须过一遍 |
|---|---|
| `template/<变体>/` 里新增 / 删除 payload 文件 | `TEMPLATE.md`「模板包含什么」表 + `ci.yml` 的 payload 清单与 smoke 正向断言（漏了 CI 会红） |
| `template/<变体>/` 里 payload 文件的**路径变化**（改名 / 移动） | 除上面一行外，还要过：`TEMPLATE.md`「新项目开工清单」与「哪些文件不要改」表、`TEMPLATE.md` 自检正向断言列表、`ci.yml` 的「仓库结构自检」；**payload 文档内的相对链接**（层级一变，`../x` 就会指空，由「产物内文档死链检查」判定）；以及根 `AGENTS.md` / `CONTRIBUTING.md` / `ROADMAP.md` / `CHANGELOG.md` 里的引用 |
| `template/<变体>/` 里的**规则 / 能力**（红线 / DoD / 工作流 / 矩阵） | 根 `AGENTS.md` 的对应章节；根 `CHANGELOG.md` 记录 |
| `template/<变体>/` 里的路径描述 | `TEMPLATE.md`「新项目开工清单」与「哪些文件不要改」 |
| 根工具层文件的增 / 删 / 改名 | `README.md` 目录结构、`TEMPLATE.md`「不在你的项目里」、`ci.yml` 的「仓库结构自检」 |
| 脚本行为或选项 | `README.md` + `TEMPLATE.md` + `CONTRIBUTING.md` 三处描述一致 |
| 本地检查命令或门禁 | `CONTRIBUTING.md`「本地检查」→ `.github/workflows/ci.yml`，两者必须一致 |
| 发版（打 tag / 建 Release） | §3「发版」；根 `CHANGELOG.md` 的 `[Unreleased]` 改名为 `[X.Y.Z] - 日期`（不带 v）并补回空节点。`template/blank/docs/engineering/releasing.md` 是同一能力的详细版，**两处不得打架** |
| 章节标题 / 编号 | 全仓扫一遍按「§N」引用本文件的地方（根 `AGENTS.md`、`CONTRIBUTING.md`、`TEMPLATE.md`） |

两条边界：

- **同步是单向的**：只从 `template/` 流向根仓库。工具层专属红线（「不得把 payload 文件放回仓库根目录」「不得让 `template/` 缺失」「占位符语义不可改」等）只对本仓库有意义，**不写进 `template/<变体>/`**。
- **同步的是「能力」，不是逐字复制**：两份 `AGENTS.md` 受众不同（根 = 维护本仓库，`template/` = 开发新项目），同一能力在两边用各自视角表述。开头的「两者内容不同，不要互相覆盖」指的是**不要互相覆盖文件**，不排斥能力同步。
