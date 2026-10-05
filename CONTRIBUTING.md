# 贡献指南

> 本文件属于**工具层**，约束的是「改动本模板仓库」这件事。
> 生成的新项目另有一份 `CONTRIBUTING.md`（位于 `template/CONTRIBUTING.md`），那份约束的是「开发新项目」。**两者内容不同，不要互相覆盖。**

## 分支策略

- `main` 为保护分支，不要直接推送。
- 从 `main` 切 `feature/<名称>` 分支，一个功能一个分支。

## 提交规范

- Conventional Commits，type 用英文前缀：
  `feat:`（新功能）`fix:`（修复）`docs:`（文档）`test:`（测试）`chore:`（杂项）`refactor:`（重构）`ci:`（CI）。
- 描述可用中文，简明；标题总长 ≤ 72 字符。
- 本仓库的架构决策只记在 `CHANGELOG.md`，不维护工具层 ADR（`docs/adr/` 已移入 `template/`，属生成物）。

## 改动该放哪

仓库分两层，**放错位置会被静默复制进用户的新项目**：

| 想做的事 | 放哪 | 是否需要改脚本 |
|---------|------|----------------|
| 让文件进新项目 | `template/` 下 | 否 |
| 只服务于本仓库 | 仓库根目录 | 否 |

复制是白名单：新增任何一层的文件都**不需要**改 `scripts/template-init.sh`。

## 本地检查

提交前至少跑这两条，完整清单见 [TEMPLATE.md](TEMPLATE.md)「改完模板后的自检」：

```bash
# 1) 脚本语法与 lint（CI 也会跑）
sh -n scripts/template-init.sh
shellcheck scripts/*.sh

# 2) 真实生成一个项目并核对结构
T=$(mktemp -d) && ./scripts/template-init.sh "$T/proj"
find "$T/proj" -maxdepth 1 -mindepth 1 -not -name '.git' | sort
```

期望：产物里**没有** `template/`、`TEMPLATE.md`、`example/`、`scripts/template-init.sh`、`.github/workflows/ci.yml`，但**有** `README.md`、`AGENTS.md`、`LICENSE`、`.github/workflows/build.yml`，且无 `.gitkeep`、保留 `src/` `tests/` `scripts/` 三个目录。

## 红线与完成定义

- 提交前请阅读 [AGENTS.md](AGENTS.md) 的「红线」。
- 改动是否算完成，以 [AGENTS.md](AGENTS.md) §5 为准。

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
