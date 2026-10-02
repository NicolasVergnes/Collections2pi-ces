---
name: next-task
description: Lance la boucle de développement autonome de Deux — prend la prochaine tâche du backlog (ou celle passée en argument), la planifie, l'implémente avec les skills et agents du projet, passe la Definition of Done et ouvre une PR.
argument-hint: [identifiant de tâche, ex. T-012, optionnel]
disable-model-invocation: true
---
# /next-task $ARGUMENTS

## 1. Choisir la tâche
- Sans argument : première ligne `- [ ]` de `docs/backlog.md` sans étiquette `blocked` ni `needs-human`.
- Avec argument : la tâche dont l'identifiant correspond.
- Écris identifiant, titre, exigences F-xx et critères dans `.claude/state/current-task.md`.

## 2. Comprendre
- Lis les exigences F-xx citées, dans `docs/cahier-des-charges.md` section 3 ; sections 5 à 7 si la tâche touche données, architecture ou reconnaissance.
- Charge le skill de la zone : `mobile-expo`, `backend-supabase`, `catalog-eur2`, `coin-recognition-ml`, `design-system`.
- Écris un plan de 5 à 15 lignes (fichiers, cas d'usage, tests). Appelle `spec-guardian` avec l'identifiant ; corrige le plan selon son retour.
- Si la tâche exige une décision humaine (droits d'images, coût, secret, choix de design non tranché), marque-la `needs-human` dans le backlog, explique pourquoi, et passe à la suivante.

## 3. Préparer la branche
`git fetch origin && git switch -c feat/<F-id>-<slug> origin/main` — jamais de travail sur main.

## 4. Implémenter
- Tests d'abord pour les cas d'usage de `packages/core`, puis le code, puis l'UI.
- Petits commits Conventional Commits en anglais avec l'exigence : `feat(helper): set-aside flow (F4.5)`.
- Appelle `test-engineer` si la couverture des cas d'usage touchés est incomplète.

## 5. Definition of Done
- `pnpm typecheck && pnpm lint && pnpm test:changed` verts (le hook Stop le vérifie).
- `reviewer` ; puis `security-privacy-auditor` si `supabase/`, comptes, photos ou notifications ; `ux-a11y-i18n` si écran, composant ou chaîne visible.
- Chaînes FR/EN/DE ajoutées ; RLS + test pgTAP pour toute table ; ADR pour toute décision structurante ; `CHANGELOG.md` (Unreleased) mis à jour.

## 6. Ouvrir la PR
- `git push -u origin <branche>` puis `gh pr create --fill --body "$(cat .github/pull_request_template.md)"` en complétant le gabarit : exigences couvertes, tests, captures ou enregistrement Maestro, risques, points à décider.
- Coche la tâche dans `docs/backlog.md` avec le numéro de PR. Vide `.claude/state/current-task.md`.
- Termine par un résumé de 5 lignes : fait, restant, à décider par la personne.

Tu ne fusionnes jamais la PR : c'est la personne qui fusionne.
