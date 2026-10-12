# 发版（Releasing）

> 本文是 `AGENTS.md` §3「发版」的详细版，也是 §9 同改矩阵「发版」行的落点。
> 本文只展开步骤，**不得放宽** `AGENTS.md` 的红线与 `docs/definition-of-done.md` 的完成定义。

## 1. 什么条件才可发版

发版不是「功能做完」的自然结果，而是一次需要显式确认的独立动作。以下条件**同时**满足才可发：

- [ ] `ROADMAP.md` 中没有任何 `in-progress` 行（未开工的 `planned` 行可以留到下一版）
- [ ] 全部测试通过；Lint 与格式化检查通过
- [ ] CI 在待发版的那个 commit 上全绿
- [ ] `CHANGELOG.md` 的 `[Unreleased]` 已写全本次要发的改动，且分类（Added / Changed / Fixed …）正确
- [ ] 待发版 commit 已经合入 `main`（只在 `main` 上发版，不在功能分支上发）

## 2. 命名 —— 本次唯一的硬规则

| 对象 | 形式 | 例 |
|---|---|---|
| Git tag | `vX.Y.Z`（**带** `v`） | `v1.4.0` |
| Release title | 与 tag 完全相同 | `v1.4.0` |
| `CHANGELOG.md` 版本节 | `[X.Y.Z] - 日期`（**不带** `v`） | `[1.4.0] - 2026-10-12` |

这三处对不上是最常见的发版事故：使用者按 tag 去找 changelog 里的同名版本节，却找不到。

版本号本身遵循[语义化版本](https://semver.org/lang/zh-CN/)：不兼容的对外变更提主版本、兼容地新增能力提次版本、只修缺陷提修订号。尚未稳定时可停留在 `0.y.z`，但一旦发布 `1.0.0` 就要守规则。

## 3. 步骤

1. **逐条过 §1 的清单**，有一条不满足就停下。
2. **改版本号事实源**：只改 `AGENTS.md` §8 坐标表里「版本号」指向的那一处。不要在 README、其他文档或代码里另抄一份版本号 —— 抄了就会漂移。
3. **改 `CHANGELOG.md`**：
   - 把 `[Unreleased]` 改成 `[X.Y.Z] - YYYY-MM-DD`；
   - 在文件顶部补回一个**空的** `[Unreleased]` 节，供下次改动使用。
4. **提 PR 并合并**：发版改动走正常 PR 流程（`main` 是保护分支，禁止直推），commit type 用 `chore`。
5. **打 tag**：切到合并后的 `main`，打**带注释**的 tag（便于事后查什么时候、为什么发的）：

   ```bash
   git checkout main
   git pull
   git tag -a vX.Y.Z -m "release: X.Y.Z"
   git push origin vX.Y.Z
   ```

6. **建 Release**：title 填 `vX.Y.Z`（与 tag 一致）；说明正文直接取自 `CHANGELOG.md` 的 `[X.Y.Z]` 节，**不要另写一套**——两套说明必然对不上。
7. **收尾核对**：Release 页面正常、tag 指向的 commit 就是刚合入 `main` 的那个 commit。

## 4. 常见错误

| 错误 | 后果 | 正确做法 |
|---|---|---|
| 在功能分支上打 tag | tag 指向一个从未进 `main` 的 commit，使用者拿不到 | 先合并，再在 `main` 上打 tag |
| tag 带 `v`，CHANGELOG 也写 `v` | 不符 Keep a Changelog 惯例，工具解析不到 | `CHANGELOG.md` 里**不带** `v` |
| Release title 自拟（如「秋季版本」） | 按 tag 检索不到对应 Release | title 与 tag 完全一致 |
| 忘了补回空的 `[Unreleased]` | 下次改动无处可记，容易直接追加进已发布版本节 | 改版本节的同一回合补回 |
| 版本号只在 `CHANGELOG.md` 里改 | 程序报出的版本与 changelog 不一致 | 改 §8 坐标表指向的那一处 |
| 往已发布的版本节继续追加条目 | 已发布内容被篡改，无法回溯 | 已发布节**只读**，新改动进 `[Unreleased]` |

## 5. 预发布（需要时）

要给使用者提前试用时，用语义化版本的预发布标识，例如 `v1.5.0-rc.1`：

- tag 与 Release title 仍然保持一致；
- 在 GitHub 上把该 Release 勾选为 **pre-release**，避免被误当成稳定版；
- 在 `CHANGELOG.md` 里可以记在 `[Unreleased]` 下，也可以单开 `[1.5.0-rc.1]` 节 —— 二选一，但同一项目内保持一致。
