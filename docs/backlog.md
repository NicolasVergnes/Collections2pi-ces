# Backlog — Deux

Format : `- [ ] **T-nnn** (exigences) Titre — critères : … — étiquettes : …`. Étiquettes : `v1` `v2` `v3` `needs-human` `blocked` `data` `ml`. Une tâche cochée cite sa PR. L'ordre est l'ordre de prise.

## Décisions attendues de la personne
- [x] **T-000** Choisir le thème par défaut parmi les trois (A Musée, B Terrain, C Album) ; les trois restent commutables dans Réglages › Apparence — décidé le 2026-09-30 : `album` (reporté dans le skill `design-system`)
- [x] **T-001** Trancher les questions ouvertes du cahier des charges, section 12 (nom, circulation avec millésime en V1, source d'images, import Numista, prix Premium) — décidé le 2026-10-02 : nom affiché `Collection2pièces` en V1 ; V1 = commémoratives et faces nationales de circulation, millésimes en V2 ; images de référence de la BCE (droits à vérifier, T-042) ; import Numista en V2 ; V1 gratuite, lancement dans toute l'Europe, FR/EN/DE ; comptes développeur au nom de la personne, à créer ; revue des PR 30 min par jour ; options de partage entre amis en V1, rien de partagé par défaut (F4.12) — reporté dans le cahier des charges et le skill `project-workflow` — PR #1

## Phase 0 — Fondations (semaines 1 à 3)
- [ ] **T-009** Aligner le backlog sur le cahier des charges — critères : chaque tâche cite les identifiants F-xx actuels (ex. T-026 et T-032 citent F6 alors que les comptes sont en F5 ; T-029 cite F4.3, qui est le mode Aide ; T-031 cite F4.7, qui est les suggestions d'échange ; T-051 cite F5.1 et F5.2 pour les échanges suivis, qui sont F4.8) ; chaque exigence V1 est couverte par une tâche ou explicitement reportée (relevé automatique à confirmer, exigences V1 sans tâche : F1.5, F1.6, F1.7, F2.6, F2.7, F3.6, F3.9, F4.9, F4.10, F4.11, F5.3 à F5.6, F7.2, F7.3, F8.1, F8.2) ; avis `spec-guardian` sans bloquant — étiquettes : v1
- [ ] **T-010** (§6) Initialiser le monorepo pnpm + Turborepo — critères : `apps/mobile` Expo TypeScript strict démarre sur Android, nom affiché `Collection2pièces` (iOS vérifié dès que le compte Apple existe, voir T-036) ; `packages/core` vide avec Vitest ; scripts `typecheck`, `lint`, `test`, `test:changed` définis à la racine ; projet Supabase initialisé (`supabase init`) avec un test pgTAP minimal, les tables arrivant avec T-015 ; CI verte sur tous les jobs — étiquettes : v1
- [ ] **T-011** (§6) Définir les ports du moteur dans `packages/core/src/ports` — critères : `CatalogPort`, `RecognizerPort`, `CollectionRepository`, `SocialRepository`, `ReleaseChecker`, `FeatureFlags` typés et documentés ; implémentations en mémoire dans `test/fakes` — étiquettes : v1
- [ ] **T-012** (F1.1, F1.2, §5) Schéma du catalogue et validation — critères : `coin.schema.json` appliqué par `pnpm catalog:validate` ; refus d'un id dupliqué, d'une langue manquante, de `sources` vide ; 20 pièces de fixture valides — étiquettes : v1 data
- [ ] **T-013** (F1.1) Importer les 2 € commémoratives 2004–2026 depuis la liste BCE — critères : ~700 fichiers JSON validés, sans image, `mintage` null si non sourcé, `VERSION` 0.1.0 — étiquettes : v1 data
- [ ] **T-014** (F1.3, §5) Base locale SQLite avec Drizzle et outbox — critères : tables collections, collection_items, outbox ; migrations locales versionnées ; tests d'insertion et de reprise après crash — étiquettes : v1
- [ ] **T-015** (§6) Projet Supabase local : migrations de base, RLS et tests pgTAP — critères : tables users, collections, collection_items, relationships, invites, setasides, feature_flags ; chaque table a ses politiques et son test ; `supabase test db` vert — étiquettes : v1
- [ ] **T-016** (§6, §8) Système de thèmes : jetons des trois directions dans `packages/ui/themes/`, drapeaux, `ThemeProvider`, modes clair et sombre (dériver Musée sombre, Terrain clair, Album sombre), 8 composants partagés avec stories × 3 thèmes × 2 modes — critères : contraste ≥ 4,5:1 vérifié dans les 6 combinaisons ; aucune condition sur le thème dans les écrans ; `CoinTile`, `ScanResultCard`, `ProgressRing`, `HelperHero`, `StatusChip`, `MintMarkPicker`, `QuantityStepper`, `TabBar` — étiquettes : v1
- [ ] **T-017** (F8.3) Feature flags locaux et distants — critères : `FeatureFlags` lit `feature_flags` avec cache local et valeurs par défaut ; flags `liveCamera`, `swaps`, `proximity` à false — étiquettes : v1
- [ ] **T-018** (§7) Pipeline ML minimal — critères : `train`, `build_index`, `export`, `eval` fonctionnent sur 20 pièces synthétiques ; `eval` échoue sous les seuils ; release 0.1.0 exportée en TFLite — étiquettes : v1 ml
- [ ] **T-019** (§8) Réglage Apparence : choix du thème et du mode clair/sombre/système, persisté localement puis dans `users.settings`, appliqué sans redémarrage ; parcours Maestro `theme-switch.yaml` — étiquettes : v1

## V1 — Bêta (mois 1 à 3)
- [ ] **T-039** (F1.1) Importer les faces nationales de circulation des 25 émetteurs, une entrée par dessin sans millésime — critères : fichiers JSON validés par `pnpm catalog:validate` ; sources citées ; donnée inconnue = null ; année = première année de frappe du dessin — étiquettes : v1 data
- [ ] **T-020** (F1.1, F1.4) Écran Catalogue : liste, recherche, filtres pays/année/série — critères : 700 pièces à 60 i/s ; recherche accentuée insensible ; états vide et hors ligne — étiquettes : v1
- [ ] **T-021** (F2.1, F2.2, F2.3) Collection : ajout, quantité, « à garder », doublons = quantité − à garder — critères : cas d'usage testés dans core ; grille avec statuts ; compteur possédées / total par périmètre — étiquettes : v1
- [ ] **T-022** (F2.4) Périmètres de collection — critères : commémoratives seules par défaut ; options faces nationales de circulation et ateliers (millésimes en V2, T-055) ; manques recalculés ; test plugin-demo — étiquettes : v1
- [ ] **T-037** (F2.5) Détails d'un exemplaire : état, notes, date et lieu d'acquisition, photo personnelle — critères : champs facultatifs ; la photo reste sur l'appareil et n'est jamais envoyée sans opt-in explicite ; notes et photo jamais visibles des amis ni des aides ; champs ajoutés au modèle de données (§5) — étiquettes : v1 needs-human
- [ ] **T-023** (F3.1, F3.2, §7) Scan photo : capture → recadrage → inférence → top-1 / top-3 — critères : < 1,5 s P90 sur Pixel 6a ; seuils 0,80 / 0,55 ; messages face commune et hors domaine ; hors ligne — étiquettes : v1 ml
- [ ] **T-024** (F3.3) Sélecteur d'atelier après scan (millésime en V2) — critères : ateliers affichés uniquement pour l'Allemagne et si le périmètre les inclut ; déjà possédés grisés — étiquettes : v1
- [ ] **T-025** (F3.4) Retour utilisateur sur une reconnaissance — critères : « ce n'est pas celle-ci » enregistre la correction sans image ; opt-in photo séparé et désactivé par défaut — étiquettes : v1
- [ ] **T-026** (F6.1, F6.2) Compte anonyme et conversion — critères : `ensureSession()` crée un compte anonyme au premier besoin ; conversion par e-mail garde l'id ; catalogue, scan et collection utilisables sans compte — étiquettes : v1
- [ ] **T-027** (§5, §6) Synchronisation outbox ↔ Supabase — critères : LWW par champ ; reprise après hors ligne prolongé ; suppression logique ; tests de conflit — étiquettes : v1
- [ ] **T-028** (F4.1, F4.2) Invitations par lien et QR, relations collector↔collector et helper→collector — critères : jeton 128 bits, 7 jours ; Edge Functions create-invite / accept-invite avec limite de débit ; test pgTAP de visibilité — étiquettes : v1
- [ ] **T-029** (F4.3, F4.4) Vue `friend_wants` et affichage « Paul la cherche aussi » — critères : vue security invoker ; cache local des manques des amis ; résultat de scan affiche les amis intéressés — étiquettes : v1
- [ ] **T-038** (F4.12) Options de partage entre collectionneurs amis — critères : réglage général et exception par ami ; trois options cumulables : manques, collection complète sans quantités, doublons ; rien de partagé par défaut ; `friend_wants` (T-029) et toute vue lue par les amis filtrées selon ces options, avec tests pgTAP ; aucune quantité ni note exposée (le skill `backend-supabase` fait encore renvoyer `quantity` à `friend_duplicates`) ; stockage des réglages décrit en §5 avec un ADR ; ce que voit un aide ne change pas — étiquettes : v1 needs-human
- [ ] **T-030** (F4.5, F4.6) Mode Aide : un écran, scan, réponse en une phrase, mise de côté — critères : bouton ≥ 64 pt ; « {prénom} ne l'a pas — garde-la ! » ; `set-aside` / `cancel-set-aside` ; fonctionne hors ligne ; parcours Maestro `helper-mode.yaml` — étiquettes : v1
- [ ] **T-031** (F4.7) Notifications de mise de côté — critères : push opt-in ; texte traduit ; aucune donnée personnelle dans la charge utile — étiquettes : v1
- [ ] **T-032** (F6.3, F6.4) Export et suppression de compte — critères : `export-data` JSON ; `delete-account` cascade + purge Storage ; parcours Maestro — étiquettes : v1
- [ ] **T-033** (F7.1) Releases signées de catalogue et de modèle — critères : `ReleaseChecker` vérifie sha256 et signature Ed25519 ; refus si signature invalide ; mise à jour en arrière-plan — étiquettes : v1
- [ ] **T-034** (§4) i18n FR/EN/DE complète et audit accessibilité — critères : zéro chaîne en dur ; contraste vérifié ; `ux-a11y-i18n` sans bloquant — étiquettes : v1
- [ ] **T-035** (§4) Performance : démarrage < 2 s, application < 60 Mo — critères : mesures release avant/après dans la PR — étiquettes : v1
- [ ] **T-036** (§10) Bêta TestFlight / Play interne — critères : comptes développeur Apple et Google créés au nom de la personne ; build preview, notes de version, formulaire de retour — étiquettes : v1 needs-human

## V1 — Stores (mois 4 à 5)
- [ ] **T-040** (§9) Fiches stores FR/EN/DE et labels de confidentialité ; captures dans le thème par défaut `album` ; nom `Collection2pièces` (disponibilité sur les stores et en nom de domaine à vérifier) ; disponible dans toute l'Europe — étiquettes : v1 needs-human
- [ ] **T-041** (§7) Modèle 1.0 : top-1 ≥ 0,90 sur le jeu réel — critères : jeu real-test ≥ 500 photos ; metrics.json vert — étiquettes : v1 ml
- [ ] **T-042** (§12) Images de catalogue sous licence pour ≥ 90 % des pièces ; source retenue : images de la BCE, droits d'utilisation à vérifier — étiquettes : v1 data needs-human

## V2 (mois 6 à 9)
- [ ] **T-050** (F3.5) Caméra live multi-pièces (vision-camera, frame processor) — étiquettes : v2 ml
- [ ] **T-051** (F5.1, F5.2) Échanges suivis : proposition, acceptation, clôture — étiquettes : v2
- [ ] **T-052** (F2.8) Import Numista (OAuth) — étiquettes : v2 needs-human
- [ ] **T-053** (§9) Premium achat unique ; décider si les deux thèmes non par défaut restent gratuits ou passent Premium — étiquettes : v2 needs-human
- [ ] **T-054** (§4) Langues IT, ES, NL, PT — étiquettes : v2
- [ ] **T-055** (F2.2, F3.3) Millésimes de circulation : catalogue par année, option de périmètre et sélecteur après scan — étiquettes : v2 data
