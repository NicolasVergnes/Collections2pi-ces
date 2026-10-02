---
name: testing-qa
description: Stratégie et conventions de test de Deux — pyramide par couche, Vitest pour le moteur et les packages, React Native Testing Library pour l'UI, pgTAP pour les politiques RLS, pytest pour le pipeline ML, Maestro pour les parcours, fixtures partagées, objectifs de couverture, liste des parcours de bout en bout. À charger avant d'écrire ou de modifier des tests.
---
# Tests

## Pyramide
1. `packages/core` : Vitest, 100 % des cas d'usage, couverture ≥ 80 % lignes. Pur, sans mock réseau, avec des implémentations en mémoire des ports (`test/fakes`).
2. `packages/plugin-eur2`, `plugin-demo`, `data-local`, `recognition`, `api-client` : Vitest ; SQLite en mémoire pour data-local ; Supabase local (`supabase start`) pour api-client en CI seulement.
3. `apps/mobile` : React Native Testing Library pour hooks et écrans (états chargement, vide, erreur, données, hors ligne) ; couverture ≥ 60 %.
4. `supabase/tests/*.test.sql` : pgTAP, un fichier par table ou vue ; lancés par `supabase test db`.
5. `ml/tests` : pytest sur augmentations (déterminisme avec seed), construction d'index, export (le modèle exporté donne le même top-1 que PyTorch sur 20 images), `eval` (échec sous les seuils).
6. `apps/mobile/e2e/*.yaml` : Maestro, parcours listés ci-dessous, exécutés sur build preview en CI nocturne.

## Fixtures partagées (`packages/core/test/fixtures`)
- `catalog-20.json` : 20 pièces réelles couvrant Allemagne (5 ateliers), émission commune, pièce de circulation, deux séries.
- `plugin-demo` : 12 objets fictifs, pour prouver que le moteur ignore les pièces.
- `users.ts` : Camille (collectionneuse), Lucas (aide), Théo (avancé, ateliers), Visiteur (sans compte).

## Conventions
- Un test = un comportement ; nom en anglais qui se lit comme une phrase : `it('marks the coin as duplicate when quantity exceeds keep', …)`.
- Pas de `sleep`, pas de réseau réel, pas de dépendance à l'ordre des tests, pas de snapshot d'écran entier.
- Les tests de synchro simulent conflits (LWW par champ), hors ligne prolongé et outbox partielle.
- `pnpm test:changed` = tests des packages modifiés depuis `origin/main` (turbo `--filter=...[origin/main]`).

## Parcours Maestro V1 (`apps/mobile/e2e`)
`onboarding.yaml` (sans compte → collection → premier scan), `scan-add.yaml` (photo → résultat → quantité → ajout), `scan-low-confidence.yaml` (trois candidats), `invite-accept.yaml` (lien → relation), `helper-mode.yaml` (aide → scan → « Camille ne l'a pas » → mise de côté), `offline.yaml` (mode avion → scan et ajout → synchro au retour), `delete-account.yaml`.

## Ce qu'on ne teste pas
Le rendu pixel des composants, les librairies tierces, les types TypeScript (le typecheck s'en charge).
