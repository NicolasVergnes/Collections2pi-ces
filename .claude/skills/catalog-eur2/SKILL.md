---
name: catalog-eur2
description: Catalogue des pièces de 2 € de Deux — arborescence des données, schéma JSON d'une pièce et de ses variantes, sources autorisées (liste BCE, recoupement Numista), procédure d'ajout d'une émission, validation, images et licences, publication d'une version signée, ce que le plugin expose au moteur. À charger pour packages/plugin-eur2, tools/catalog ou toute question sur une pièce.
---
# Catalogue 2 €

## Où
```
packages/plugin-eur2/data/
  coins/<pays>/<année>-<slug>.json   une pièce (un dessin) par fichier
  series.json                        séries (Länder allemands, Constitution espagnole, …)
  countries.json                     25 émetteurs, noms FR/EN/DE, ateliers
  VERSION                            semver du catalogue
  releases/<semver>/catalog.json     instantané publié, immuable
```

## Schéma d'une pièce (`coin.schema.json` dans ce dossier, exemple `example-coin.json`)
Obligatoires : `id` (`eur2:<pays>:<année>:<slug>`), `country` (ISO 3166-1 alpha-2), `year`, `category` (`commemorative` | `circulation` | `joint`), `title` `{fr,en,de}`, `variants` (≥ 1 : Allemagne → `A`,`D`,`F`,`G`,`J` ; sinon `default`), `sources` (≥ 1 URL).
Facultatifs : `description` `{fr,en,de}`, `series`, `mintage` (entier ou `null`), `designer`, `issueDate`, `images.obverse` `{path, license, credit}`, `numistaId`, `notes`.
Règle : une donnée inconnue vaut `null`, jamais une estimation. `sources` vide est refusé par la validation.

## Ajouter une émission
1. Source : la page annuelle des 2 € commémoratives de la BCE. Recoupe avec Numista ; en cas de désaccord, BCE gagne, écart noté dans `notes`.
2. Crée le fichier JSON ; ajoute la pièce à `series.json` si elle appartient à une série.
3. `pnpm catalog:validate --file <fichier>` : schéma, unicité de l'id, cohérence pays/année/atelier, présence des trois langues.
4. Image : uniquement avec licence notée dans `images.obverse.license` (CC0, CC BY + crédit, autorisation écrite). Sans image autorisée, `images` reste vide et tu ouvres une tâche `needs-human` dans le backlog. Aucune image de la BCE, de Wikipédia ou d'un site commercial sans vérification de licence.
5. Incrémente `VERSION` : mineur pour un ajout, majeur pour un changement de schéma.

## Publication
`pnpm catalog:release` construit `releases/<semver>/catalog.json` et son sha256 ; la personne signe (Ed25519, clé hors dépôt) et publie avec `tools/catalog/publish.ts`. Le dossier d'une release publiée est immuable.

## Ce que le plugin expose
`CatalogPort` : `list()`, `search(q)`, `byId(id)`, `variantsOf(id)`, `scopes()` (`commemoratives`, `withCirculation`, `withMintMarks`, `withYears`). Le moteur ne lit jamais les JSON directement. `plugin-demo` implémente le même port avec 12 objets fictifs pour prouver la généricité.
