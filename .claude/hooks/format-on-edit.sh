#!/usr/bin/env bash
# PostToolUse (Edit|Write) : formate le fichier touché ; renvoie les erreurs de lint à Claude (exit 2).
set -u
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // ""')
[ -n "$path" ] && [ -f "$path" ] || exit 0
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0
case "$path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.md|*.yml|*.yaml)
    pnpm -s exec prettier --log-level silent --write "$path" >/dev/null 2>&1 || true
    case "$path" in
      *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
        if ! out=$(pnpm -s exec eslint --fix "$path" 2>&1); then
          printf 'ESLint signale des problèmes dans %s :\n%s\n' "$path" "$out" >&2
          exit 2
        fi ;;
    esac ;;
  *.py)
    ruff format "$path" >/dev/null 2>&1 || true
    if ! out=$(ruff check --fix "$path" 2>&1); then
      printf 'ruff signale des problèmes dans %s :\n%s\n' "$path" "$out" >&2
      exit 2
    fi ;;
  *.sql)
    command -v sqlfluff >/dev/null 2>&1 && sqlfluff fix --dialect postgres --force "$path" >/dev/null 2>&1 || true ;;
esac
exit 0
