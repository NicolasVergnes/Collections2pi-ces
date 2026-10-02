---
name: design-system
description: Système de design de Deux — trois thèmes commutables (Musée, Terrain, Album) issus des maquettes, mécanisme ThemeProvider et réglage Apparence, jetons de couleur et de typographie par thème, drapeaux de forme, modes clair et sombre, composants partagés de packages/ui et leurs états, règles de contraste et d'accessibilité. À charger pour tout écran, composant ou style.
---
# Système de design

## Trois thèmes, commutables
Les trois directions sont livrées comme thèmes : `packages/ui/themes/musee.ts`, `terrain.ts`, `album.ts`. Le choix se fait dans Réglages › Apparence (`appearance.theme` = `musee` | `terrain` | `album`, `appearance.mode` = `light` | `dark` | `system`), persisté localement puis dans `users.settings`, appliqué sans redémarrage.

Thème par défaut : **`album`** (décision du 2026-09-30, T-000) : `DEFAULT_THEME = 'album'` dans `packages/ui/themes/index.ts`. L'onboarding, les captures stores et les stories par défaut utilisent ce thème ; `musee` et `terrain` se choisissent dans Réglages › Apparence.

Règles :
- Un seul jeu d'écrans et de composants. Un thème = ses jetons + les quatre drapeaux ci-dessous, rien d'autre. Aucune condition sur le thème dans un écran (`if (theme === 'album')` est refusé en revue) ; si un écran a besoin d'autre chose, c'est un nouveau drapeau, justifié par un ADR.
- Drapeaux de thème (`flags`) : `headingFont` (police des titres), `tileStyle` (`ring` Musée | `card` Terrain | `slot` Album), `scanButtonShape` (`circle` | `roundedSquare`), `filterStyle` (`chips` | `segmented`).
- Chaque thème a un mode clair et un mode sombre. Livrés dans les maquettes : Musée clair, Terrain sombre, Album clair. À dériver dans T-016 avec les mêmes exigences de contraste : Musée sombre, Terrain clair, Album sombre.
- Les polices des trois thèmes sont embarquées (sous-ensembles latin : Fraunces + Source Sans 3, Manrope, Nunito ; ≈ 1,2 Mo au total).
- `ThemeProvider` expose `useTheme()` → `{ tokens, flags, mode, theme }`. Les composants de `packages/ui` ne lisent que cela ; `packages/core` ignore l'existence des thèmes.
- Stories et tests : chaque composant partagé est rendu dans les 3 thèmes × 2 modes ; un test RNTL vérifie qu'aucune couleur en dur ne subsiste (`grep` de `#[0-9a-f]{6}` hors de `packages/ui/themes`).

## Jetons — thème `musee` (A · Musée : éditorial, serif, laiton) — mode clair
Polices : titres Fraunces 500/600, texte Source Sans 3 400/600/700.
```
bg #f6f1e7   surface #fffcf5   line #e3dccb   ink #1f1b16   muted #6f675a
accent #9c7a2e (fonds, texte sombre dessus)   accentText #7a5a17 (texte sur fond clair)
success #3f6b4a / successBg #e4ede4   warning #9a5a0b / warningBg #f4e6cf   info #3b5f8a / infoBg #e2e9f2
coinRing #cfc8b9   coinCore #d8b665   coinText #3a2e10   radius 12–16
```
## Jetons — thème `terrain` (B · Terrain : contrasté, rapide) — mode sombre
Police : Manrope 500/700/800. Mode clair à dériver (T-016).
```
bg #0f1417   surface #1a2126   line #2a343b   text #f2f5f7   muted #a7b4bd
accent #5ee0b0 (texte sombre #0f1417 dessus)   warning #f5b84a   info #b59cff   disabled #8a98a3
coinRing #aeb8c0   coinCore #d1a94f   coinText #14110a   radius 10–14
```
## Jetons — thème `album` (C · Album : ludique, alvéoles, famille) — mode clair
Police : Nunito 600/700/800.
```
bg #fff8ea   surface #ffffff   line #eadfc9   ink #2b2420   muted #6b615a
accent #2f8f5b (texte blanc dessus)   accentText #1f7a4a   successBg #dff3e6
warning #f2a93b / warningText #8a5307 / warningBg #fdebc9   info #4a86d9 / infoText #2b5fa8 / infoBg #e0ebfa
slotDashed #cbbfa8   coinRing #d6cfc0   coinCore #e6c15e   coinText #4a3a0c   radius 20–24, boutons 999
```

## Règles communes
- Contraste ≥ 4,5:1 pour le texte courant, ≥ 3:1 au-delà de 24 pt ; les couleurs `*Text` sont celles validées pour du texte sur fond clair — ne pas utiliser `accent` en texte petit sur fond clair.
- Statut d'une pièce = icône + couleur + mot (possédée, manque, doublon ×n) ; jamais la couleur seule.
- Espacements : échelle 4 (4, 8, 12, 16, 20, 24, 32) ; marges d'écran 20 pt ; cibles tactiles ≥ 44 pt ; bouton scanner du mode Aide ≥ 64 pt.
- Une seule police d'accent par thème ; pas de dégradés ; ombres uniquement pour surélever le bouton Scanner de la barre d'onglets.

## Composants partagés (`packages/ui`)
| Composant | Props principales | États |
| --- | --- | --- |
| `CoinTile` | variant, status (`owned` `missing` `duplicate`), quantity, size | pressed, focus |
| `ScanResultCard` | candidate, confidence, status, friendsWanting | loading, lowConfidence (3 candidats) |
| `ProgressRing` / `ProgressBar` | owned, total | — |
| `HelperHero` | collectorNames, onScan | offline |
| `StatusChip` | kind (`success` `warning` `info` `neutral`), label | — |
| `MintMarkPicker` | marks, owned, selected | disabled |
| `QuantityStepper` | value, min, max | disabled |
| `TabBar` | active, onScan | — |
Chaque composant a une story dans `packages/ui/stories` et un test RNTL de ses états.
