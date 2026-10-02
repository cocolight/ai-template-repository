#!/bin/sh
# template-init.sh — 从本模板一键生成一个干净的新项目
# 用法: ./scripts/template-init.sh <新项目路径>
# 例:   ./scripts/template-init.sh ../my-new-app
set -eu

[ "$#" -eq 1 ] || { echo "用法: $0 <新项目路径>" >&2; exit 1; }

SRC=$(cd "$(dirname "$0")/.." && pwd)
DST="$1"
NAME=$(basename "$DST")

mkdir -p "$DST"

# 复制全部内容（含隐藏文件），随后清掉模板自身的 .git
cp -a "$SRC"/. "$DST"/ 2>/dev/null || true
rm -rf "$DST/.git"

# 替换占位符 {{PROJECT_NAME}}
grep -rl '{{PROJECT_NAME}}' "$DST" 2>/dev/null | while read -r f; do
  sed -i "s/{{PROJECT_NAME}}/$NAME/g" "$f"
done

# 重新初始化为独立 git 仓库（不带模板历史）
cd "$DST"
git init -q
# 若本机未配置 git 身份，用占位身份，避免 commit 失败（已配置则沿用你的）
if ! git config user.email >/dev/null 2>&1; then
  git config user.email "template@example.com"
  git config user.name "project-template"
fi
git add -A
git commit -q -m "chore: initialize from project-template"

echo "✓ 已创建 $DST （独立 git 仓库，已替换占位符）"
