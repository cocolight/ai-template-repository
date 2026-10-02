# 这是一个「面向 AI 协作开发」的项目模板

本仓库是项目模板。新项目请用它生成一个**干净、独立、默认分支为 `main`** 的新仓库。

## 生成新项目（推荐）

```bash
git clone <本仓库地址> my-project && cd my-project
./scripts/template-init.sh ../my-app
```

`template-init.sh` 会：

- 复制模板内容到新路径，**排除** `example/`、`TEMPLATE.md`、脚本自身、模板的 `.git`，以及模板仓库自用的 CI（`.github/workflows/ci.yml`）；
- 把 `{{PROJECT_NAME}}` 与 `{{YEAR}}` 占位符替换为实际值；
- 在新目录 `git init`（默认分支 `main`）并创建首次提交。

选项：`--dry-run`（只看将做什么，不写文件）、`--force`（允许写入非空目录）。

## 手动使用（不用脚本）

1. 复制除 `example/`、`TEMPLATE.md`、`scripts/template-init.sh`、`.github/workflows/ci.yml` 外的全部文件；
2. 全局替换 `{{PROJECT_NAME}}` 与 `{{YEAR}}`；
3. 填好 `AGENTS.md` §2「常用命令」表与 `README.md` 的 TODO；
4. `git init -b main && git add -A && git commit -m "chore: initialize project"`。

## 模板包含什么

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | 给 AI 编码助手的规则：上下文入口、常用命令、红线、DoD |
| `README.md` | 项目说明骨架（含 TODO 占位） |
| `ROADMAP.md` | 功能清单 + **验收标准** 列 |
| `CONTRIBUTING.md` | 分支 / 提交 / PR 规范 |
| `docs/architecture.md` | 架构与代码约定 |
| `docs/definition-of-done.md` | 完成定义（DoD） |
| `docs/adr/` | 架构决策记录（含模板与首条记录） |
| `.github/workflows/build.yml` | CI 门禁骨架（需按技术栈补全） |
| `example/` | 两个填好的示例（Python / Rust），**不会**复制进新项目 |

## 新项目开工清单

- [ ] 运行 `template-init.sh` 生成项目
- [ ] 填写 `AGENTS.md` §2 常用命令表
- [ ] 填写 `README.md` 的安装 / 运行 / 测试命令
- [ ] 在 `ROADMAP.md` 写入首批功能与**可判定的**验收标准
- [ ] 按技术栈补全 `.github/workflows/build.yml`
- [ ] 在 GitHub 上把 `main` 设为保护分支、开启 required status checks
