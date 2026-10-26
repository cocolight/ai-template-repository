# 本仓库功能路线（ROADMAP）

> 本文件属于**工具层**，记录 `ai-template-repository` 自身的待办。
> 生成的新项目另有一份 `ROADMAP.md`（位于 `template/blank/ROADMAP.md`），那份用于记录该项目的功能清单。

> 状态取值：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须**可判定**（能被命令或明确检查验证）。

| # | 功能 | 状态 | 验收标准 |
|---|------|------|----------|
| 1 | 引入 `template/` 目录，复制改为白名单 | done | 产物不含任何工具层文件、含全部 payload 文件；由 `ci.yml` 的 smoke test 判定 |
| 2 | 工具层文档去占位化 | done | `CHANGELOG.md` 的 `Unreleased` 为本仓库真实记录；其余文档无「待填 / TODO / 待补充」。**注**：`README.md` / `AGENTS.md` / `TEMPLATE.md` 里的 `{{PROJECT_NAME}}` 是描述占位符机制的说明文字，**不属占位符残留，不得删除** |
| 3 | 修 `template/blank/docs/engineering/configuration.md` 引用 `TEMPLATE.md` 的死链 | done | 产物内文档引用全部可达；由 `ci.yml` 的「产物内文档死链检查」判定 |
| 4 | 开工清单的路径与 `template/` 实际保持一致 | done | 由第 5 项的 CI step 持续保证（2026-10-05 首次人工核对：AGENTS / README / ROADMAP / CONTRIBUTING / build.yml / architecture / configuration 共 7 个文件均在 `template/blank/` 下） |
| 5 | 清单与仓库现状的自动一致性检查 | done | `ci.yml` 的「开工清单与 payload 一致性」step 双向校验：对每个变体（blank / general）循环，payload 权威清单里的文件都存在，且变体目录下每个非 `.gitkeep` 文件都在清单里 |
| 6 | 多技术栈模板变体（`--variant`） | dropped | 技术栈维度的变体暂不做（理由同上）。注：**内容维度的变体**（blank / general）已实现，见 #9 |
| 7 | 补齐发版（tag / Release）约束，并明确 `template/` → 根仓库的能力同步约定 | done | `template/blank/AGENTS.md` §3「发版」/ §4 红线 / §8 坐标表 / §9 矩阵 + 新增 `template/blank/docs/engineering/releasing.md`，覆盖前置条件、命名三要素、步骤顺序、常见错误；根 `AGENTS.md` §3「发版」与新增 §8「同改矩阵」承载同一能力（工具层视角）。由 `ci.yml` 的「开工清单与 payload 一致性」和「产物内文档死链检查」判定不引入回归 |
| 8 | 产物文档分层：工程协作文档收进 `docs/engineering/`，`docs/` 根层让给项目文档 | done | `template/blank/docs/` 下除 `engineering/` 外无模板预置文件；`docs/` 下任一位置的引用均可达（由「产物内文档死链检查」判定）；`ci.yml` 的 payload 权威清单与每个变体目录（`template/blank/`、`template/general/`）内容双向一致；`TEMPLATE.md` 的「模板包含什么」表与自检正向断言列表同步；产物 `README.md` 与 `AGENTS.md` §1 中含这条分工 |
| 9 | 模板支持多内容变体（blank / general），`template-init.sh` 交互选择 | done | `template/` 下每个子目录是一个变体；脚本自动发现变体并以 `--template` 指定（非交互）或交互菜单选择（交互）；由 `ci.yml` 的「仓库结构自检」保证至少 blank/general 两个变体、各变体 payload 清单一致，且「开工清单与 payload 一致性」对每个变体双向校验 |

## 已知取舍

| 取舍 | 原因 |
|------|------|
| `docs/` 根层让给项目文档 | 模板的工程协作文档统一收进 `docs/engineering/`。代价是预置文件不再位于 `docs/` 根层（与 MkDocs / Docusaurus 等把 `docs/` 当文档根的默认略有出入），换来的是「模板在 `docs/` 下只占一个目录」这条**无例外的机械规则** —— 判定只需看路径，不必记保护名单 |
| 不维护工具层 ADR | ADR 整体属 payload（`template/blank/docs/engineering/adr/`）；本仓库的架构决策记在 `CHANGELOG.md` |
| 关闭 GitHub Template 标记 | GitHub 打包整个仓库，「Use this template」会把工具层文件带进新项目；白名单只对 `template-init.sh` 生效。代价是失去「网页一键生成」 |
| `example/` 与 `template/` 的内容同步靠人工 | 二者要展示「填空前后」的差异，不适合自动生成 |
| `template/<变体>/` → 根仓库的能力同步靠人工 | 两份 `AGENTS.md` 受众不同，同一能力需按各自视角表述，不适合逐字复制。机器只能兜住最低一层：`ci.yml` 的 changelog 门禁要求改 `template/` 下任一变体必须记根 `CHANGELOG.md`；「是否已同步规则」由根 `AGENTS.md` §8 同改矩阵约束 |
