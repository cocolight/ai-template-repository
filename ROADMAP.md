# 本仓库功能路线（ROADMAP）

> 本文件属于**工具层**，记录 `ai-template-repository` 自身的待办。
> 生成的新项目另有一份 `ROADMAP.md`（位于 `template/ROADMAP.md`），那份用于记录该项目的功能清单。

> 状态取值：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须**可判定**（能被命令或明确检查验证）。
>
> **归档规则**：`done` / `dropped` 行累计约 20 条时，把最旧的移入 docs/archive/ 目录下的 `roadmap.md`
> （按需创建该目录；移动而非删除，历史可追溯）；本表保留未完成行与最近完成项。
> 归档不改写任何行的内容与验收标准。

| # | 功能 | 状态 | 验收标准 |
|---|------|------|----------|
| 1 | 引入 `template/` 目录，复制改为白名单 | done | 产物不含任何工具层文件、含全部 payload 文件；由 `ci.yml` 的 smoke test 判定 |
| 2 | 工具层文档去占位化 | done | `CHANGELOG.md` 的 `Unreleased` 为本仓库真实记录；其余文档无「待填 / TODO / 待补充」。**注**：`README.md` / `AGENTS.md` / `TEMPLATE.md` 里的 `{{PROJECT_NAME}}` 是描述占位符机制的说明文字，**不属占位符残留，不得删除** |
| 3 | 修 `template/docs/engineering/configuration.md` 引用 `TEMPLATE.md` 的死链 | done | 产物内文档引用全部可达；由 `ci.yml` 的「产物内文档死链检查」判定 |
| 4 | 开工清单的路径与 `template/` 实际保持一致 | done | 由第 5 项的 CI step 持续保证（2026-10-05 首次人工核对：AGENTS / README / ROADMAP / CONTRIBUTING / build.yml / architecture / configuration 共 7 个文件均在 `template/` 下） |
| 5 | 清单与仓库现状的自动一致性检查 | done | `ci.yml` 的「开工清单与 payload 一致性」step 双向校验：payload 权威清单里的文件都存在，且 `template/` 下每个非 `.gitkeep` 文件都在清单里 |
| 6 | 多技术栈模板变体（`--variant`） | dropped | 2026-10-05 决定暂不做。素材现成（`example/` 下已有 Python 与 Rust 两份填好的骨架），但需先定「变体怎么组织 / 支持哪几个技术栈 / `example/` 定位是否变」三个决策。优先做无争议的补缺口类改动 |
| 7 | 补齐发版（tag / Release）约束，并明确 `template/` → 根仓库的能力同步约定 | done | `template/AGENTS.md` §3「发版」/ §4 红线 / §8 坐标表 / §9 矩阵 + 新增 `template/docs/engineering/releasing.md`，覆盖前置条件、命名三要素、步骤顺序、常见错误；根 `AGENTS.md` §3「发版」与新增 §8「同改矩阵」承载同一能力（工具层视角）。由 `ci.yml` 的「开工清单与 payload 一致性」和「产物内文档死链检查」判定不引入回归 |
| 8 | 产物文档分层：工程协作文档收进 `docs/engineering/`，`docs/` 根层让给项目文档 | done | `template/docs/` 下除 `engineering/` 外无模板预置文件；`docs/` 下任一位置的引用均可达（由「产物内文档死链检查」判定）；`ci.yml` 的 payload 权威清单与 `template/` 内容双向一致；`TEMPLATE.md` 的「模板包含什么」表与自检正向断言列表同步；产物 `README.md` 与 `AGENTS.md` §1 中含这条分工 |
| 9 | 工程文档与 AI 工作区合并为 `.agents/`，`docs` 全归使用者 | done | 产物不含 `docs/`；`.agents/` 下每篇文档都在 `AGENTS.md` §1 路由表内（`scripts/check-fast.sh` 判定）；产物初始状态能跑通自身门禁 |
| 10 | 提交前门禁与发版守卫 | done | `scripts/check-fast.sh` 在本地钩子与 CI 共用同一份，断言不复制进 `ci.yml`；`build.yml` 的 `Release guard` 在 tag 推送时校验版本节与 ROADMAP 状态 |
| 11 | payload 清单独立为 `payload.txt` | done | 门禁与 `ci.yml` 都读同一份清单，`CHECKLIST` 不再硬编码在 workflow 里 |
| 12 | 工具层文档对 payload 的路径引用纳入门禁 | done | 根 `scripts/check-fast.sh` 判定：反引号内 `template/<路径>` 必须存在；CHANGELOG 全篇与 ROADMAP 的 `done` / `dropped` 行豁免（历史记录不改写）。注入旧路径实测返回 `exit=1` |

## 已知取舍

| 取舍 | 原因 |
|------|------|
| `docs` 全归使用者，工程文档进 `.agents/` | 取代 0.2.0 的 `docs/engineering/` 方案。判据只有一条：不读它 AI 会做错事吗？会 → `.agents/`，不会 → `docs`。规则比「模板在 `docs` 下只占一个目录」更强：模板一个字都不往 `docs` 放。代价：`.agents/` 是点目录，`grep` 默认搜不到，寻址只能靠 `AGENTS.md` §1 路由表 |
| 不预置具体 skill，只给契约 | `.agents/skills/README.md` 定契约，`check-fast.sh` 校验 frontmatter，内容留给项目自建。预置只会得到一份写着 TODO 的存根，与「不预置社区健康文件」同一理由。厂商目录（`.claude/`、`.cursor/`）同理不预置，只给映射配方 |
| 不维护工具层 ADR | ADR 整体属 payload（`template/.agents/adr/`）；本仓库的架构决策记在 `CHANGELOG.md` |
| 关闭 GitHub Template 标记 | GitHub 打包整个仓库，「Use this template」会把工具层文件带进新项目；白名单只对 `template-init.sh` 生效。代价是失去「网页一键生成」 |
| `example/` 与 `template/` 的内容同步靠人工 | 二者要展示「填空前后」的差异，不适合自动生成 |
| `template/` → 根仓库的能力同步靠人工 | 两份 `AGENTS.md` 受众不同，同一能力需按各自视角表述，不适合逐字复制。机器只能兜住最低一层：`ci.yml` 的 changelog 门禁要求改 `template/` 必须记根 `CHANGELOG.md`；「是否已同步规则」由根 `AGENTS.md` §8 同改矩阵约束 |
| 不做并发协作的实机制（写锁 / 责任分配自动化） | 「一分支一写入者 + 动手前 fetch + 冲突即停」的约定已覆盖单人加 AI 的主流场景；真做锁机制需要 bot 或状态文件这类基础设施，复杂度与收益不匹配。代价：多执行者高度并行写同一文件时仍靠人工协调 |
| 不做性能基线与性能门禁 | 性能指标因项目而异（延迟 / 吞吐 / 内存，阈值各不相同），模板预置阈值没有普适意义；各项目应在 `ROADMAP.md` 验收标准里按需自定可判定的性能条件。代价：性能回退无机械兜底，靠验收标准与人工发现 |
