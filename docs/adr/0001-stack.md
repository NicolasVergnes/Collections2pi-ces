# ADR 0001 — Stack technique

- Date : 2026-09-30
- Statut : accepté
- Tâche : T-010

## Contexte
Application mobile iOS et Android, hors ligne d'abord, avec reconnaissance d'image sur l'appareil, une couche sociale légère, un catalogue fini (~700 dessins) et un budget d'hébergement < 100 €/mois à 10 000 utilisateurs actifs. Développement majoritairement autonome par Claude Code : la stack doit être stable, très documentée et testable sans appareil physique.

## Décision
- Expo SDK 57 (React Native 0.86, nouvelle architecture) + TypeScript 7, Expo Router, Zustand + TanStack Query, expo-sqlite + Drizzle, react-native-vision-camera 5 et react-native-fast-tflite 5 (Nitro Modules) ; monorepo pnpm 11 + Turborepo 2.10, Node 24 LTS. Versions figées dans `docs/versions.md`.
- Supabase (Postgres, Auth anonyme convertible, Storage, Edge Functions, Realtime) en région UE, avec RLS sur toute table.
- Reconnaissance par embeddings (EfficientNet-Lite0 + ArcFace, 128-d) et kNN sur l'appareil ; ajout d'une pièce sans réentraînement ; export LiteRT (`.tflite`, litert-torch) et CoreML.
- Moteur générique (`packages/core`) + plugin `eur2` + plugin `demo` ; catalogue JSON validé par schéma, publié en releases signées Ed25519.

## Options écartées
- Flutter : bon candidat, mais l'écosystème TFLite/caméra et la densité de documentation Expo servent mieux un développement autonome ; une seule langue (TypeScript) sur toute la pile.
- Firebase : pas de Postgres ni de RLS ; hébergement UE moins simple à garantir ; coût moins prévisible.
- Classification fermée (une classe par pièce) : oblige à réentraîner à chaque nouvelle émission (environ 25 par an).
- Backend maison (Node + Postgres) : plus de surface à sécuriser et à opérer pour une personne seule.

## Conséquences
- Facile : itération rapide, OTA pour le JS, tests unitaires sans appareil, RLS comme frontière de sécurité.
- Difficile : dépendance à Supabase (atténuée par les ports et le SQL standard), taille du modèle à surveiller (≤ 12 Mo), performance de la grille sur Android bas de gamme.
- À surveiller : coût Supabase au-delà de 10 k MAU, écosystème Nitro Modules (VisionCamera 5, fast-tflite 5, worklets) encore jeune, passage à Expo SDK 58 et Node 26 à l'automne 2026, licences des images.
