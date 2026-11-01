#!/bin/sh
# check-fast.sh — 工具层快速门禁：保证 template/ 这个产品的性质。
#
# 先跑 payload 自己的门禁（template/scripts/check-fast.sh，在 template/ 内生效），
# 再跑只有维护本仓库才需要的结构检查。
# 只拒绝，不修改任何文件；全量检查，不做增量。
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
cd "$ROOT"

fail=0
bad() { printf '  ✗ %s\n' "$1"; fail=1; }
ok() { printf '  ✓ %s\n' "$1"; }

# 1. payload 门禁：产物级断言先在模板仓库里跑一遍
printf 'payload 门禁（template/）\n'
if sh template/scripts/check-fast.sh >/dev/null 2>&1; then
  ok "payload 门禁通过"
else
  sh template/scripts/check-fast.sh >&2 || true
  bad "payload 门禁未通过（输出见上）"
fi

# 2. payload 清单双向一致：payload.txt 是唯一机器清单
if [ ! -f payload.txt ]; then
  bad "缺少根 payload.txt"
else
  miss=""
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$f" in \#*) continue ;; esac
    [ -f "template/$f" ] || miss="$miss
清单里的文件不存在：template/$f"
  done < payload.txt
  extra=$(cd template && find . -type f ! -name '.gitkeep' | sed 's|^\./||' | sort | while IFS= read -r f; do
            grep -qxF "$f" "$ROOT/payload.txt" || printf 'template/%s\n' "$f"
          done)
  if [ -z "$miss" ] && [ -z "$extra" ]; then
    ok "payload 清单与 template/ 内容双向一致"
  else
    [ -z "$miss" ] || bad "payload.txt 有误：$miss"
    [ -z "$extra" ] || bad "template/ 下这些文件未登记进 payload.txt：
$extra"
  fi
fi

# 3. 索引模式：脚本必须可执行，其余必须 644
mode_bad=$(git ls-files -s template/ scripts/ .githooks/ | while read -r mode _ _ path; do
             case "$path" in
               *.sh|*/.githooks/*|.githooks/*)
                 [ "$mode" = "100755" ] || printf '%s 应为 100755（当前 %s）\n' "$path" "$mode" ;;
               *)
                 [ "$mode" = "100644" ] || printf '%s 应为 100644（当前 %s）\n' "$path" "$mode" ;;
             esac
           done)
if [ -z "$mode_bad" ]; then
  ok "索引模式正确"
else
  bad "索引模式错误：
$mode_bad"
fi

# 4. 两份 .gitattributes 必须一致：根那份递归覆盖 template/，内容不同则属性有歧义
if diff -q .gitattributes template/.gitattributes >/dev/null 2>&1; then
  ok "两份 .gitattributes 一致"
else
  bad "根 .gitattributes 与 template/.gitattributes 不一致"
fi

# 5. 工具层文件不得混入 template/（放错位置会被复制进新项目）
leak=""
for f in TEMPLATE.md payload.txt example scripts/template-init.sh .github/workflows/ci.yml; do
  [ ! -e "template/$f" ] || leak="$leak
template/$f"
done
if [ -z "$leak" ]; then
  ok "template/ 内无工具层文件"
else
  bad "template/ 内混入工具层文件：$leak"
fi

# 6. 能力同步：template/AGENTS.md 有的能力块，根 AGENTS.md 必须也有（各自视角表述）
sync_bad=""
for k in 上下文入口 红线 完成定义 同改矩阵 发版; do
  grep -qE "^#+ .*$k" AGENTS.md || sync_bad="$sync_bad
根 AGENTS.md 缺少「$k」章节（template/AGENTS.md 有该能力）"
done
if [ -z "$sync_bad" ]; then
  ok "能力同步：关键能力块根仓库齐全"
else
  bad "能力未同步回根仓库：$sync_bad"
fi

# 7. 工具层文档里的 `template/<path>` 必须真实存在。
#    payload 内的相对链接由 build.yml 的死链检查兜；这一条兜的是工具层对 payload 的引用，
#    目录一移动（如 docs/engineering → .agents）就会留一堆指向空处的旧路径。
#    豁免两类：CHANGELOG 全篇是历史；ROADMAP 的 done / dropped 行是记录。二者都是「当时
#    事实」，改了等于篡改历史，所以不参与判定。含通配符的 token 是示例，不是路径。
ref_bad=""
for f in *.md; do
  [ "$f" = "CHANGELOG.md" ] || {
    hit=$(awk '/\| *(done|dropped) *\|/ { next }
               {
                 s = $0
                 while (match(s, /`template\/[^`]*`/)) {
                   print substr(s, RSTART + 1, RLENGTH - 2)
                   s = substr(s, RSTART + RLENGTH)
                 }
               }' "$f" | while IFS= read -r p; do
                 case "$p" in
                   *'*'*|*'{'*|*'<'*|*'$'*|*'~'*) continue ;;
                 esac
                 [ -e "$p" ] || printf '%s 引用不存在的路径：%s\n' "$f" "$p"
               done)
    [ -z "$hit" ] || ref_bad="$ref_bad
$hit"
  }
done
if [ -z "$ref_bad" ]; then
  ok "工具层文档引用的 template/ 路径均存在"
else
  bad "工具层文档引用了不存在的 template/ 路径：$ref_bad"
fi

if [ "$fail" -ne 0 ]; then
  printf '\n工具层门禁未通过：修正后再提交。不要用 --no-verify 绕过。\n' >&2
  exit 1
fi
printf '\n工具层 check-fast 全部通过。\n'