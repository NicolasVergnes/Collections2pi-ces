#!/usr/bin/env bash
# PostToolUse (Edit|Write) : valide toute entrée de catalogue modifiée ; erreurs renvoyées à Claude (exit 2).
set -u
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // ""')
case "$path" in
  */packages/plugin-eur2/data/*.json) ;;
  *) exit 0 ;;
esac
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0
if out=$(pnpm -s catalog:validate --file "$path" 2>&1); then
  exit 0
fi
printf 'Validation du catalogue échouée pour %s :\n%s\n' "$path" "$out" >&2
exit 2
