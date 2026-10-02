# Versions de référence — vérifiées le 2026-09-30

Source de vérité pour les versions ciblées par le projet. À re-vérifier à chaque phase (ou au moins tous les trimestres) ; Claude Code n'installe jamais une version majeure différente sans ADR.

| Outil | Version cible | Note |
| --- | --- | --- |
| Node.js | 24 LTS (`.nvmrc` = 24) | 24 = Active LTS jusqu'au 20 oct. 2026, puis Node 26 devient LTS ; 20 est en fin de vie (avril 2026). Expo SDK 57 exige ≥ 22.13. Passer à 26 en phase 1 après vérification. |
| pnpm | 11.x | `packageManager` dans package.json ; pnpm 11 apporte lockfile integrity par défaut, `pnpm doctor`, `pnpm version -r`. |
| Turborepo | 2.10.x | `turbo run test --filter=...[origin/main]` pour `test:changed`. |
| TypeScript | 7.0.x (natif, Go) | Sorti le 8 juillet 2026, ~10× plus rapide, même `tsc`. Garder `typescript@6` en secours uniquement si un outil exige l'ancienne API JS (vérifier typescript-eslint). |
| Expo SDK | 57 (`expo@57.0.17+`) | React Native 0.86.3, React 19.2, Hermes V1, nouvelle architecture obligatoire. SDK 58 attendu sept./oct. 2026 : ne pas migrer en pleine phase, prévoir une tâche `chore`. Expo Go pour SDK 57 encore en attente côté Apple : utiliser un dev client (`eas build --profile development`). |
| Expo Router | même version que le SDK | Thèmes importés depuis `expo-router/react-navigation`. |
| TanStack Query | 5.101+ | |
| Zustand | 5.0.x | |
| Reanimated / Worklets | 4.5 / 0.10 | requis par VisionCamera 5 et fast-tflite 5. |
| react-native-vision-camera | 5.x (Nitro Modules) | V4 archivée et plus maintenue. Utilisée dès V1 pour la photo (objet `Photo` en mémoire → tenseur sans passer par le disque) ; `useFrameOutput` + `react-native-vision-camera-resizer` en V2 pour le direct. expo-camera n'est plus la voie principale. |
| react-native-fast-tflite | 5.x (Nitro Modules) | Config plugin `enableCoreMLDelegate`, `assetExts: ['tflite']` dans metro.config. |
| expo-sqlite + Drizzle | versions du SDK / drizzle-orm 0.4x | |
| Vitest | 5.0.x | ligne stable courante ; 4.1 reçoit encore les correctifs de sécurité. |
| Supabase CLI | ≥ 2.107 | `pg-delta` moteur de diff par défaut, `supabase test db` pour pgTAP, `supabase db advisors` pour les contrôles de sécurité. |
| Python | 3.13 | `requires-python = ">=3.13"` dans `ml/pyproject.toml`. |
| PyTorch + timm | dernière 2.x stable | à figer dans `uv.lock`. |
| Export mobile | `litert-torch` 0.9+ (ex `ai-edge-torch`) | TFLite s'appelle désormais LiteRT ; le format `.tflite` est inchangé. Quantification via AI Edge Quantizer. |
| CoreML | `coremltools` dernière 8.x | export iOS. |
| uv / ruff / pytest | dernières stables | |
| Maestro | dernière stable | |
| jq | 1.7+ | requis par les hooks. |

## GitHub Actions (runtime Node 24 obligatoire depuis juin 2026)
`actions/checkout@v6`, `actions/setup-node@v6`, `pnpm/action-setup@v6` (ou `pnpm/setup@v1` qui installe pnpm et Node en une étape), `astral-sh/setup-uv@v10`, `actions/setup-python@v6`, `supabase/setup-cli@v1`, `expo/expo-github-action@v8` (version non re-vérifiée le 2026-09-30 : contrôler au premier run).

## Comment re-vérifier
`pnpm outdated -r`, `npx expo install --check`, `uv lock --upgrade --dry-run`, et les pages de release d'Expo (expo.dev/changelog), TypeScript (devblogs.microsoft.com/typescript), Node (nodejs.org/en/about/previous-releases). Consigner la date en tête de ce fichier.
