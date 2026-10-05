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
├── CONTRIBUTING.md      # 贡献指南 + 维护自检命令
├── ROADMAP.md           # 本仓库功能路线
├── CHANGELOG.md         # 本仓库变更记录
├── LICENSE              # 本仓库许可证
├── scripts/
│   └── template-init.sh # 项目生成器
├── .github/workflows/
│   └── ci.yml           # 校验脚本 + 跑 example/ 的 lint 与测试
├── example/             # 填好的示例项目（Python / Rust），仅供参照，不会进新项目
└── template/            # ★ 项目骨架，整目录复制进新项目
    ├── README.md / AGENTS.md / ROADMAP.md / CONTRIBUTING.md / CHANGELOG.md
    ├── LICENSE / .gitignore / .gitattributes
    ├── docs/            # 架构、配置、DoD、ADR
    ├── .github/workflows/build.yml
    ├── src/  tests/  scripts/   # 空目录占位
```

## 想改模板内容？

改 `template/` 下的文件。**不需要改 `scripts/template-init.sh`** —— 复制是白名单，
新文件放进去就会被带过去。

| 想做的事 | 放哪 |
|---------|------|
| 让文件进新项目 | `template/` 下 |
| 只服务于本仓库 | 仓库根目录 |
| 给新项目换 CI 骨架 | `template/.github/workflows/` |
| 给本仓库加检查 | `.github/workflows/ci.yml` |

## 下一步

- 生成项目后要做什么 → [TEMPLATE.md](TEMPLATE.md)「新项目开工清单」
- 改完模板如何自检 → [CONTRIBUTING.md](CONTRIBUTING.md)
- 想看骨架填满是什么样 → [`example/`](example/)

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
