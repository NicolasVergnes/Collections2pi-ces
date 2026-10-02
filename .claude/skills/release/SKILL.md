---
name: release
description: Processus de livraison de Deux — versionnage de l'application, du catalogue et du modèle, profils EAS, politique de mises à jour OTA, changelog, métadonnées des stores, checklist avant soumission, plan de retour arrière. Ce que Claude prépare et ce que seule la personne exécute. À charger pour toute tâche de build, de version ou de publication.
---
# Livraison

## Versions
- Application : semver `MAJOR.MINOR.PATCH` dans `apps/mobile/app.config.ts` ; `buildNumber` / `versionCode` incrémentés par EAS (`autoIncrement`).
- Catalogue : `packages/plugin-eur2/data/VERSION` ; modèle : `ml/releases/LATEST`. `manifest.json` du modèle indique la version minimale de catalogue ; `catalog_releases.min_app_version` protège les anciennes applications.
- Un tag git `v1.2.0` par version soumise aux stores.

## Profils EAS (`eas.json`)
- `development` : dev client, simulateur autorisé, variables locales.
- `preview` : build interne (TestFlight interne, APK), canal `preview`, Supabase de staging.
- `production` : canal `production`, Supabase de production, soumission manuelle.
Claude peut lancer `eas build --profile development|preview` et `eas update --branch preview`. `eas build --profile production`, `eas submit` et `eas update --branch production` sont réservés à la personne.

## Mises à jour OTA
Autorisées pour corrections JS/TS et contenus sans changement natif ni de permission. Interdites si : nouvelle dépendance native, nouvelle permission, changement de schéma local sans migration testée. Chaque mise à jour cite la version d'application compatible (`runtimeVersion` = politique `appVersion`).

## Changelog et notes
`CHANGELOG.md` en français, section `Unreleased` alimentée par chaque PR. À la release : titre `## 1.2.0 — 2026-11-03`, puis notes de version stores en FR/EN/DE dans `store/release-notes/<version>.md` (≤ 500 caractères, sans promesse).

## Métadonnées stores (`store/`)
`listing.{fr,en,de}.md` (titre, sous-titre, description, mots-clés), `privacy-labels.md` (réponses App Privacy / Data safety, cohérentes avec le registre `privacy-rgpd`), `screenshots/` générés par Maestro sur build preview.

## Checklist avant soumission (Claude prépare, la personne coche)
- [ ] `pnpm typecheck && pnpm lint && pnpm test && pnpm e2e` verts sur build preview.
- [ ] `pnpm ml:eval` vert pour le modèle embarqué ; `pnpm catalog:validate` vert.
- [ ] Changelog et notes de version FR/EN/DE.
- [ ] Labels de confidentialité à jour.
- [ ] Suppression de compte testée sur staging.
- [ ] Tag git créé ; migrations appliquées en production par la CI ; release catalogue/modèle signée et publiée.

## Retour arrière
- OTA : `eas update --branch production --republish` vers le groupe précédent (personne).
- Natif : nouvelle soumission ; en attendant, `feature_flags` côté serveur pour désactiver la fonctionnalité fautive.
- Catalogue/modèle : `catalog_releases.published_at = null` retire la release ; l'application garde la précédente.
