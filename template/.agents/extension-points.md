# 扩展点索引（要加 X 改哪里）

> 回答「加一种新东西要动哪些地方、按什么顺序」。事实以源码为准，本表只给步骤与同步面。
> 走完任一条，同回合过 `AGENTS.md` §9 的同改矩阵。

## 加一条 AI 规则 / 红线

1. 先定级：违反即回滚（阻断级）还是默认做法（提醒级）——见 `AGENTS.md` §4。
2. 写进 `AGENTS.md` §4，一条一行，短句说清「是什么」，不写推导过程。
3. **能机械判定的一律下沉到脚本**（行数、目录位置、必要文件存在、frontmatter 字段），在 `scripts/check-fast.sh` 加一条断言；只有判不了的才留在文档里靠自觉。
4. 若它同时是「完成」的必要条件，同步 `.agents/definition-of-done.md`，不得放宽。

## 加一篇工程文档

1. 先判归属：不读它 AI 会做错事 → `.agents/`；否则 → `docs`（使用者文档）。
2. 放进 `.agents/` 后**必须**在 `AGENTS.md` §1 路由表加一行，否则 `check-fast.sh` 拦下。
3. 文内引用用相对路径：同目录直接写文件名，跨到仓库根写 `../`。
4. 同步 `TEMPLATE.md` 的「模板包含什么」表与自检正向断言列表。

## 加一个 CI 检查

1. 纯静态、无副作用的检查放进 `scripts/check-fast.sh` —— 本地 hook 与 CI 共用同一份，不要各写一遍。
2. 需要装依赖、跑构建、生成产物的，写进 `.github/workflows/build.yml` 的 `test` job。
3. **只拒绝，不自动修复**：检查脚本不得改文件，自动修复会掩盖失败原因。
4. 阈值（行数、字符数）改动时同回合改注释里的说明，阈值与说明必须一致。

## 记一次决策

- 小决策：`CHANGELOG.md` 条目末尾「（理由：一句话）」。
- 重大、难以回退、或**被否决的方向**：新增一条 ADR（复制 `.agents/adr/template.md`），并在 `.agents/adr/README.md` 的索引加行。被否决的方向也要记，否则同一讨论会被反复重开。
- 状态为「已接受」的记录不得修改，变更用新 ADR 标注取代关系。

## 加一个 AI skill

1. 建 `.agents/skills/<name>/SKILL.md`，frontmatter 必填 `name`（kebab-case，与目录同名）与 `description`（一句话说清何时该用）。
2. 在 `AGENTS.md` §1 路由表加一行指向它。
3. 不预置厂商目录：用 Claude Code 就把同一份内容映射到 `.claude/skills/`，用 Cursor 映射到 `.cursor/rules/`。内容只放一份，映射用软链或同步脚本，手工复制必然漂移。
4. `check-fast.sh` 校验 frontmatter 两个字段，缺一个就红。详见 `.agents/skills/README.md`。

## 换或加技术栈骨架

1. `src/` `tests/` `scripts/` 三个空目录约定不变，只往里放该技术栈的初始化产物。
2. 填实 `AGENTS.md` §2 五行命令与 §8 坐标表；`CONTRIBUTING.md`「本地检查」必须与 §2 完全一致。
3. `.github/workflows/build.yml` 的 `test` job 把占位 step 换成真实命令，三件事缺一不可：装依赖、lint 与格式检查、测试。不得写成 `|| true`，不得把失败降级为警告。
4. 把「分层与依赖方向」做成可检查的门禁接进 CI（例如分层合同的 lint），让违规在 PR 阶段暴露，而不是靠 review 记忆。
