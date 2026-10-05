# Changelog

本文件记录 **本仓库自身**（`ai-template-repository`）的变更。
生成的新项目另有一份 `CHANGELOG.md`（位于 `template/CHANGELOG.md`），那份用于记录该项目自己的变更。

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与
[语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- `ci.yml` 新增「产物内文档死链检查」：解析产物里 Markdown 链接与反引号路径引用，验证目标存在，防止新增文档引入死链

### Changed

- `template/docs/configuration.md` 删掉对 `TEMPLATE.md` 的引用 —— 该文件属工具层、不随模板复制，在每个新项目里都是死链

### Fixed

- 待补充

### Removed

- 待补充
