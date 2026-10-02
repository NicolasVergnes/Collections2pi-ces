---
name: mobile-expo
description: Conventions de l'application Expo/React Native de Deux — structure par fonctionnalité, Expo Router, état (Zustand + TanStack Query), base locale SQLite/Drizzle et synchronisation, caméra et inférence via ports, images, accessibilité, mode Aide, compte anonyme, performance. À charger pour tout fichier de apps/mobile, packages/ui, packages/data-local ou packages/recognition.
---
# Application mobile

## Structure
```
apps/mobile/
  app/                       routes Expo Router : un fichier = un écran, zéro logique métier
  src/features/<feature>/    screens/ components/ hooks/ model.ts (appels aux cas d'usage de core)
  src/providers/             conteneur d'injection : implémentations des ports
  src/i18n/                  fr.json en.json de.json
  e2e/                       parcours Maestro
```
Fonctionnalités V1 : `collection`, `catalog`, `scan`, `friends`, `helper`, `account`, `settings`.
Versions : Expo SDK 57 (`npx expo install --check` avant toute montée), voir `docs/versions.md`. SDK 58 attendu à l'automne 2026 : migration dans une tâche `chore` dédiée, jamais au milieu d'une fonctionnalité.

## Règles d'architecture
- Écran → hook de feature → cas d'usage de `packages/core` → ports. Jamais de SQL, de Supabase ni de TFLite dans un composant.
- Ports (dans `packages/core/src/ports`) : `CatalogPort`, `RecognizerPort`, `CollectionRepository`, `SocialRepository`, `ReleaseChecker`, `FeatureFlags`. Une implémentation par port dans `packages/data-local`, `packages/recognition`, `packages/api-client`.
- Hors ligne d'abord : lecture et écriture locales (Drizzle sur expo-sqlite) ; chaque écriture ajoute une entrée à l'outbox ; `packages/data-local/sync` pousse l'outbox et tire les changements (LWW par champ avec `updated_at`).
- État serveur = TanStack Query (clés `['collection', collectionId]`, `['friendWants', friendId]`) ; état UI = Zustand. Jamais la même donnée aux deux endroits.
- Le moteur ignore les pièces : toute règle propre aux 2 € (ateliers allemands, périmètres, catégories) vit dans `packages/plugin-eur2`.

## Écrans et composants
- Listes : FlashList avec `estimatedItemSize` ; images : expo-image avec cache disque ; vignettes WebP embarquées, HD à la demande.
- Composants partagés dans `packages/ui` : `CoinTile`, `ScanResultCard`, `ProgressRing`, `HelperHero`, `StatusChip`, `MintMarkPicker`, `QuantityStepper`. Jetons de couleur et typographie depuis `packages/ui/tokens` (skill `design-system`).
- Caméra : react-native-vision-camera 5 (Nitro Modules) dès V1 — capture photo en mémoire (`Photo`) transmise à `RecognizerPort` sans écriture disque ; en V2, `useFrameOutput` + `react-native-vision-camera-resizer` pour le direct. Requiert `react-native-worklets` et un dev client (pas Expo Go). L'inférence passe par `RecognizerPort.identify(image)` qui renvoie `{ candidates: [{ variantId, score }], quality }` ; l'implémentation dans `packages/recognition` utilise react-native-fast-tflite 5 (`enableCoreMLDelegate` sur iOS, `assetExts: ['tflite']` dans metro.config).
- Mode Aide : un seul écran, bouton scanner ≥ 64 pt, résultat en une phrase avec le prénom, bouton « Mise de côté » visible sans défiler, fonctionne hors ligne via le cache `friend_wants`.
- Compte anonyme : toute action sociale appelle `ensureSession()` qui crée un compte anonyme Supabase si besoin ; la conversion en compte complet conserve l'id utilisateur.

## Accessibilité
`accessibilityLabel` et `accessibilityRole` sur tout contrôle ; cibles ≥ 44 pt ; `allowFontScaling` respecté ; statut = icône + couleur + mot ; contraste vérifié avec les jetons.

## Performance
Cibles : démarrage à froid < 2 s, photo → résultat < 1,5 s, 60 i/s sur une grille de 1 000 pièces, application < 60 Mo. Mesure sur build release (`pnpm perf:startup`) avant et après une tâche qui touche le démarrage, la grille ou le scan.

## Tests
Vitest + React Native Testing Library pour hooks et composants (états chargement, vide, erreur, données) ; Maestro pour onboarding, scan, invitation, mode Aide (skill `testing-qa`).
