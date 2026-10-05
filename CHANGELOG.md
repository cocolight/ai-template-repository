# Changelog

本文件记录 **本仓库自身**（`ai-template-repository`）的变更。
生成的新项目另有一份 `CHANGELOG.md`（位于 `template/CHANGELOG.md`），那份用于记录该项目自己的变更。

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与
[语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

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

- `template/docs/configuration.md` 删掉对 `TEMPLATE.md` 的引用 —— 该文件属工具层、不随模板复制，此前在每个生成出来的项目里都是死链
- `ci.yml` 的 smoke test 补上**正向断言**：原断言全是否定式，复制阶段整体失效、产物为空时四条全过

### Removed

- 移除 `main` 分支保护里的 `test` 这一项 required status check。它是旧 `build.yml` 的 job id，该文件只是打印警告的空壳（恒绿），随重构移入 `template/` 后不再运行，导致 PR 长期 `BLOCKED`
- 关闭仓库的 GitHub Template 标记。GitHub 打包整个仓库，走「Use this template」会把工具层文件一起带进新项目；白名单只对脚本生效
- 删除冗余的 `docs/.gitkeep`（该目录已有真实文件）
- 多技术栈模板变体（`--variant`）暂不实现。素材现成（`example/` 下已有 Python 与 Rust 两份填好的骨架），但需先定「变体怎么组织 / 支持哪几个技术栈 / `example/` 定位是否变」三个决策，与无争议的补缺口类改动分开

### 兼容性

- **BREAKING**：手抄模板（不用脚本）的用户需改为复制 `template/` 目录，而非仓库根目录
