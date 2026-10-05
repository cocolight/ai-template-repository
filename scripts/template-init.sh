#!/bin/sh
# template-init.sh — 从本模板生成一个干净的新项目
#
# 用法: ./scripts/template-init.sh [--dry-run] [--force] <新项目路径>
# 例:   ./scripts/template-init.sh ../my-new-app
#
# 行为:
#   - 复制 template/ 目录下的全部内容（白名单：只有 template/ 里的东西会进新项目）
#   - 复制阶段即跳过 .gitkeep 占位文件（模板仓库自身保留它们）；
#     只含占位文件的空目录（src / tests / scripts）仍会保留，只是里面没有占位文件
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

# ---- 路径基准：两个变量职责不同，不可混用 ----
# REPO_ROOT 安全检查的基准（整个模板仓库），用于拒绝「把新项目写进本仓库内」
# TPL_DIR   复制源（本仓库的 template/ 子目录）
# 混为一谈会导致 ./scripts/template-init.sh ./my-app 这类误操作被放过：
# 目标 REPO_ROOT/my-app 既不在 TPL_DIR 内，TPL_DIR 也不在其中，两道检查都会通过，
# 于是在模板仓库内部生成了一个嵌套 git 仓库，后续 git add -A 可能把它误提交进来。
REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
TPL_DIR="$REPO_ROOT/template"
DST_ARG=$1

# ---- 模板源必须存在：缺失即报错，不回退到「复制仓库根目录」 ----
# 不回退的理由：回退等于恢复黑名单语义，产物里会重新出现 TEMPLATE.md / example /
# ci.yml 等工具层文件；而且回退分支会让 CI 察觉不到仓库布局已损坏。
# 这条检查放在 DRY_RUN 判断之前，--dry-run 也必须能报出布局损坏。
# 它同时是「cd 进可能不存在的目录」的唯一防线 —— 管道左侧的 cd 失败不会被
# set -e 捕获（实测退出码仍为 0），若此处不拦，脚本会静默产出空项目。
if [ ! -d "$TPL_DIR" ]; then
  echo "错误：找不到模板目录：$TPL_DIR" >&2
  echo "      仓库结构已损坏（重新克隆，或检查是否处于稀疏检出 / 迁移未完成状态）" >&2
  exit 5
fi

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
  "$REPO_ROOT"|"$REPO_ROOT"/*) echo "错误：目标不能是模板仓库自身或其子目录：$DST_ABS" >&2; exit 3 ;;
esac
case "$REPO_ROOT" in
  "$DST_ABS"/*) echo "错误：模板仓库位于目标目录之内，无法安全复制：$REPO_ROOT" >&2; exit 3 ;;
esac

# ---- 第二步：创建父目录并规范化，再校验一次（覆盖符号链接等）----
DST_PARENT=$(dirname "$DST_ABS")
mkdir -p "$DST_PARENT"
DST_PARENT=$(cd "$DST_PARENT" && pwd -P)
DST="$DST_PARENT/$NAME"

case "$DST" in
  "$REPO_ROOT"|"$REPO_ROOT"/*) echo "错误：目标不能是模板仓库自身或其子目录：$DST" >&2; exit 3 ;;
esac
case "$REPO_ROOT" in
  "$DST"/*) echo "错误：模板仓库位于目标目录之内，无法安全复制：$REPO_ROOT" >&2; exit 3 ;;
esac

if [ -e "$DST" ] && [ "$FORCE" -ne 1 ] \
   && [ -n "$(find "$DST" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
  echo "错误：目标已存在且非空：$DST（如需写入请加 --force）" >&2
  exit 4
fi

YEAR=$(date +%Y)
echo "仓库:   $REPO_ROOT"
echo "模板:   $TPL_DIR"
echo "目标:   $DST"
echo "项目名: $NAME"
echo "年份:   $YEAR"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "(dry-run：不写入任何文件)"
  exit 0
fi

# ---- 复制目录树 ----
# 复制源是白名单：只有 template/ 下的内容会进新项目。
# 工具层文件（TEMPLATE.md / example/ / 本脚本 / ci.yml / 根 README 等）物理上
# 不在 template/ 里，因此「新增一个工具层文件」不需要改脚本，「新增一个 payload
# 文件」也不需要改脚本 —— 这是本脚本最重要的性质。
# 剪枝列表只剩 3 项：
#   .gitkeep   占位文件只服务于模板仓库自身（让 Git 能跟踪空目录）；
#              这里在复制阶段就跳过，所以模板仓库里保留、产物里没有
#   .git / .workbuddy   纵深防御，不是主要机制（正常情况下它们不在 template/ 里）。
#              保留是为了万一有人误放进 template/，代价不至于变成复制整个版本库。
#              不要因为「排除了它们」就以为这还是黑名单。
# 实现说明：按目录树逐项复制（find 先输出目录、后输出其中的文件），
# 因此"只含占位文件的空目录"（src/、tests/、scripts/）依然会被 mkdir 出来 ——
# 目录约定留在产物里，占位文件不留。
mkdir -p "$DST"
(
  cd "$TPL_DIR" && find . \
    \( -name .git -o -name .workbuddy -o -name .gitkeep \) -prune -o -print
) | while IFS= read -r rel; do
  if [ -d "$TPL_DIR/$rel" ]; then
    mkdir -p "$DST/$rel"
  else
    cp -a "$TPL_DIR/$rel" "$DST/$rel"
  fi
done

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
