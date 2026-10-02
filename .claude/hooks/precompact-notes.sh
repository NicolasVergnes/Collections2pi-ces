#!/usr/bin/env bash
# PreCompact : sauvegarde l'état de travail avant compaction du contexte.
set -u
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0
mkdir -p docs/session-notes
f="docs/session-notes/$(date '+%Y-%m-%d-%H%M').md"
{
  echo "# Note de session — $(date '+%Y-%m-%d %H:%M')"
  echo
  echo "Branche : $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo
  echo "## Tâche en cours"
  if [ -f .claude/state/current-task.md ]; then cat .claude/state/current-task.md; else echo "(aucune)"; fi
  echo
  echo "## Fichiers modifiés"
  git status --short 2>/dev/null
  echo
  echo "## Diff (stat)"
  git diff --stat 2>/dev/null
} > "$f"
exit 0
