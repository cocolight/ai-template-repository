# Changelog

本文件记录 **本仓库自身**（`ai-template-repository`）的变更。
生成的新项目另有一份 `CHANGELOG.md`（位于 `template/CHANGELOG.md`），那份用于记录该项目自己的变更。

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与
[语义化版本](https://semver.org/lang/zh-CN/)。

> 条目一行说清「改了什么」，一条一事，单条不超过 150 字符（CI 断言）。取舍只在非显而易见时
> 在条目末尾用「（理由：…）」附**一句话**，多数条目不带理由；不写破折号插入语与推导叙事。
> 本仓库不维护工具层 ADR，重大决策写进条目或 `ROADMAP.md` 的「已知取舍」。

## [Unreleased]

### 新增

- CHANGELOG 条目体积断言进 CI：两层 workflow 断言单条 ≤ 150 字符

- 发版前置补版本节复核：Release 正文取自版本节，发版前过一遍 §4 写作负面清单

### 变更

- CHANGELOG 条目写法收紧：「（理由：…）」一句话、只给非显而易见取舍，多数条目不带理由，不写破折号插入语（理由：0.3.0 发布说明曾整节辩护墙化）

## [0.3.0] - 2026-10-28

### 新增

- 测试质量基线进 DoD：`template/docs/engineering/definition-of-done.md` 新增「测试质量基线」一节（断言行为而非实现、测试名说清场景、拒绝空转断言），伪完成信号补「恒真断言凑数」，两层 `AGENTS.md` §5 同步

- 「并发协作实机制」「性能基线」两项记入 `ROADMAP.md`「已知取舍」，各附原因与代价

- 两层 `AGENTS.md` 增补「决策即时沉淀」提醒级红线：重要取舍随改动记 `CHANGELOG.md` 条目理由或新增 ADR，不依赖会话记忆

- example/python 示范依赖方向门禁：拆成入口 / 业务逻辑 / 基础设施三层（main / domain / storage），import-linter 分层合同与纯净合同接入 CI，`architecture.md` §2 加坐标指向

- 常驻上下文体积阈值进 CI：两层 `AGENTS.md` 各不超过 200 行，超限先拆详细版下沉详细文档，规则写入两层 `AGENTS.md` §4 提醒级红线（理由：200 给实际项目填实留余量，150 会在填实阶段误伤）

- `template/docs/engineering/configuration.md` 新增 §5「依赖更新与漏洞防护」，原 §5–§7 顺延，`THIRD-PARTY.md` 补版本同步与漏洞响应规则（理由：许可证登记只覆盖合规，依赖的漏洞与版本维护此前无任何机制）

- 「文档写给人看」条目扩充负面清单：破折号插入语成墙、编号癖与巨型长条目、辩护式长括号、虚构历史、拟人化修辞、营销式标题、过程叙事（理由：只写正面要求时「什么算 AI 味」没有判据）

- CI 按改动范围触发 example 检查：新增 Change detection job，PR 只跑改动涉及的示例，push 到 main 全量兜底，断言与检查命令不变（理由：Rust 示例含全量 cargo 构建，未改动的示例白跑拖慢每个 PR）

## [0.2.0] - 2026-10-28

### 新增

- `template/THIRD-PARTY.md`：第三方依赖许可证登记，引入直接依赖时登记许可证（SPDX）、用途与是否随分发
- `template/.github/pull_request_template.md`：PR 描述骨架，含 CHANGELOG 检查项
- `template/docs/engineering/releasing.md`：发版流程文档，覆盖前置条件、命名、步骤与常见错误
- `template/.github/workflows/build.yml` 新增 `Changelog gate`：feat/fix 改了代码没更新 CHANGELOG 就拦在合并前
- 交付物内容边界纪律：PR、CHANGELOG、文档、注释只写项目内容，不写 AI 运行环境与执行过程
- 写作纪律与小决策留痕：文档写给人看，小决策的理由记在 CHANGELOG 条目末尾
- `template/ROADMAP.md` 归档规则：done/dropped 行累计约 20 条移入 docs/archive/
- `TEMPLATE.md` 开工清单把 `AGENTS.md` §8 坐标表列为硬前置，并加就绪门槛
- `architecture.md` §2 加依赖方向门禁要求，新增 §7 腐化信号与重构触发
- 根 `AGENTS.md` §3 发版流程、§8 同改矩阵：`template/` 的能力改动须同步回根仓库
- 工具层对齐 template 能力：根 ROADMAP 归档规则、CHANGELOG 附理由约定、红线分阻断级/提醒级、根 PR 模板（理由：核心约定要求 template/ 能力同步回根仓库，此前只同步了一部分；坐标表等四项有意不同步，见 PR #29）

### 变更

- 模板预置文档移入 `template/docs/engineering/`，`docs/` 根层留给项目自己的文档（理由：两类文档可变性相反，且 configuration.md 会与产品「配置参考」页撞名）
- `template/AGENTS.md` 把 CHANGELOG 接进工作流、DoD 与同改矩阵
- 发版命名三要素：tag 带 v、Release title 与 tag 相同、CHANGELOG 版本节不带 v
- `template/AGENTS.md` §3 新增发版小节，红线把打 tag、推 tag、建 Release 与 commit/push 一并禁止
- `template/AGENTS.md` §8 版本号坐标行改为可填指引，§9 发版行指向 `docs/engineering/releasing.md`
- `template/README.md` 去模板化，AI 入口移至 `template/CONTRIBUTING.md`
- 发版能力同步到工具层：根 AGENTS §4/§5、两份 CONTRIBUTING 发版入口、`example/` 两份 AGENTS 补发版条目
- 社区健康文件不再预置，仓库公开时从 GitHub Community Standards 套官方模板（理由：预置只能得到 TODO 存根）
- `template/docs/engineering/configuration.md` 新增「文档站与静态发布」一节（理由：docs/ 直接当发布源会把 engineering/ 一并公网可见）

### 修复

- 修 `configuration.md` 一处从未生效的引用：「见 §3」改为「见 §2「行尾」」
- 补齐 `releasing.md` 引入后漏同步的清单枚举
- `Changelog gate` 的 diff 基准改用 merge-base，修掉 main 前进时的假绿，`build.yml` 同名 job 同步修正
- 占位符残留检查精确到 `{{PROJECT_NAME}}` / `{{YEAR}}`，不再误伤 GitHub Actions 的 `${{ }}`

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
