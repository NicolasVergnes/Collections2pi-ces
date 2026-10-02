---
name: i18n-copy
description: Internationalisation et rédaction de Deux — organisation des fichiers de langue, nomenclature des clés, pluriels et interpolation i18next, ton (tutoiement, phrases courtes), glossaire FR/EN/DE des termes du projet, formats de nombres et dates, textes des états vides et erreurs. À charger pour toute chaîne visible, tout fichier de src/i18n ou toute fiche store.
---
# i18n et rédaction

## Fichiers
`apps/mobile/src/i18n/{fr,en,de}.json` — FR est la langue source ; EN et DE sont traduits dans la même PR. IT, ES, NL, PT arrivent en V2 (fichiers créés, clés manquantes tolérées par le fallback EN).

## Clés
`<feature>.<écran ou composant>.<élément>` en camelCase : `helper.hero.scanButton`, `scan.result.missingKeep`, `collection.filters.duplicates`. Jamais de clé nommée d'après le texte. Une clé par phrase complète ; aucune concaténation de fragments.

## Pluriels et interpolation (i18next)
```
"collection.wants_one": "{{count}} pièce manquante",
"collection.wants_other": "{{count}} pièces manquantes",
"helper.result.missing": "{{name}} ne l'a pas — garde-la !"
```
Nombres, pourcentages et dates via `Intl.NumberFormat` / `Intl.DateTimeFormat` avec la locale de l'appareil, jamais formatés à la main.

## Ton
Tutoiement, phrases courtes, verbe d'action en tête sur les boutons (« Ajouter à ma collection », « Scanner une pièce »). Pas de jargon numismatique sans mot simple à côté (« atelier (lettre A, D, F, G, J) »). Jamais de promesse de valeur ni de rareté (« vaut », « rare », « investissement »). Erreurs : ce qui s'est passé + quoi faire, en deux phrases.

## Glossaire
| FR | EN | DE |
| --- | --- | --- |
| manque / il te manque | missing / you're missing it | fehlt / fehlt dir |
| possédée | owned | vorhanden |
| doublon | duplicate | Dublette |
| mise de côté | set aside | zurückgelegt |
| aide (personne) | helper | Helfer·in |
| collectionneur·se | collector | Sammler·in |
| atelier (marque) | mint mark | Prägestätte |
| commémorative | commemorative | Gedenkmünze |
| pièce de circulation | circulation coin | Umlaufmünze |
| périmètre | scope | Umfang |
| scanner | scan | scannen |

## États et messages types
- Vide : « Ta collection est vide. Scanne ta première pièce. »
- Hors ligne : « Hors ligne : tout est enregistré sur ton téléphone et sera synchronisé plus tard. »
- Non reconnue : « Je n'ai pas reconnu cette pièce. Approche-toi, évite les reflets, cadre la face avec le dessin. »
- Face commune : « C'est la face commune. Retourne la pièce. »
