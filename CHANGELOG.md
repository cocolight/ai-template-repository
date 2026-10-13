# Changelog

本文件记录 **本仓库自身**（`ai-template-repository`）的变更。
生成的新项目另有一份 `CHANGELOG.md`（位于 `template/CHANGELOG.md`），那份用于记录该项目自己的变更。

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与
[语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- `template/.github/pull_request_template.md`：PR 描述骨架（做了什么 / 关联 ROADMAP 行 / 检查项，含 CHANGELOG）
- `template/docs/engineering/releasing.md`：发版流程文档 —— 前置条件、命名三要素、步骤顺序、常见错误、预发布约定
- 根 `AGENTS.md` §8「同改矩阵」：把核心约定「约束新建项目以 `template/` 为准；`template/` 更新后能力必须同步回根仓库」写成可查的矩阵，并注明同步是单向的、同步的是能力而非逐字复制
- 根 `AGENTS.md` §3「发版」：本仓库自身的发版流程（工具层视角，与 `template/docs/engineering/releasing.md` 承载同一能力）

### Changed

- **产物文档重新分层**：`template/docs/` 下模板预置的 5 项（`architecture.md` / `configuration.md` / `definition-of-done.md` / `releasing.md` / `adr/`）整体移入 **`template/docs/engineering/`**，把 `docs/` 根层让给**项目自己的文档**。原因是原先两类文档压在同一个平面：一类是「判定基准」（受红线与同改矩阵约束、生命周期稳定），一类面向使用者（随版本频繁重写）——读者与可变性正好相反；且 `docs/configuration.md` 与产品文档里几乎必然出现的「配置参考」页会撞名。现规则为「**模板在 `docs/` 下只占 `docs/engineering/` 一个目录**」，机械可判定、无例外。同步改写全部引用（13 个文件）以及 `ci.yml` 的 payload 权威清单 / smoke 正向断言 / 仓库结构自检，并把这条分工写进 `template/README.md` 的目录结构、`template/AGENTS.md` §1 与 `TEMPLATE.md`。CHANGELOG 中指向这些文件的路径一并改为当前位置，避免留下已不存在的路径。
- `template/AGENTS.md` 把 CHANGELOG 接进工作流 / DoD / 同改矩阵，堵新项目 CHANGELOG 欠账
- `template/AGENTS.md` §9 补齐发版命名三要素（tag 带 v、release title 跟 tag、CHANGELOG 不带 v）
- `template/AGENTS.md` §3 新增「发版」小节（前置条件 / 命名 / 顺序）；§4 阻断级红线把 `tag`、`push --tags`、创建 Release 与 `commit` / `push` 并列禁止 —— 此前只禁 commit/push，AI 可辩称「规则没禁止打 tag」
- `template/AGENTS.md` §8 的「版本号」坐标行由空白「（待填）」改为可填的中性指引（指向唯一版本号事实源，且不许另抄一份）
- `template/AGENTS.md` §9 发版行改为指向 `docs/engineering/releasing.md`，并补「§8 坐标表指向的版本号事实源已同步」
- `template/README.md` 去模板化：删「🤖 AI 编码助手」引导行、收敛「开发约定」，AI 入口移至 `template/CONTRIBUTING.md`
- 同步该能力到工具层：根 `AGENTS.md` §4 红线（同禁 tag / Release）与 §5 DoD（新增「改了 `template/` 的规则能力已同步根 `AGENTS.md`」判据）、根 `CONTRIBUTING.md` 与 `template/CONTRIBUTING.md` 各增发版入口、`example/` 两份 `AGENTS.md` 各补发版条目
- 说清「社区健康文件」的位置：`template/docs/engineering/configuration.md` §4 新增「仓库公开时再补的社区健康文件」小节、§5 补一条可选勾选项，`TEMPLATE.md` 第 8 步后加一句指针 —— 模板**有意不预置** `CODE_OF_CONDUCT` / `SECURITY` / `SUPPORT` / `ISSUE_TEMPLATE`（四者都需项目级信息，预置只会得到 TODO 存根），改为在仓库要公开时用 GitHub 的 Insights → Community Standards 一键套官方模板

### Fixed

- 补齐 `docs/engineering/releasing.md` 引入后需要同步的三处枚举：`TEMPLATE.md` 的「模板包含什么」表与「哪些文件不要改」表、`TEMPLATE.md` 自检脚本的正向断言列表、`ci.yml` 的 payload 权威清单与 smoke 正向断言（漏同步会让「开工清单与 payload 一致性」step 直接失败）

## [0.1.0] - 2026-10-05

### Added

- `ci.yml` 新增「产物内文档死链检查」step：解析产物里 Markdown 链接与反引号路径引用，验证目标存在，防止新增文档引入死链
- `ci.yml` 新增「payload 索引模式」与「仓库结构自检」两个 step，守住「根目录是工具层、`template/` 是数据层」这个核心性质
- `ci.yml` 新增「开工清单与 payload 一致性」step：双向校验 payload 权威清单与 `template/` 实际内容，把 `ROADMAP` 第 4 项的人工核对固化为门禁
- 工具层补齐 `LICENSE` / `CONTRIBUTING` / `ROADMAP` / `CHANGELOG`，避免根文档出现死链
- `template/AGENTS.md` 融入 FluxDown 式 AI 约束：§4 红线拆「阻断级/提醒级」两级、新增 §8 单一事实源坐标与 §9 同改矩阵、§1 补反漂移提醒

### Changed

- **仓库改为两层结构**：根目录是工具层（介绍 + 生成器 + 维护说明 + 活文档示例），`template/` 是数据层（纯 payload，会被整目录复制进新项目）
- `scripts/template-init.sh` 的复制规则由**黑名单改为白名单** —— 新增工具层文件或 payload 文件都不再需要改脚本
- `scripts/template-init.sh` 的路径变量拆成 `REPO_ROOT`（安全检查基准）与 `TPL_DIR`（复制源）。混用会放过「把新项目写进仓库内部」的误操作，在仓库里生成嵌套 git 仓库
- `TEMPLATE.md` 的「维护模板仓库自身」章节改为白名单语义，原「若新增自用文件，记得同步脚本排除逻辑」的维护负担归零
- 根 `README.md` 与 `AGENTS.md` 改为描述本仓库自身，不再是模板骨架；根 `AGENTS.md` §2 填入本仓库真实命令

### Fixed

- `template/docs/engineering/configuration.md` 删掉对 `TEMPLATE.md` 的引用 —— 该文件属工具层、不随模板复制，此前在每个生成出来的项目里都是死链
- `ci.yml` 的 smoke test 补上**正向断言**：原断言全是否定式，复制阶段整体失效、产物为空时四条全过

### Removed

- 移除 `main` 分支保护里的 `test` 这一项 required status check。它是旧 `build.yml` 的 job id，该文件只是打印警告的空壳（恒绿），随重构移入 `template/` 后不再运行，导致 PR 长期 `BLOCKED`
- 关闭仓库的 GitHub Template 标记。GitHub 打包整个仓库，走「Use this template」会把工具层文件一起带进新项目；白名单只对脚本生效
- 删除冗余的 `docs/.gitkeep`（该目录已有真实文件）
- 多技术栈模板变体（`--variant`）暂不实现。素材现成（`example/` 下已有 Python 与 Rust 两份填好的骨架），但需先定「变体怎么组织 / 支持哪几个技术栈 / `example/` 定位是否变」三个决策，与无争议的补缺口类改动分开

### 兼容性

- **BREAKING**：手抄模板（不用脚本）的用户需改为复制 `template/` 目录，而非仓库根目录
