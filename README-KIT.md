# Kit Claude Code — Deux

Ce dossier contient tout ce qu'il faut pour que Claude Code développe l'application de façon autonome, tâche par tâche, avec des garde-fous.

## Contenu
```
CLAUDE.md                          mémoire du projet (stack, commandes, conventions, interdits)
.claude/settings.json              permissions allow/deny + hooks
.claude/hooks/*.sh                 session-start, guard-bash, guard-files, format-on-edit, validate-catalog, stop-quality-gate, precompact-notes
.claude/agents/*.md                spec-guardian, reviewer, test-engineer, security-privacy-auditor, catalog-curator, ml-engineer, ux-a11y-i18n
.claude/skills/*/SKILL.md          next-task, project-workflow, mobile-expo, backend-supabase, catalog-eur2 (+ schéma et exemple), coin-recognition-ml, design-system, testing-qa, i18n-copy, privacy-rgpd, release
.claude/state/current-task.md      tâche en cours (écrite par /next-task)
docs/cahier-des-charges.md         source de vérité fonctionnelle
docs/backlog.md                    tâches, dans l'ordre de prise
docs/adr/                          décisions d'architecture (0001 = stack) et gabarit
docs/versions.md                   versions cibles des outils et date de dernière vérification
.github/pull_request_template.md   Definition of Done
.github/workflows/ci.yml           typecheck, lint, tests, catalogue, pgTAP, ML si modifié, build preview sur étiquette
CHANGELOG.md
```

## Installation
1. Crée le dépôt vide (`git init deux && cd deux`), copie le contenu de ce kit à la racine, puis `chmod +x .claude/hooks/*.sh`.
2. Installe les outils aux versions de `docs/versions.md` (vérifiées le 2026-09-30) : Node 24 LTS, pnpm 11, `jq` (les hooks en dépendent), Supabase CLI, Docker, `uv`, `gh` (connecté), EAS CLI. Optionnels : Maestro, sqlfluff.
3. Les scripts `package.json` à la racine doivent exister, même vides au début : `dev`, `typecheck`, `lint`, `test`, `test:changed` (`turbo run test --filter=...[origin/main]`), `catalog:validate`, `catalog:release`, `ml:eval`, `e2e`, `perf:startup`. La tâche T-010 les crée ; d'ici là, le hook Stop est inactif tant que `package.json` n'existe pas.
4. Commit initial sur `main`, dépôt GitHub créé, `main` protégée (revue requise, pas de force push).
5. Remplace `docs/cahier-des-charges.md` par l'export Markdown du Claude Doc (Partager › Exporter). Puis renseigne les deux décisions du backlog : T-000 (direction de design dans `.claude/skills/design-system/SKILL.md`) et T-001 (questions ouvertes de la section 12 du cahier des charges).

## Lancer une session
```
claude                       # à la racine du dépôt ; accepte la confiance du dossier
/next-task                   # prend la première tâche non cochée, ouvre une PR à la fin
/next-task T-030             # une tâche précise
```
Pour une session longue sans confirmation des éditions : `claude --permission-mode acceptEdits`. Pour laisser tourner plusieurs tâches d'affilée : relancer `/next-task` après chaque PR, ou en mode non interactif `claude -p "/next-task" --permission-mode acceptEdits` dans une boucle shell qui s'arrête sur une tâche `needs-human`.

## Ce que les garde-fous font
- `guard-bash` refuse : `rm -rf`, `sudo`, push forcé, push ou checkout sur `main`, `supabase db push/reset --linked`, `eas submit`, OTA de production, `curl | sh`.
- `guard-files` refuse d'écrire : `.env*`, clés et keystores, migrations déjà appliquées, releases publiées, le kit lui-même.
- `format-on-edit` formate et renvoie les erreurs de lint à Claude ; `validate-catalog` renvoie les erreurs de schéma.
- `stop-quality-gate` empêche Claude de s'arrêter tant que typecheck, lint et tests des packages modifiés ne passent pas.
- `precompact-notes` écrit une note dans `docs/session-notes/` avant chaque compaction ; `session-start` réinjecte branche, tâche en cours, versions et prochaines tâches.

## Réglages personnels
`.claude/settings.local.json` (ignoré par git) pour ajouter des permissions ou désactiver un hook localement, sans toucher au kit versionné.

## Ce que seule la personne fait
Fusionner les PR, détenir les secrets et la clé Ed25519 de signature des releases, appliquer les migrations distantes (via la CI), `eas submit`, OTA de production, trancher les tâches `needs-human`.
