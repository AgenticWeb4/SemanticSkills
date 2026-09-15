#!/usr/bin/env bash
# 通用 skill QA 模板：布局 + skills-ref + markdownlint + skillcheck。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
QA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$QA_DIR/../../../skills/cn/claude-md-cn" && pwd)"

fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || fail "missing command: $1"; }

run_local_or_npx() {
  local bin=$1; shift
  if command -v "$bin" >/dev/null 2>&1; then "$bin" "$@"
  else need_cmd npx; npx "$bin" "$@"; fi
}

# skill 安装包纯度：不含 eval/qa/.workspaces 等
check_skill_layout() {
  [[ -f "$SKILL_DIR/SKILL.md" ]] || fail "missing SKILL.md"
  [[ -f "$QA_DIR/README.md" ]] || fail "missing QA README"
  local item
  local forbidden=(.DS_Store .agents analysis evals qa scripts tests .workspaces)
  for item in "${forbidden[@]}"; do
    [[ ! -e "$SKILL_DIR/$item" ]] || fail "forbidden in skill dir: $item"
  done
  local sibling
  for sibling in "$SKILL_DIR"/*-workspace; do
    [[ -e "$sibling" ]] || continue
    fail "Skill Creator workspace belongs at repo root, not skills/: $(basename "$sibling")"
  done
  [[ -f "$QA_DIR/evals/evals.json" ]] || fail "missing evals file: $QA_DIR/evals/evals.json"
  [[ -f "$QA_DIR/assertions/README.md" ]] || fail "missing assertions guide"
  [[ ! -f "$QA_DIR/evals.json" ]] || fail "duplicate eval source: $QA_DIR/evals.json"
}

need_cmd rg
check_skill_layout
# skills-ref 只接受通用规范字段；单独检查 Claude/Codex 的显式调用扩展，
# 再用临时副本验证通用字段，安装载荷保持不变。
rg -q '^disable-model-invocation: true$' "$SKILL_DIR/SKILL.md" || fail "Claude implicit invocation must be disabled"
rg -q '^  allow_implicit_invocation: false$' "$SKILL_DIR/agents/openai.yaml" || fail "Codex implicit invocation must be disabled"
CHECK_ROOT=$(mktemp -d)
trap 'rm -rf "$CHECK_ROOT"' EXIT
mkdir "$CHECK_ROOT/claude-md-cn"
sed '/^disable-model-invocation: true$/d' "$SKILL_DIR/SKILL.md" > "$CHECK_ROOT/claude-md-cn/SKILL.md"
run_local_or_npx skills-ref validate "$CHECK_ROOT/claude-md-cn"
run_local_or_npx markdownlint-cli2 --config "$QA_DIR/.markdownlint.json" "$SKILL_DIR/**/*.md"
need_cmd skillcheck
skillcheck "$SKILL_DIR" --target-agent cursor --strict-cursor --min-desc-score 70

printf 'OK: claude-md-cn validation passed\n'
