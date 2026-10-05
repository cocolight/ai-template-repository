# 这是一个「面向 AI 协作开发」的项目模板

本仓库是项目模板。新项目请用它生成一个**干净、独立、默认分支为 `main`** 的新仓库。

> **仓库分两层**：根目录是「工具层」（本文件、生成脚本、活文档示例），[`template/`](template/) 是「数据层」（项目骨架，会被整目录复制进新项目）。**只有 `template/` 下的内容会进新项目。**

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
| `./scripts/template-init.sh ../my-app` | 以模板为蓝本，在 `../my-app` 生成新项目：复制 `template/` 下的内容、替换 `{{PROJECT_NAME}}`/`{{YEAR}}`、`git init -b main` 并创建首次提交 |

上面第 ③ 步里的路径就是新项目的位置，**不要**填在模板仓库内部——脚本会拒绝并报错（防止自我复制、误删模板的 `.git`）。

> 若你 fork 或改名了本模板，请把上面的克隆地址换成你自己的仓库地址。

`template-init.sh` 会：

- 复制 [`template/`](template/) 下的全部内容到新路径（**白名单**：工具层文件物理上不在 `template/` 里，因此无需维护排除清单）；复制阶段跳过所有 `.gitkeep` 占位文件（在复制阶段跳过，不是复制后再删）；
- 把 `{{PROJECT_NAME}}` 与 `{{YEAR}}` 占位符替换为实际值；
- 在新目录 `git init`（默认分支 `main`）并创建首次提交。

若 `template/` 目录不存在（例如克隆不完整、稀疏检出），脚本以退出码 5 硬失败并提示仓库结构损坏 —— 它**不会**回退到「复制仓库根目录」，因为那会把工具层文件混进你的新项目。

选项：`--dry-run`（只看将做什么，不写文件）、`--force`（允许写入非空目录）。

## 手动使用（不用脚本）

1. 把 `template/` 目录下的**全部内容**复制为你新项目的内容（等价于 `cp -a template/. <新项目>/`）；`.gitkeep` 占位文件**不要复制**，但要把 `src/`、`tests/`、`scripts/` 三个目录用 `mkdir` 建出来（否则它们会随占位文件一起消失）；
2. 全局替换 `{{PROJECT_NAME}}` 与 `{{YEAR}}`；
3. 填好 `AGENTS.md` §2「常用命令」表与 `README.md` 的 TODO；
4. `git init -b main && git add -A && git commit -m "chore: initialize project"`。

## 模板包含什么

以下文件都在 [`template/`](template/) 目录下，生成新项目时会出现在新项目里。

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | 给 AI 编码助手的规则：上下文入口、常用命令、红线、DoD |
| `README.md` | 项目说明骨架（含 TODO 占位） |
| `ROADMAP.md` | 功能清单 + **验收标准** 列 |
| `CONTRIBUTING.md` | 分支 / 提交 / PR 规范 |
| `CHANGELOG.md` | 变更记录骨架（Keep a Changelog） |
| `docs/architecture.md` | 架构与代码约定 |
| `docs/configuration.md` | 仓库与项目配置说明（环境 / Git / 行尾 / CI / 分支保护） |
| `docs/definition-of-done.md` | 完成定义（DoD） |
| `docs/adr/` | 架构决策记录（含模板与首条记录） |
| `LICENSE` | MIT 许可证正文（年份与项目名已由脚本填好） |
| `.gitignore` / `.gitattributes` | 依赖忽略规则；强制库内 LF，防止脚本在 Windows 被检出为 CRLF |
| `.github/workflows/build.yml` | CI 门禁骨架（需按技术栈补全） |
| `src/` `tests/` `scripts/` | 空目录（占位文件不复制，目录保留） |

`example/` 下两个填好的示例（Python / Rust）在**仓库根**，仅供参照，**不会**复制进新项目。

## 新项目开工清单

按顺序做。第 1–7 步是「改文件」，第 8 步是「改外部设置」。每条写明 **改哪个文件 / 改什么 / 怎么算改对**。

