# 仓库与项目配置说明

本文面向**由本模板生成的项目**，说明代码之外还需要配置什么：环境、Git、行尾与权限、CI、分支保护。
（模板仓库自身的配置见 `TEMPLATE.md`；AI 的行为规则见 `AGENTS.md`。）

## 1. 环境要求

| 组件 | 要求 | 说明 |
|------|------|------|
| Git | ≥ 2.28 | 需要 `git init -b`、`git branch -m` |
| Shell | POSIX `sh` | 仓库内脚本用 `#!/bin/sh`；Windows 下请用 Git Bash |
| 编码 / 行尾 | UTF-8 / LF | 由 `.gitattributes` 强制，见 §3 |

Windows 说明：所有示例命令均可在 Git Bash 下执行；传入 `C:\...` 形式路径时脚本会调用 `cygpath` 转换（Git for Windows 自带）。

## 2. Git 配置

### 默认分支

`main`。重命名已有仓库：

```bash
git branch -m master main
```

### 提交署名（仓库级）

只影响当前仓库，不改动全局配置：

```bash
git config user.name  "your-name"
git config user.email "you@example.com"
```

### 行尾（最容易踩的坑）

仓库自带 `.gitattributes`，**库内一律以 LF 存储，且它会覆盖你全局的 `core.autocrlf=true`** —— 这是为了防止 shell 脚本在 Windows 检出后变成 CRLF（表现为 `#!/bin/sh^M: bad interpreter`）。

验证某个文件的实际规则：

```bash
git check-attr eol -- scripts/your-script.sh   # 期望输出: eol: lf
```

若克隆后文件已被转成 CRLF，重新归一化：

```bash
git add --renormalize .
git commit -m "chore: normalize line endings"
```

### 文件权限位

shell 脚本在索引中必须是 `100755`，否则 Linux / macOS 上 `./scripts/x.sh` 会报 `Permission denied`（Windows 上看不出来，因为 `core.filemode=false`）。

```bash
git ls-files -s scripts/                       # 期望: 100755 ...
git update-index --chmod=+x scripts/x.sh       # 修复
```

## 3. 目录约定

| 路径 | 用途 |
|------|------|
| `src/` | 源码 |
| `tests/` | 测试 |
| `docs/` | 文档；`docs/adr/` 为架构决策记录 |
| `scripts/` | 辅助脚本 |
| `.github/workflows/` | CI 工作流 |

详见 `docs/architecture.md`；完成标准见 `docs/definition-of-done.md`。

## 4. CI（GitHub Actions）

模板生成的项目只带一个工作流：`.github/workflows/build.yml`，其 `test` job 目前是占位（只打印一条警告）。**第一步是把它改成真实命令**，否则 CI 等于没有。

首次推送到 GitHub 后，需要在仓库设置里补齐三步：

1. **启用 Actions**：Settings → Actions → General → Allow all actions and reusable workflows。
2. **收紧权限**：同页 Workflow permissions 选 *Read repository contents*（与 workflow 里的 `permissions: contents: read` 一致）。
3. **设置分支保护**：Settings → Branches → Add branch protection rule，分支名填 `main`，
   - 勾选 *Require a pull request before merging*
   - 勾选 *Require status checks to pass before merging*，搜索并勾选 **`test`**

   ⚠️ required status checks 的名称必须与 workflow 中的 job 名称一致。`build.yml` 的 job id 是 `test` 且未设 `name`，因此在列表里显示为 `test`。若你改了 job 名，这里要同步改。

在填好 `build.yml` 的真实命令之前，required check 是空转的（永远成功）。

本地检查至少覆盖三步，且与 `AGENTS.md` §2 保持完全一致：**安装依赖 → lint / 格式检查 → 测试**。

**runner 镜像**：`build.yml` 的 `runs-on` 显式写成 `ubuntu-24.04`，而不是 `ubuntu-latest`。跟随 latest 会在 GitHub
切换镜像时（例如迁移到 Ubuntu 26）让 CI 行为突变——系统依赖的包名可能变化，CI 会在你毫无改动的一天突然变红。
钉住版本后，升级时机由你决定，且升级前可以先在分支上验证。

## 5. 落地配置清单

- [ ] 填写 `AGENTS.md` §2「常用命令」表（AI 依赖它）
- [ ] 填写 `README.md` 的安装 / 运行 / 测试命令
- [ ] 在 `ROADMAP.md` 写入首批功能与**可判定的**验收标准
- [ ] 用真实命令替换 `.github/workflows/build.yml` 的占位步骤
- [ ] 确认 `.gitattributes` 已随仓库提交（库内 LF）
- [ ] 确认 shell 脚本索引模式为 `100755`
- [ ] GitHub：启用 Actions、收紧 Workflow permissions
- [ ] GitHub：为 `main` 开启分支保护 + required status checks

## 6. 常见问题

| 现象 | 原因 | 处理 |
|------|------|------|
| `bad interpreter: /bin/sh^M` | 脚本被检出为 CRLF | 见 §2 行尾 |
| `Permission denied: ./scripts/x.sh` | 索引缺可执行位 | 见 §2 文件权限位 |
| CI 里 `git diff --exit-code` 出现大量行尾改动 | 全局 `autocrlf` 与 `.gitattributes` 冲突 | `git add --renormalize .` 后提交 |
| 改了 job 名后 PR 一直卡在 "Expected" | required status checks 名称未同步 | 见 §4 第 3 步 |
