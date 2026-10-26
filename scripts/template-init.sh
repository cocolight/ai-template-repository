#!/bin/sh
# template-init.sh — 从本仓库的某一个「模板变体」生成一个干净的新项目
#
# 用法: ./scripts/template-init.sh [--dry-run] [--force] [--template <名称>] [<新项目路径>]
# 例:   ./scripts/template-init.sh --template blank ../my-new-app
#       ./scripts/template-init.sh            # 交互：先问路径，再选变体
#
# 模板变体：template/ 下的每个子目录是一个变体（如 blank、general）。
#   - 复制「所选变体目录」下的全部内容（白名单：只有该变体里的东西会进新项目）
#   - 复制阶段即跳过 .gitkeep 占位文件（模板仓库自身保留它们）；
#     只含占位文件的空目录（src / tests / scripts）仍会保留，只是里面没有占位文件
#   - 把 {{PROJECT_NAME}} 与 {{YEAR}} 占位符替换为实际值
#   - 在新目录初始化独立 git 仓库（默认分支 main）并做首次提交
#
# 交互：
#   - 不带 <路径> 且标准输入是终端 → 交互询问路径
#   - 不带 --template 且标准输入是终端 → 交互选择变体
#   - 非交互（CI / 管道）必须显式给出 --template 与路径，否则报错退出
set -eu

# 路径基准：REPO_ROOT 安全检查的基准（整个模板仓库），TPL_ROOT 是变体集合目录
REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
TPL_ROOT="$REPO_ROOT/template"

usage() {
  cat <<'EOF'
用法: template-init.sh [--dry-run] [--force] [--template <名称>] [<新项目路径>]

  --dry-run     只显示将做什么，不写入任何文件
  --force       允许写入已存在且非空的目标目录
  --template X  使用 template/X/ 这个模板变体（非交互模式必须指定）
  -h, --help    显示本帮助

可用变体（template/ 下的子目录）：
EOF
  for d in "$TPL_ROOT"/*/; do
    [ -d "$d" ] && echo "  $(basename "$d")"
  done
}

list_variants() {
  for d in "$TPL_ROOT"/*/; do
    [ -d "$d" ] && basename "$d"
  done
}

DRY_RUN=0
FORCE=0
TPL_NAME=""
DST_ARG=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)   DRY_RUN=1; shift ;;
    --force)     FORCE=1; shift ;;
    --template)
      TPL_NAME="${2:-}"
      if [ -z "$TPL_NAME" ]; then
        echo "错误：--template 需要参数" >&2; usage >&2; exit 2
      fi
      shift 2 ;;
    -h|--help)   usage; exit 0 ;;
    --)          shift; break ;;
    -*)          echo "错误：未知参数 '$1'" >&2; usage >&2; exit 2 ;;
    *)           break ;;
  esac
done
# 剩余位置参数即新项目路径（可选；缺失且在终端中则交互询问）
[ "$#" -ge 1 ] && DST_ARG=$1

# ---- 变体集合目录必须存在：缺失即报错，不回退到「复制仓库根目录」 ----
# 不回退的理由：回退等于恢复黑名单语义，产物里会重新出现 TEMPLATE.md / example /
# ci.yml 等工具层文件；而且回退分支会让 CI 察觉不到仓库布局已损坏。
# 这条检查放在最前，--dry-run 也必须能报出布局损坏。
if [ ! -d "$TPL_ROOT" ]; then
  echo "错误：找不到模板目录：$TPL_ROOT" >&2
  echo "      仓库结构已损坏（重新克隆，或检查是否处于稀疏检出 / 迁移未完成状态）" >&2
  exit 5
fi

# ---- 第一步：解析新项目路径（先问路径，符合「先路径后变体」的交互顺序）----
# Windows 绝对路径（如 C:\foo\bar）先转成 POSIX 路径，兼容 Git Bash / Cygwin
case "$DST_ARG" in
  [A-Za-z]:[\\/]*)
    if command -v cygpath >/dev/null 2>&1; then
      DST_ARG=$(cygpath -u "$DST_ARG")
    fi
    ;;