> `.gitkeep` 占位文件只服务于模板仓库自身（让 Git 能跟踪空目录），`template-init.sh` **在复制阶段就跳过它们**，所以产物里**不含任何 `.gitkeep`**；而"只含占位文件的空目录"（`src/`、`tests/`、`scripts/`）仍然保留，只是里面没有占位文件。新项目里不用再手工清理占位文件。
>
> 唯一残留限制：Git 本身不跟踪空目录，所以这三个空目录不会进入新项目的**首次提交**。往 `src/`、`tests/` 里放进第一个真实文件（例如初始化骨架、写第一个测试）就会被自动纳入版本控制，无需额外操作。
>
> 下表所有路径都是**新项目内**的路径（产物里已不含 `template/` 这一层）。

| # | 文件 | 改什么 | 怎么算改对 |
|---|------|--------|-----------|
| 1 | 代码骨架与依赖清单 | 用本项目技术栈的初始化方式落下骨架，再把项目名、版本、描述、许可证等元信息填成真实值 | 项目能构建 / 启动 |
| 2 | `AGENTS.md` | §0 把「一句话说明本项目做什么」写实；**§2 五行命令全部填上**（安装依赖 / 运行 / 测试 / Lint / 格式化检查） | 表里不再有「（待填）」 |
| 3 | `README.md` | 开头的简介、`## 功能` 列表，以及 3 处 `<!-- TODO -->`（安装 / 运行 / 测试命令） | 文件里不再有 `TODO` |
| 4 | `ROADMAP.md` | 写首批功能；每条「验收标准」必须**能被命令或明确检查验证** | 每条你都能说出"怎么验证它完成了" |
| 5 | `.github/workflows/build.yml` | 把占位 step 换成真实命令（文件里的 TODO 注释已列出要填哪几步） | 本地跑一遍同样的命令，全绿 |
| 6 | `docs/architecture.md` | §1 补目录分层；§3 补本项目技术栈的错误处理策略 | 与代码实际结构一致 |
| 7 | `CONTRIBUTING.md` | 「本地检查」那一行填成本项目的真实命令 | 与 `AGENTS.md` §2 完全一致 |
| 8 | GitHub 仓库设置（不是文件） | 启用 Actions → 收紧 Workflow permissions → 为 `main` 开分支保护 + required status checks | 见 [docs/configuration.md](docs/configuration.md) §4 |

第 8 步的坑：required status checks 的名字**必须等于 workflow 里的 job 名**。`build.yml` 的 job id 是 `test` 且未设 `name`，所以在列表里搜 `test`；一旦改了 job 名，这里要同步改。

**开工前先跑这两条自检**：

```bash
# 1) 占位符应已被脚本全部替换 —— 无输出即为干净
#    注意：这条要在「新项目目录内」执行。在模板仓库里执行会命中 template/
#    下的占位符，那是预期的。
grep -rn "{{" . --exclude-dir=.git

# 2) 脚本索引权限（Linux / macOS 克隆后 ./x.sh 才不会 Permission denied）
git ls-files -s scripts/
```

环境 / Git / 行尾 / CI / 分支保护的完整核对清单见 [docs/configuration.md](docs/configuration.md) §5。

## 哪些文件不要改

新项目里有几处内容是「判定基准」或「安全底线」，改了整套规范就失效。分四类。

> 本节所有路径都是**新项目内**的路径。

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

`template/`、`TEMPLATE.md`、`scripts/template-init.sh`、`.github/workflows/ci.yml`、`example/`、`.workbuddy/` 是**工具层**文件，物理上就不在复制源 `template/` 里，生成新项目时被自然排除 —— 新项目里**根本不存在**。

## 维护模板仓库自身

**复制规则是白名单**：只有 `template/` 下的内容会被复制进新项目。根目录的 `README.md`、`AGENTS.md`、`CONTRIBUTING.md`、`ROADMAP.md`、`CHANGELOG.md`、`LICENSE`、`.gitignore`、`.gitattributes`、`TEMPLATE.md`、`scripts/`、`example/`、`.github/workflows/ci.yml` 全部是工具层，物理上不在 `template/` 里。

因此：

- 新增「仅供模板自用」的文件 → **直接放仓库根，不用改脚本**；
- 新增「要进新项目」的文件 → **直接放 `template/` 下，不用改脚本**；
- 维护成本为零：不存在需要同步的排除清单。

**必须保持的仓库性质**：

