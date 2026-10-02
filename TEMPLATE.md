# 这是一个「面向 AI 协作开发」的项目模板

本仓库是项目模板。新项目请用它生成一个**干净、独立、默认分支为 `main`** 的新仓库。

## 生成新项目（推荐）

```bash
# ① 克隆模板仓库到本地（目录名自取，示例为 my-project；HTTPS 形式无需配置 SSH key）
git clone https://github.com/cocolight/ai-template-repository.git my-project

# ② 进入克隆下来的模板仓库
cd my-project

# ③ 生成新项目，参数是「新项目路径」
#    可指向尚不存在的目录（脚本会创建）；必须在模板仓库之外
./scripts/template-init.sh ../my-app
```

| 命令 | 作用 |
|------|------|
| `git clone https://github.com/cocolight/ai-template-repository.git my-project` | 把模板仓库克隆到本地 `my-project/`（此目录只是"蓝本"，用完可删） |
| `cd my-project` | 进入模板仓库；脚本按当前所在的仓库定位模板根，**必须在仓库内执行** |
| `./scripts/template-init.sh ../my-app` | 以模板为蓝本，在 `../my-app` 生成新项目：复制文件（排除模板自用内容）、替换 `{{PROJECT_NAME}}`/`{{YEAR}}`、`git init -b main` 并创建首次提交 |

上面第 ③ 步里的路径就是新项目的位置，**不要**填在模板仓库内部——脚本会拒绝并报错（防止自我复制、误删模板的 `.git`）。

> 若你 fork 或改名了本模板，请把上面的克隆地址换成你自己的仓库地址。

`template-init.sh` 会：

- 复制模板内容到新路径，**排除** `example/`、`TEMPLATE.md`、脚本自身、模板的 `.git`、本地工具数据 `.workbuddy/`，以及模板仓库自用的 CI（`.github/workflows/ci.yml`）；
- 把 `{{PROJECT_NAME}}` 与 `{{YEAR}}` 占位符替换为实际值；
- 在新目录 `git init`（默认分支 `main`）并创建首次提交。

选项：`--dry-run`（只看将做什么，不写文件）、`--force`（允许写入非空目录）。

## 手动使用（不用脚本）

1. 复制除 `example/`、`TEMPLATE.md`、`scripts/template-init.sh`、`.github/workflows/ci.yml`、`.workbuddy/` 外的全部文件；
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
| `docs/configuration.md` | 仓库与项目配置说明（环境 / Git / 行尾 / CI / 分支保护） |
| `docs/definition-of-done.md` | 完成定义（DoD） |
| `docs/adr/` | 架构决策记录（含模板与首条记录） |
| `.gitattributes` | 强制库内 LF，防止脚本在 Windows 被检出为 CRLF |
| `.github/workflows/build.yml` | CI 门禁骨架（需按技术栈补全） |
| `example/` | 两个填好的示例（Python / Rust），**不会**复制进新项目 |

## 新项目开工清单

按顺序做。第 1–8 步是「改文件」，第 9 步是「改外部设置」。每条写明 **改哪个文件 / 改什么 / 怎么算改对**。

| # | 文件 | 改什么 | 怎么算改对 |
|---|------|--------|-----------|
| 1 | 技术栈自带的清单文件（`Cargo.toml` / `pyproject.toml` / `package.json` …） | 先落代码骨架（`cargo init` / `uv init` 等），把项目名、版本、`description`、`license` 填成真实值 | 项目能编译 / 启动 |
| 2 | `AGENTS.md` | §0 把「一句话说明本项目做什么」写实；**§2 五行命令全部填上**（安装依赖 / 运行 / 测试 / Lint / 格式化检查） | 表里不再有「（待填）」 |
| 3 | `README.md` | 开头的简介、`## 功能` 列表，以及 3 处 `<!-- TODO -->`（安装 / 运行 / 测试命令） | 文件里不再有 `TODO` |
| 4 | `ROADMAP.md` | 写首批功能；每条「验收标准」必须**能被命令或明确检查验证** | 每条你都能说出"怎么验证它完成了" |
| 5 | `.github/workflows/build.yml` | 把占位 step 换成真实命令（文件里已附 Rust / Python 的 TODO 注释可抄） | 本地跑一遍同样的命令，全绿 |
| 6 | `docs/architecture.md` | §1 补目录分层；§3 补该语言的错误处理策略 | 与代码实际结构一致 |
| 7 | `CONTRIBUTING.md` | 「本地检查」那一行填成本项目的真实命令 | 与 `AGENTS.md` §2 完全一致 |
| 8 | 占位文件 `*.gitkeep` | 目录里有了真实文件后，删 `src/.gitkeep`、`tests/.gitkeep`、`docs/.gitkeep`；**`scripts/.gitkeep` 保留**（否则 `scripts/` 目录会消失） | `git ls-files '*gitkeep'` 只剩 `scripts/.gitkeep` |
| 9 | GitHub 仓库设置（不是文件） | 启用 Actions → 收紧 Workflow permissions → 为 `main` 开分支保护 + required status checks | 见 [docs/configuration.md](docs/configuration.md) §4 |

