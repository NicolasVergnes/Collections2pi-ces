---
name: project-workflow
description: Conventions de travail du projet Deux — branches, commits, format des tâches du backlog, structure d'une PR, ADR, changelog, et quand s'arrêter pour demander à la personne. À charger pour toute tâche de développement, de revue ou de planification.
---
# Workflow du projet

## Branches et commits
- `main` protégée : jamais de push direct, jamais de force push. Une PR par tâche.
- Branches : `feat/<F-id>-<slug>`, `fix/<slug>`, `chore/<slug>`, `data/<slug>` (catalogue), `ml/<slug>`.
- Commits Conventional Commits, en anglais, sujet ≤ 72 caractères, exigence entre parenthèses : `feat(scan): show top-3 candidates below 0.80 (F3.2)`.
- Rebase sur `origin/main` avant PR (`git rebase origin/main`), pas de merge commits dans la branche.

## Backlog (`docs/backlog.md`)
Format d'une tâche :
`- [ ] **T-012** (F4.5, F4.9) Mise de côté par un aide — critères : bouton visible sans défiler ; notification au collectionneur ; annulation possible 7 jours — étiquettes : v1`
- Étiquettes : `v1` `v2` `v3` `needs-human` `blocked` `data` `ml`.
- Une tâche sans critères vérifiables est renvoyée : ajoute des critères, marque `needs-human`, passe à la suivante.
- On coche avec le numéro de PR : `- [x] **T-012** … — PR #41`.

## PR
Gabarit dans `.github/pull_request_template.md`. Titre = sujet du commit principal. Corps : exigences couvertes, ce qui n'est pas couvert et pourquoi, tests, captures, risques, décisions demandées.
La personne dispose de 30 minutes par jour pour le suivi et la revue (décision T-001) : vise des PR qui se relisent dans ce temps.

## ADR
Toute décision structurante (dépendance majeure, schéma de données, protocole de synchro, choix ML) → `docs/adr/NNNN-titre.md` d'après `docs/adr/template.md`, dans la même PR.

## Changelog
`CHANGELOG.md`, section `Unreleased`, une ligne par changement visible pour l'utilisateur, en français.

## Quand s'arrêter et demander
- Question juridique (droits d'images, RGPD), coût récurrent, secret, publication, choix de design non tranché → question dans la PR, tâche `needs-human`, tâche suivante.
- Trois échecs successifs du hook Stop sur la même cause → PR en brouillon avec description du blocage, plutôt que contourner ou désactiver un test.
- Doute sur le sens d'une exigence → cite la phrase du cahier des charges, propose une lecture, demande.

## Ce qu'on ne fait pas
- Désactiver un test, un lint ou un hook pour « faire passer ».
- Ajouter une dépendance sans ligne de justification dans la PR.
- Mettre une donnée de catalogue non sourcée.
- Fusionner soi-même.
