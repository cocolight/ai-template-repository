# 这是一个「面向 AI 协作开发」的项目模板

本仓库是项目模板。新项目请用它生成一个**干净、独立、默认分支为 `main`** 的新仓库。

## 生成新项目（推荐）

```bash
# ① 克隆模板仓库到本地（目录名自取，示例为 my-project）
git clone <本仓库地址> my-project

# ② 进入克隆下来的模板仓库
cd my-project

# ③ 生成新项目，参数是「新项目路径」
#    可指向尚不存在的目录（脚本会创建）；必须在模板仓库之外
./scripts/template-init.sh ../my-app
```

| 命令 | 作用 |
|------|------|
| `git clone <本仓库地址> my-project` | 把模板仓库克隆到本地 `my-project/`（此目录只是"蓝本"，用完可删） |
| `cd my-project` | 进入模板仓库；脚本按当前所在的仓库定位模板根，**必须在仓库内执行** |
| `./scripts/template-init.sh ../my-app` | 以模板为蓝本，在 `../my-app` 生成新项目：复制文件（排除模板自用内容）、替换 `{{PROJECT_NAME}}`/`{{YEAR}}`、`git init -b main` 并创建首次提交 |

上面第 ③ 步里的路径就是新项目的位置，**不要**填在模板仓库内部——脚本会拒绝并报错（防止自我复制、误删模板的 `.git`）。

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

- [ ] 运行 `template-init.sh` 生成项目
- [ ] 填写 `AGENTS.md` §2 常用命令表
- [ ] 填写 `README.md` 的安装 / 运行 / 测试命令
- [ ] 在 `ROADMAP.md` 写入首批功能与**可判定的**验收标准
- [ ] 按技术栈补全 `.github/workflows/build.yml`
- [ ] 在 GitHub 上把 `main` 设为保护分支、开启 required status checks
- [ ] 按 [docs/configuration.md](docs/configuration.md) §5 逐项核对配置

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
