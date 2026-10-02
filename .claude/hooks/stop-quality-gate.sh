#!/usr/bin/env bash
# Stop : si du code a changé, exige typecheck + lint + tests verts ; sinon empêche l'arrêt et renvoie l'extrait.
set -u
input=$(cat)
if [ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ]; then
  exit 0   # déjà relancé par ce hook : on ne boucle pas indéfiniment
fi
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0
[ -f package.json ] || exit 0

scope="apps packages supabase ml tools"
changed=0
base=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null || echo "")
if [ -n "$base" ]; then git diff --quiet "$base" -- $scope 2>/dev/null || changed=1; fi
git diff --quiet -- $scope 2>/dev/null || changed=1
git diff --cached --quiet -- $scope 2>/dev/null || changed=1
[ -n "$(git ls-files --others --exclude-standard -- $scope 2>/dev/null)" ] && changed=1
[ "$changed" = "0" ] && exit 0

log=$(mktemp)
ok=1
{ echo "## typecheck"; pnpm -s typecheck; } >"$log" 2>&1 || ok=0
{ echo "## lint"; pnpm -s lint; } >>"$log" 2>&1 || ok=0
{ echo "## tests (packages modifiés)"; pnpm -s test:changed; } >>"$log" 2>&1 || ok=0
if [ "$ok" = "1" ]; then
  rm -f "$log"
  exit 0
fi
excerpt=$(tail -c 6000 "$log")
rm -f "$log"
jq -cn --arg head "Contrôle qualité rouge (typecheck, lint ou tests). Corrige, puis relance pnpm typecheck && pnpm lint && pnpm test:changed avant de t'arrêter. Extrait :" \
       --arg log "$excerpt" '{decision:"block", reason:($head + "\n" + $log)}'
exit 0