esac

if [ -z "$DST_ARG" ]; then
  if [ -t 0 ]; then
    printf '请输入新项目路径: '
    read -r DST_ARG </dev/tty
  else
    echo "错误：非交互模式必须指定 <新项目路径>" >&2
    exit 2
  fi
fi
[ -n "$DST_ARG" ] || { echo "错误：路径不能为空" >&2; exit 2; }

# 从目标路径解析项目名（必须是叶目录名）
NAME=$(basename "$DST_ARG")
if [ -z "$NAME" ] || [ "$NAME" = "." ] || [ "$NAME" = "/" ] || [ "$NAME" = ".." ]; then
  echo "错误：无法从 '$DST_ARG' 解析出合法项目名" >&2
  exit 2
fi

# ---- 第二步：解析模板变体 ----
if [ -z "$TPL_NAME" ]; then
  if [ -t 0 ]; then
    variants=$(list_variants)
    [ -n "$variants" ] || { echo "错误：template/ 下没有任何模板变体" >&2; exit 5; }
    echo "可用的模板变体："
    i=0
    printf '%s\n' "$variants" | while IFS= read -r v; do i=$((i+1)); echo "  $i) $v"; done
    printf '请选择模板 [1]: '
    read -r choice </dev/tty
    [ -z "$choice" ] && choice=1
    case "$choice" in *[!0-9]*) echo "错误：请输入数字" >&2; exit 2 ;; esac
    TPL_NAME=$(printf '%s\n' "$variants" | sed -n "${choice}p")
    [ -n "$TPL_NAME" ] || { echo "错误：选项超出范围" >&2; exit 2; }
  else
    echo "错误：非交互模式必须通过 --template 指定模板变体" >&2
    exit 2
  fi
fi

TPL_DIR="$TPL_ROOT/$TPL_NAME"
if [ ! -d "$TPL_DIR" ]; then
  echo "错误：不存在的模板变体：$TPL_NAME（template/ 下可用：$(list_variants | tr '\n' ' ')）" >&2
  exit 2
fi

# ---- 第三步：词法安全检查（此时尚未创建任何目录）----
# REPO_ROOT 与 TPL_DIR 职责不同，不可混用 —— 混用会放过
# 「把新项目写进仓库内部」的误操作，在仓库里生成嵌套 git 仓库。
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

# ---- 第四步：创建父目录并规范化，再校验一次（覆盖符号链接等）----
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
echo "变体:   $TPL_NAME ($TPL_DIR)"
echo "目标:   $DST"
echo "项目名: $NAME"
echo "年份:   $YEAR"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "(dry-run：不写入任何文件)"
  exit 0
fi

# ---- 复制目录树 ----
# 复制源是白名单：只有所选变体目录下的内容会进新项目。
# 工具层文件（TEMPLATE.md / example/ / 本脚本 / ci.yml / 根 README 等）物理上
# 不在任何变体目录里，因此「新增一个工具层文件」不需要改脚本；「在某个变体里
# 新增一个 payload 文件」也不需要改脚本。新增一个「变体」只需新建一个子目录。
# 剪枝列表只剩 3 项：
#   .gitkeep   占位文件只服务于模板仓库自身（让 Git 能跟踪空目录）；
#              这里在复制阶段就跳过，所以模板仓库里保留、产物里没有
#   .git / .workbuddy   纵深防御，不是主要机制（正常情况下它们不在变体目录里）。
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
    cp -R "$TPL_DIR/$rel" "$DST/$rel"
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
git commit -q -m "chore: initialize project from template ($TPL_NAME)"

echo "✓ 已创建 $DST（变体 $TPL_NAME，独立 git 仓库，默认分支 main，占位符已替换）"
