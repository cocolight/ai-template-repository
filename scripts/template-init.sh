#!/bin/sh
# template-init.sh — 从本模板生成一个干净的新项目
#
# 用法: ./scripts/template-init.sh [--dry-run] [--force] <新项目路径>
# 例:   ./scripts/template-init.sh ../my-new-app
#
# 行为:
#   - 复制模板内容（排除 .git / .workbuddy / example / TEMPLATE.md / 本脚本自身 / 模板仓库 CI）
#   - 把 {{PROJECT_NAME}} 与 {{YEAR}} 占位符替换为实际值
#   - 在新目录初始化独立 git 仓库（默认分支 main）并做首次提交
set -eu

usage() {
  cat <<'EOF'
用法: template-init.sh [--dry-run] [--force] <新项目路径>

  --dry-run   只显示将做什么，不写入任何文件
  --force     允许写入已存在且非空的目标目录
  -h, --help  显示本帮助
EOF
}

DRY_RUN=0
FORCE=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force)   FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --)        shift; break ;;
    -*)        echo "错误：未知参数 '$1'" >&2; usage >&2; exit 2 ;;
    *)         break ;;
  esac
done

[ "$#" -eq 1 ] || { echo "用法: $0 [--dry-run] [--force] <新项目路径>" >&2; exit 2; }

SRC=$(cd "$(dirname "$0")/.." && pwd -P)
DST_ARG=$1

# Windows 绝对路径（如 C:\foo\bar）先转成 POSIX 路径，兼容 Git Bash / Cygwin
case "$DST_ARG" in
  [A-Za-z]:[\\/]*)
    if command -v cygpath >/dev/null 2>&1; then
      DST_ARG=$(cygpath -u "$DST_ARG")
    fi
    ;;
esac

# 从目标路径解析项目名（必须是叶目录名）
NAME=$(basename "$DST_ARG")
if [ -z "$NAME" ] || [ "$NAME" = "." ] || [ "$NAME" = "/" ] || [ "$NAME" = ".." ]; then
  echo "错误：无法从 '$DST_ARG' 解析出合法项目名" >&2
  exit 2
fi

# ---- 第一步：词法安全检查（此时尚未创建任何目录）----
case "$DST_ARG" in
  /*) DST_ABS="$DST_ARG" ;;
  *)  DST_ABS="$PWD/$DST_ARG" ;;
esac
# 去掉结尾多余的 "/"
while [ "${DST_ABS%/}" != "$DST_ABS" ]; do DST_ABS=${DST_ABS%/}; done
[ -n "$DST_ABS" ] || { echo "错误：无法解析目标路径：'$DST_ARG'" >&2; exit 2; }

case "$DST_ABS" in
  "$SRC"|"$SRC"/*) echo "错误：目标不能是模板仓库自身或其子目录：$DST_ABS" >&2; exit 3 ;;
esac
case "$SRC" in
  "$DST_ABS"/*) echo "错误：模板仓库位于目标目录之内，无法安全复制：$SRC" >&2; exit 3 ;;
esac

# ---- 第二步：创建父目录并规范化，再校验一次（覆盖符号链接等）----
DST_PARENT=$(dirname "$DST_ABS")
mkdir -p "$DST_PARENT"
DST_PARENT=$(cd "$DST_PARENT" && pwd -P)
DST="$DST_PARENT/$NAME"

case "$DST" in
  "$SRC"|"$SRC"/*) echo "错误：目标不能是模板仓库自身或其子目录：$DST" >&2; exit 3 ;;
esac
case "$SRC" in
  "$DST"/*) echo "错误：模板仓库位于目标目录之内，无法安全复制：$SRC" >&2; exit 3 ;;
esac

if [ -e "$DST" ] && [ "$FORCE" -ne 1 ] \
   && [ -n "$(find "$DST" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
  echo "错误：目标已存在且非空：$DST（如需写入请加 --force）" >&2
  exit 4
fi

YEAR=$(date +%Y)
echo "模板:   $SRC"
echo "目标:   $DST"
echo "项目名: $NAME"
echo "年份:   $YEAR"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "(dry-run：不写入任何文件)"
  exit 0
fi

# ---- 复制（跳过模板自用内容：.git / .workbuddy / example / TEMPLATE.md）----
# .workbuddy 是本地 AI 工具数据（通常未纳入版本控制），排除它以保证
# "本地直接生成"与"克隆后生成"得到一致的结果。
mkdir -p "$DST"
for entry in "$SRC"/* "$SRC"/.[!.]* "$SRC"/..?*; do
  [ -e "$entry" ] || continue
  case "$(basename "$entry")" in
    .git|.workbuddy|example|TEMPLATE.md) continue ;;
  esac
  cp -a "$entry" "$DST"/
done
# 去掉只属于模板仓库自身、不应进入新项目的文件
rm -f "$DST/scripts/template-init.sh" "$DST/.github/workflows/ci.yml"

# ---- 替换占位符（awk 字面替换：免转义、跨平台、无需 perl）----
export NAME YEAR
replace_placeholders() {
  awk '
    function lit(s, pat, rep,   out, rest, i, n) {
      n = length(pat); out = ""; rest = s
      while ((i = index(rest, pat)) > 0) {
        out = out substr(rest, 1, i - 1) rep
        rest = substr(rest, i + n)
      }
      return out rest
    }
    BEGIN { name = ENVIRON["NAME"]; year = ENVIRON["YEAR"] }
    {
      line = lit($0, "{{PROJECT_NAME}}", name)
      line = lit(line, "{{YEAR}}", year)
      print line
    }' "$1"
}

find "$DST" -type f ! -name '*.template-init.tmp' | while IFS= read -r f; do
  if grep -F -q '{{' "$f" 2>/dev/null; then
    tmp="$f.template-init.tmp"
    replace_placeholders "$f" > "$tmp" && mv "$tmp" "$f"
  fi
done

# ---- 初始化独立 git 仓库（默认分支 main）----
cd "$DST"
if ! git init -q -b main 2>/dev/null; then
  git init -q
  git symbolic-ref HEAD refs/heads/main
fi

if ! git config user.email >/dev/null 2>&1; then
  git config user.email "you@example.com"
  git config user.name "your-name"
fi

git add -A
git commit -q -m "chore: initialize project from template"

echo "✓ 已创建 $DST（独立 git 仓库，默认分支 main，占位符已替换）"
