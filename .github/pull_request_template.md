## Tâche
T-nnn — titre. Exigences couvertes : F… Cahier des charges § …

## Ce qui change
Trois lignes maximum.

## Ce qui n'est pas couvert, et pourquoi

## Preuves
- Tests ajoutés ou modifiés :
- Captures ou enregistrement Maestro :
- Mesures (si perf, taille, latence) : avant → après

## Definition of Done
- [ ] `pnpm typecheck && pnpm lint && pnpm test:changed` verts
- [ ] `spec-guardian` : CONFORME
- [ ] `reviewer` : PRÊT POUR PR
- [ ] `security-privacy-auditor` (si supabase/, comptes, photos, notifications) : OK POUR PR
- [ ] `ux-a11y-i18n` (si écran, composant ou chaîne visible) : sans bloquant
- [ ] Chaînes FR / EN / DE ajoutées
- [ ] Toute nouvelle table : RLS + test pgTAP
- [ ] ADR si décision structurante ; `CHANGELOG.md` (Unreleased) mis à jour
- [ ] Aucune dépendance ajoutée sans justification ci-dessous

## Dépendances ajoutées

## Risques et retour arrière

## À décider par la personne