| 性质 | 原因 | 检查 |
|------|------|------|
| 通用文件不绑定具体技术栈 | 本模板对所有技术栈通用；语言 / 工具的具体示例**只放 `example/`**，不写进 `template/` 下的任何文件。通用文件里只写"该填什么"，不写"用什么填" | 见下方"通用文件技术栈中性自检" |
| 库内一律 LF | Windows 检出脚本变 CRLF 会导致 `bad interpreter` | `git check-attr eol -- scripts/template-init.sh` → `eol: lf`<br>`git check-attr eol -- template/README.md` → `eol: lf` |
| 两份 `.gitattributes` 内容一致 | 根那份**递归覆盖** `template/**`（已实测），内容一致时属性无歧义 | `diff .gitattributes template/.gitattributes` |
| `scripts/*.sh` 索引模式 `100755` | 否则 CI 的 `./scripts/template-init.sh` 报 `Permission denied`（Windows 上 `core.filemode=false`，本地测不出） | `git ls-files -s scripts/` |
| `template/` 下索引模式全为 `100644` | 可执行位会跟着进新项目 | `git ls-files -s template/ \| grep -v '^100644 '` → 无输出 |
| `build.yml` 只在 `template/` 下 | 留在根上会让本仓库跑一个「只打 warning」的空壳 job，门禁形同虚设 | `ls .github/workflows/` → 只有 `ci.yml` |
| 交付文件里不写占位符字面 | 生成新项目时，**`template/` 下的所有文件**都会参与占位符替换，文档里写占位符字面会被改写 | 见下方"改完模板后的自检" |

修复权限位丢失：

```bash
git update-index --chmod=+x scripts/template-init.sh
```

**通用文件技术栈中性自检**（`template/` 下的文件用于指导任何技术栈的新项目，不得出现具体语言 / 工具名；示例一律放 `example/`）：

```bash
# 先确认待扫路径存在 —— grep 对不存在的路径会返回退出码 2，
# 但 `|| echo OK` 照样执行，路径写错时这个检查会「假绿」
for p in template/README.md template/AGENTS.md template/ROADMAP.md \
         template/CONTRIBUTING.md template/CHANGELOG.md template/docs \
         template/.github/workflows/build.yml; do
  [ -e "$p" ] || { echo "中性自检路径不存在：$p"; exit 1; }
done

grep -rn -i -e cargo -e pyproject -e pytest -e ruff -e "npm " -e "pip " \
  template/README.md template/AGENTS.md template/ROADMAP.md template/CONTRIBUTING.md \
  template/CHANGELOG.md template/docs template/.github/workflows/build.yml \
  || echo "OK: 通用文件保持技术栈中性"
```

> 扫描范围**只限 `template/`**。仓库根的 `AGENTS.md` §2 会列出本仓库 CI 的真实命令（`shellcheck` / `pytest` / `cargo` 等），那是正当的，不该被中性规则约束。

**改完模板后的自检**（在生成产物上检查；模板自身的 `template/` 含占位符，直接 grep 仓库会误报）：

```bash
sh -n scripts/template-init.sh                     # 语法
T=$(mktemp -d)
./scripts/template-init.sh "$T/newproj"            # 真实生成
grep -rn "{{" "$T/newproj" --exclude-dir=.git || echo "OK: 产物无残留占位符"
find "$T/newproj" -name '.gitkeep' -not -path '*/.git/*' | wc -l  # 期望 0
ls -d "$T/newproj"/src "$T/newproj"/tests "$T/newproj"/scripts  # 期望三个目录都在
git -C "$T/newproj" branch --show-current          # 期望 main

# 白名单反向断言：工具层文件不得进入产物
for f in template TEMPLATE.md example scripts/template-init.sh .github/workflows/ci.yml; do
  [ ! -e "$T/newproj/$f" ] || { echo "泄露：$f"; exit 1; }
done

# 正向断言：payload 必须真的复制到位
#（只有反向断言时，复制阶段整体失效会全绿通过）
for f in README.md AGENTS.md ROADMAP.md CONTRIBUTING.md CHANGELOG.md LICENSE \
         .gitignore .gitattributes .github/workflows/build.yml \
         docs/architecture.md docs/configuration.md docs/definition-of-done.md; do
  [ -f "$T/newproj/$f" ] || { echo "缺少：$f"; exit 1; }
done

diff .gitattributes template/.gitattributes || echo "警告：两份 .gitattributes 不一致"

# CI 会执行：shellcheck scripts/*.sh + 上面这套断言 + 两个 example 的 lint/test
```