第 9 步的坑：required status checks 的名字**必须等于 workflow 里的 job 名**。`build.yml` 的 job id 是 `test` 且未设 `name`，所以在列表里搜 `test`；一旦改了 job 名，这里要同步改。

**开工前先跑这两条自检**：

```bash
# 1) 占位符应已被脚本全部替换 —— 无输出即为干净
grep -rn "{{" . --exclude-dir=.git

# 2) 脚本索引权限（Linux / macOS 克隆后 ./x.sh 才不会 Permission denied）
git ls-files -s scripts/
```

环境 / Git / 行尾 / CI / 分支保护的完整核对清单见 [docs/configuration.md](docs/configuration.md) §5。

## 哪些文件不要改

新项目里有几处内容是「判定基准」或「安全底线」，改了整套规范就失效。分四类。

### 一、完全不要动

| 文件 | 为什么不能改 | 要变怎么办 |
|------|------------|-----------|
| `LICENSE` | MIT 正文是法律文本，逐字固定；开头的年份与项目名已由脚本填好 | 换许可证 = 整体替换成另一份官方文本，不做局部编辑 |
| `.gitattributes` | 它强制库内 LF；改了会让 Windows 检出脚本变成 CRLF（报 `bad interpreter`） | 只增不改，且必须保留 `*.sh text eol=lf` |
| `docs/adr/` 中「已接受」的记录 | 决策记录的价值就在于不可篡改，改了就无从回溯当时为什么这样定 | 新增一条 ADR 说明变更，旧记录原样保留 |

### 二、可以补，但不得削弱

| 文件 / 位置 | 不许做的事 |
|------------|-----------|
| `AGENTS.md` §1 上下文入口、§3 工作流、§4 红线、§5 DoD、§7 安全 | 不得删条目、不得放宽（例如把"不得删除测试"删掉）。§0 与 §2 是留给项目搭建者填的，随意改 |
| `docs/definition-of-done.md` | 不得为了让某个功能"达标"而放宽条件 —— 这正是模板定义的「伪完成」 |
| `.github/workflows/build.yml` | 要填真实命令，但不得删掉 lint / test 步骤、不得改成 `|| true`、不得把失败降级成警告 |
| `.gitignore` | 可以追加语言相关规则，但不得删除密钥段（`.env`、`*.key`、`*.pem`） |

确需调整流程类条文（例如 `CONTRIBUTING.md` 的分支策略）时，请在 PR 里写明理由，并同步 `AGENTS.md`，避免两份文档互相打架。

### 三、只追加，不回头改

| 文件 | 规则 |
|------|------|
| `CHANGELOG.md` | 已发布版本的条目不再修改；新改动追加到 `Unreleased` |
| `ROADMAP.md` 中已标 `done` 的行 | 状态可回溯，但不要删行，也不要改写已完成功能的验收标准 |

### 四、不在你的项目里（别去找）

`TEMPLATE.md`、`scripts/template-init.sh`、`.github/workflows/ci.yml`、`example/`、`.workbuddy/` 是模板仓库的自用文件，生成新项目时已被排除，新项目里**根本不存在**。

## 维护模板仓库自身

**不会被复制进新项目的文件（排除清单）**：`.git`、`.workbuddy/`、`example/`、`TEMPLATE.md`、`scripts/template-init.sh`、`.github/workflows/ci.yml`。
若新增"仅供模板自用"的文件，记得同步 `scripts/template-init.sh` 里的排除逻辑，并更新本节。

**必须保持的仓库性质**：

| 性质 | 原因 | 检查 |
|------|------|------|
| 库内一律 LF | Windows 检出脚本变 CRLF 会导致 `bad interpreter` | `git check-attr eol -- scripts/template-init.sh` → `eol: lf` |
| `scripts/*.sh` 索引模式 `100755` | 否则 CI 的 `./scripts/template-init.sh` 报 `Permission denied`（Windows 上 `core.filemode=false`，本地测不出） | `git ls-files -s scripts/` |
| 交付文件里不写占位符字面 | 生成新项目时，**所有被复制的文件**都会参与占位符替换，文档里写占位符字面会被改写 | 见下方"改完模板后的自检" |

修复权限位丢失：

```bash
git update-index --chmod=+x scripts/template-init.sh
```

**改完模板后的自检**（在生成产物上检查，模板自用文件本身含占位符，直接 grep 仓库会误报）：

```bash
sh -n scripts/template-init.sh                     # 语法
T=$(mktemp -d)
./scripts/template-init.sh "$T/newproj"            # 真实生成
grep -rn "{{" "$T/newproj" --exclude-dir=.git || echo "OK: 产物无残留占位符"
git -C "$T/newproj" branch --show-current          # 期望 main
# CI 会执行：shellcheck scripts/*.sh + 两个 example 的 lint/test
```
