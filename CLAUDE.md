# Deux — application de collection de pièces de 2 €

Tu développes cette application de façon autonome, tâche par tâche, à partir de `docs/backlog.md`.
La source de vérité fonctionnelle est `docs/cahier-des-charges.md` (exigences F1.1 à F8.3, section 3 ; données, architecture et reconnaissance, sections 5 à 7). Si le backlog et le cahier des charges divergent, le cahier des charges gagne ; si le cahier des charges est muet, arrête-toi et pose la question dans la PR.

## Stack (ADR 0001)
- Monorepo pnpm 11 + Turborepo 2.10, TypeScript 7 (natif) strict partout, Node 24 LTS. Versions cibles et date de vérification dans `docs/versions.md` ; aucune montée de version majeure sans ADR.
- `apps/mobile` : Expo SDK 57 (React Native 0.86, React 19.2, nouvelle architecture), Expo Router, Zustand + TanStack Query, expo-sqlite + Drizzle, react-native-vision-camera 5 et react-native-fast-tflite 5 (Nitro Modules) dès V1, mode caméra en direct en V2.
- `packages/core` : moteur pur (entités, cas d'usage, ports). Aucune dépendance React Native. Il ignore tout des pièces.
- `packages/plugin-eur2` : catalogue 2 € et règles de variantes. `packages/plugin-demo` : plugin de preuve.
- `packages/recognition`, `packages/data-local` (SQLite, outbox, synchro), `packages/api-client` (Supabase), `packages/ui` (composants et jetons).
- `supabase/` : migrations, RLS, Edge Functions (Deno), tests pgTAP. Projet en région UE.
- `ml/` : Python 3.13 + uv, PyTorch, export LiteRT (`.tflite`, via litert-torch) et CoreML. `tools/catalog` : import BCE → JSON, release.

## Commandes
| Commande | Rôle |
| --- | --- |
| `pnpm install` | dépendances |
| `pnpm dev` | serveur de développement Expo |
| `pnpm typecheck` · `pnpm lint` · `pnpm test` | qualité sur tout le monorepo |
| `pnpm test:changed` | tests des packages modifiés depuis origin/main (utilisé par le hook Stop) |
| `pnpm catalog:validate [--file <chemin>]` | validation du catalogue JSON |
| `pnpm catalog:release` | construit une version du catalogue (signature par la personne) |
| `supabase start` · `supabase db reset` · `supabase test db` | base locale et tests SQL |
| `pnpm ml:eval` | évalue la release de modèle courante sur le jeu réel |
| `pnpm e2e` | parcours Maestro sur build preview |

## Conventions
- Une PR = une tâche du backlog ; branche `feat/<F-id>-<slug>` ; commits Conventional Commits en anglais avec l'exigence : `feat(helper): set-aside flow (F4.5)`.
- Hors ligne d'abord : lecture et écriture locales, synchronisation ensuite.
- Écran → hook → cas d'usage → port. Jamais de SQL, de Supabase ni de TFLite dans un composant.
- Trois thèmes commutables (Musée, Terrain, Album ; défaut `album`) : les composants lisent `useTheme()`, jamais une couleur, une police ou un rayon en dur ; aucun `if` sur le thème dans un écran.
- Aucune chaîne en dur dans l'UI : `t('helper.result.missing', { name })`, FR/EN/DE dans la même PR.
- Chaque table Supabase = politiques RLS + test pgTAP dans la même migration.
- Les photos ne quittent jamais l'appareil sans opt-in explicite.
- Aucun secret dans le dépôt ; `.env*` est hors de portée (permissions et hook).
- Une donnée de catalogue inconnue vaut `null`, jamais une estimation, et chaque pièce cite ses sources.

## Definition of Done
Voir `.github/pull_request_template.md`. Le hook Stop bloque la fin de session tant que `pnpm typecheck`, `pnpm lint` et `pnpm test:changed` ne sont pas verts sur du code modifié.

## Interdits (les hooks les bloquent aussi)
`git push --force`, push ou checkout sur `main`, `eas submit`, `eas update` vers production, `supabase db reset --linked`, `supabase db push`, `sudo`, `rm -rf`, `curl | sh` ; modifier une migration appliquée, une release publiée, `.claude/settings.json` ou `.claude/hooks/` ; fusionner une PR ; désactiver un test, un lint ou un hook pour faire passer.

## Skills et agents
- Skills chargés selon la zone : `project-workflow` (toujours), `mobile-expo`, `backend-supabase`, `catalog-eur2`, `coin-recognition-ml`, `design-system`, `testing-qa`, `i18n-copy`, `privacy-rgpd`, `release`. `/next-task` lance la boucle complète.
- Agents : `spec-guardian` avant d'implémenter et avant la PR ; `reviewer` sur chaque tâche ; `test-engineer` si la couverture manque ; `security-privacy-auditor` pour supabase/, comptes, photos, notifications ; `ux-a11y-i18n` pour tout écran ou texte visible ; `catalog-curator` pour le catalogue ; `ml-engineer` pour ml/.
- Rôle de la personne : tranche les questions `needs-human`, fusionne les PR, détient les secrets et clés de signature, publie sur les stores.
