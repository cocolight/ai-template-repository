# 本仓库功能路线（ROADMAP）

> 本文件属于**工具层**，记录 `ai-template-repository` 自身的待办。
> 生成的新项目另有一份 `ROADMAP.md`（位于 `template/ROADMAP.md`），那份用于记录该项目的功能清单。

> 状态取值：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须**可判定**（能被命令或明确检查验证）。

| # | 功能 | 状态 | 验收标准 |
|---|------|------|----------|
| 1 | 引入 `template/` 目录，复制改为白名单 | done | 产物不含任何工具层文件、含全部 payload 文件；由 `ci.yml` 的 smoke test 判定 |
| 2 | 工具层文档去占位化 | done | `CHANGELOG.md` 的 `Unreleased` 为本仓库真实记录；其余文档无「待填 / TODO / 待补充」。**注**：`README.md` / `AGENTS.md` / `TEMPLATE.md` 里的 `{{PROJECT_NAME}}` 是描述占位符机制的说明文字，**不属占位符残留，不得删除** |
| 3 | 修 `template/docs/configuration.md` 引用 `TEMPLATE.md` 的死链 | done | 产物内文档引用全部可达；由 `ci.yml` 的「产物内文档死链检查」判定 |
| 4 | 开工清单的路径与 `template/` 实际保持一致 | done | `TEMPLATE.md` 开工清单提到的 7 个文件均在 `template/` 下真实存在（2026-10-05 人工核对：AGENTS / README / ROADMAP / CONTRIBUTING / build.yml / architecture / configuration） |
| 5 | 多技术栈模板变体（`template/` 拆分为多个骨架） | planned | 能用 `--variant rust` 之类的选项生成不同技术栈的骨架 |
| 6 | 清单与仓库现状的自动一致性检查 | planned | `ci.yml` 校验 `TEMPLATE.md` 开工清单提到的文件在 `template/` 下均存在，替代第 4 项的人工核对 |

## 已知取舍

| 取舍 | 原因 |
|------|------|
| 不维护工具层 ADR | `docs/adr/` 已整体移入 `template/`，属生成物；本仓库的架构决策记在 `CHANGELOG.md` |
| 关闭 GitHub Template 标记 | GitHub 打包整个仓库，「Use this template」会把工具层文件带进新项目；白名单只对 `template-init.sh` 生效。代价是失去「网页一键生成」 |
| `example/` 与 `template/` 的内容同步靠人工 | 二者要展示「填空前后」的差异，不适合自动生成 |
