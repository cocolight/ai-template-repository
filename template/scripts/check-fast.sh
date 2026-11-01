#!/bin/sh
# check-fast.sh — 技术栈无关的快速门禁
#
# 由 .githooks/pre-commit 与 CI 共同调用：同一份断言，不各写一遍。
# 只拒绝，不修改任何文件；全量检查，不做增量。
# 项目根按本脚本位置推导（scripts/ 的上级），因此在任何 cwd 调用都作用于同一个项目。
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
cd "$ROOT"

fail=0
bad() { printf '  ✗ %s\n' "$1"; fail=1; }
ok() { printf '  ✓ %s\n' "$1"; }

# 1. 常驻上下文体积：AGENTS.md 每次会话必读，体积即上下文预算
if [ -f AGENTS.md ]; then
  n=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$n" -le 200 ]; then
    ok "AGENTS.md $n 行（上限 200）"
  else
    bad "AGENTS.md $n 行，超过 200：拆分到 .agents/，本文件只留入口与红线"
  fi
fi

# 2. CHANGELOG 条目体积：条目即发布说明
if [ -f CHANGELOG.md ]; then
  long=$(grep '^[[:space:]]*- ' CHANGELOG.md 2>/dev/null | while IFS= read -r line; do
           n=$(printf '%s' "$line" | LC_ALL=C.UTF-8 wc -m | tr -d ' ')
           [ "$n" -le 150 ] || printf '%s 字符：%s\n' "$n" "$line"
         done) || true
  if [ -z "$long" ]; then
    ok "CHANGELOG 条目均 ≤150 字符"
  else
    bad "CHANGELOG 条目超 150 字符：
$long"
  fi
fi

# 3. .agents/ 下每篇文档都必须在 AGENTS.md §1 路由表出现，否则等于死文档。
#    adr/ 与 skills/ 是集合，按目录整体登记即可，逐个文件豁免。
if [ -d .agents ] && [ -f AGENTS.md ]; then
  missing=$(find .agents -name '*.md' | sed 's|^\.agents/||' | sort | while IFS= read -r f; do
              case "$f" in
                adr/*|skills/*/SKILL.md) continue ;;
              esac
              grep -qF ".agents/$f" AGENTS.md || printf '.agents/%s\n' "$f"
            done)
  if [ -z "$missing" ]; then
    ok ".agents/ 下文档均在 AGENTS.md §1 路由表内"
  else
    bad "这些文件未进 AGENTS.md §1 路由表：
$missing"
  fi
fi

# 4. skill frontmatter：没有 name / description 的 skill 无法被 AI 匹配到
if [ -d .agents/skills ]; then
  errs=""
  total=0
  for f in .agents/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    total=$((total + 1))
    if ! head -n 20 "$f" | grep -q '^name:'; then errs="$errs
$f 缺 frontmatter 字段 name"; fi
    if ! head -n 20 "$f" | grep -q '^description:'; then errs="$errs
$f 缺 frontmatter 字段 description"; fi
  done
  if [ -z "$errs" ]; then
    ok "skill frontmatter（$total 个，字段齐全）"
  else
    bad "skill frontmatter 不合契约：$errs"
  fi
fi

if [ "$fail" -ne 0 ]; then
  printf '\n门禁未通过：修正后再提交。不要用 --no-verify 绕过。\n' >&2
  exit 1
fi
printf '\ncheck-fast 全部通过。\n'
