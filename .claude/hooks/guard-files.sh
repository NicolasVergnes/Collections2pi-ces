#!/usr/bin/env bash
# PreToolUse (Edit|Write) : protège secrets, migrations appliquées, releases publiées et le kit lui-même.
set -u
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // .tool_input.notebook_path // ""')
[ -z "$path" ] && exit 0

deny() {
  jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}
base=$(basename "$path")
case "$base" in
  .env|.env.*|*.pem|*.p8|*.p12|*.keystore|*.jks|*.mobileprovision|credentials.json|google-services.json|GoogleService-Info.plist)
    deny "Fichier de secrets ou de signature ($base) : jamais écrit par Claude. Demande à la personne." ;;
esac
case "$path" in
  */supabase/migrations/*)
    [ -f "$path" ] && deny "Migration existante : ne modifie jamais une migration appliquée. Crée-en une nouvelle : supabase migration new <verbe_objet>." ;;
  */releases/*)
    [ -f "$path" ] && deny "Release publiée : immuable. Crée une nouvelle version." ;;
  */.claude/settings.json|*/.claude/hooks/*)
    deny "Le kit Claude (settings, hooks) se modifie dans une PR dédiée avec l'accord de la personne." ;;
esac
exit 0
