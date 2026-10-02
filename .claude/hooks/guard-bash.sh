#!/usr/bin/env bash
# PreToolUse (Bash) : refuse les commandes destructrices ou qui court-circuitent la revue humaine.
# Sortie JSON permissionDecision=deny → la commande n'est pas exécutée, la raison est montrée à Claude.
set -u
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
[ -z "$cmd" ] && exit 0

deny() {
  jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}
has() { printf '%s' "$cmd" | grep -Eq "$1"; }

has 'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f|rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r' \
  && deny "rm -rf interdit. Supprime fichier par fichier, ou demande à la personne."
has '(^|[^[:alnum:]_])sudo([^[:alnum:]_]|$)' \
  && deny "sudo interdit."
has 'git[[:space:]]+push[^|&;]*(--force|-f([[:space:]]|$)|--force-with-lease)' \
  && deny "Push forcé interdit : l'historique est partagé."
has 'git[[:space:]]+push([^|&;]*[[:space:]])?(origin[[:space:]]+)?(main|master)([[:space:]]|:|$)' \
  && deny "Push direct sur main interdit : ouvre une PR depuis une branche feat/…"
has 'git[[:space:]]+push[^|&;]*:(main|master)([[:space:]]|$)' \
  && deny "Push direct sur main interdit : ouvre une PR depuis une branche feat/…"
has 'git[[:space:]]+(checkout|switch)[[:space:]]+(main|master)([[:space:]]|$)' \
  && deny "Ne travaille pas sur main : git fetch origin && git switch -c feat/<id>-<slug> origin/main"
has 'supabase[[:space:]]+db[[:space:]]+(reset|push|remote)[^|&;]*--linked|supabase[[:space:]]+db[[:space:]]+push' \
  && deny "La base distante est réservée à la personne et à la CI (migrations appliquées par le pipeline)."
has 'eas[[:space:]]+submit' \
  && deny "eas submit est réservé à la personne."
has 'eas[[:space:]]+update[^|&;]*--(branch|channel)[[:space:]=]+(production|prod)([[:space:]]|$)' \
  && deny "Les mises à jour OTA de production sont réservées à la personne."
has 'curl[^|&;]*\|[[:space:]]*(sh|bash)([[:space:]]|$)' \
  && deny "curl | sh interdit : installe via pnpm, uv ou un paquet vérifié."
exit 0
