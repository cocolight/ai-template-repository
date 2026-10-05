# 本仓库功能路线（ROADMAP）

> 本文件属于**工具层**，记录 `ai-template-repository` 自身的待办。
> 生成的新项目另有一份 `ROADMAP.md`（位于 `template/ROADMAP.md`），那份用于记录该项目的功能清单。

> 状态取值：`planned` / `in-progress` / `done` / `dropped`。
> 「验收标准」须**可判定**（能被命令或明确检查验证）。

| # | 功能 | 状态 | 验收标准 |
|---|------|------|----------|
| 1 | 引入 `template/` 目录，复制改为白名单 | done | 产物不含任何工具层文件、含全部 payload 文件；由 `ci.yml` 的 smoke test 判定 |
| 2 | 工具层文档扩写（本文件、`ROADMAP.md`、`CHANGELOG.md`） | planned | 四份文档内容均为本仓库真实信息，无占位符、无死链 |
| 3 | 修 `template/docs/configuration.md` 引用 `TEMPLATE.md` 的死链 | done | 产物内文档引用全部可达；由 `ci.yml` 的「产物内文档死链检查」判定 |
| 4 | 开工清单的路径与 `template/` 实际保持一致 | planned | 清单位置与实际路径一致（暂不加 CI 断言，靠人工核对） |
| 5 | 多技术栈模板变体（`template/` 拆分为多个骨架） | planned | 能用 `--variant rust` 之类的选项生成不同技术栈的骨架 |
