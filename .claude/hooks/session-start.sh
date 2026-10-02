#!/usr/bin/env bash
# SessionStart : injecte le contexte de travail (stdout = contexte lu par Claude).
set -u
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
echo "Contexte Deux — $(date '+%Y-%m-%d %H:%M')"
echo "Branche : $branch"
status=$(git status --porcelain 2>/dev/null | head -n 15)
if [ -n "$status" ]; then
  echo "Modifications non commitées :"
  echo "$status"
else
  echo "Arbre de travail propre."
fi
if [ -f .claude/state/current-task.md ]; then
  echo "Tâche en cours :"
  head -n 20 .claude/state/current-task.md
fi
[ -f packages/plugin-eur2/data/VERSION ] && echo "Catalogue : $(cat packages/plugin-eur2/data/VERSION)"
[ -f ml/releases/LATEST ] && echo "Modèle : $(cat ml/releases/LATEST)"
if [ -f docs/backlog.md ]; then
  echo "Prochaines tâches non cochées :"
  grep -n '^- \[ \]' docs/backlog.md | head -n 6
fi
echo "Rappel : une PR par tâche, jamais de push sur main, le hook Stop exige typecheck + lint + tests verts."
exit 0
