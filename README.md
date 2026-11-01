# ai-template-repository

> 「面向 AI 协作开发」的项目模板 —— 用一条命令生成一个干净的新项目骨架。
>
> 🤖 使用 AI 编码助手时，请先阅读 [AGENTS.md](AGENTS.md)（维护本仓库的行为规则）。

## 这个仓库是什么

它由两层组成：

| 层 | 位置 | 是什么 | 会进新项目吗 |
|----|------|--------|--------------|
| **工具层** | 仓库根目录 | 本仓库自己的介绍、生成脚本、维护说明、活文档示例 | ❌ 不会 |
| **数据层** | [`template/`](template/) | 项目骨架（`AGENTS.md` / `README.md` / `docs/` / CI 骨架 …） | ✅ 会，整目录复制 |

生成新项目时**只有 `template/` 下的内容会被复制**。工具层文件在物理上就不在
`template/` 里，所以往仓库根目录加任何新文件，都不会污染新项目。

## 生成新项目

```bash
# ① 克隆本模板到本地（目录名自取，示例为 my-project）
git clone https://github.com/cocolight/ai-template-repository.git my-project

# ② 进入模板仓库
cd my-project

# ③ 生成新项目，参数是「新项目路径」（可指向尚不存在的目录，必须在仓库之外）
./scripts/template-init.sh ../my-app
```

它会复制 `template/` 的内容、替换 `{{PROJECT_NAME}}` / `{{YEAR}}` 占位符、
`git init`（默认分支 `main`）并创建首次提交。

选项：`--dry-run`（只看将做什么）、`--force`（允许写入非空目录）、`-h`。

> 若你 fork 或改名了本模板，请把上面的克隆地址换成你自己的仓库地址。

## 目录结构

```
ai-template-repository/
├── README.md            # 本文件：仓库自述
├── AGENTS.md            # 维护本仓库的行为规则
├── TEMPLATE.md          # 模板使用手册：开工清单、哪些文件不能改
├── payload.txt          # payload 权威清单：门禁与 CI 都读它，不要再硬编码第二份
├── CONTRIBUTING.md      # 贡献指南 + 维护自检命令
├── ROADMAP.md           # 本仓库功能路线
├── CHANGELOG.md         # 本仓库变更记录
├── LICENSE              # 本仓库许可证
├── scripts/
│   ├── template-init.sh # 项目生成器
│   └── check-fast.sh    # 工具层 + payload 门禁（本地钩子与 CI 共用）
├── .githooks/
│   └── pre-commit       # 提交前门禁（git config core.hooksPath .githooks）
├── .github/
│   ├── workflows/
│   │   └── ci.yml       # 校验脚本 + 按改动范围跑 example/ 的 lint 与测试
│   └── pull_request_template.md  # PR 描述骨架（工具层版）
├── example/             # 填好的示例项目（Python / Rust），仅供参照，不会进新项目
└── template/            # ★ 项目骨架，整目录复制进新项目
    ├── README.md / AGENTS.md / ROADMAP.md / CONTRIBUTING.md / CHANGELOG.md
    ├── LICENSE / THIRD-PARTY.md / .gitignore / .gitattributes
    ├── .agents/         # 工程协作文档：架构、配置、DoD、发版、扩展点、ADR、skills
    ├── .githooks/       # 提交前门禁
    ├── .github/workflows/build.yml
    ├── scripts/check-fast.sh
    └── src/  tests/     # 空目录占位
```

## 想改模板内容？

改 `template/` 下的文件。**不需要改 `scripts/template-init.sh`** —— 复制是白名单，
新文件放进去就会被带过去。

| 想做的事 | 放哪 |
|---------|------|
| 让文件进新项目 | `template/` 下，并在 [`payload.txt`](payload.txt) 加一行 |
| 只服务于本仓库 | 仓库根目录 |
| 给新项目换 CI 骨架 | `template/.github/workflows/` |
| 给本仓库加检查 | `scripts/check-fast.sh`（本地钩子与 CI 共用）或 `.github/workflows/ci.yml` |

`payload.txt` 是**正向清单**（列有什么），不是排除清单。它原本硬编码在 `ci.yml` 的一个 step 里，现在挪成独立文件，负担没有增加，只是位置集中、门禁与文档都能读同一份。生成器仍然不用改：复制是白名单，清单只服务于校验。

## 下一步

- 生成项目后要做什么 → [TEMPLATE.md](TEMPLATE.md)「新项目开工清单」
- 改完模板如何自检 → [CONTRIBUTING.md](CONTRIBUTING.md)
- 想看骨架填满是什么样 → [`example/`](example/)

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
