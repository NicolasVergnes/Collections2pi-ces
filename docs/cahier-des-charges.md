# Cahier des charges — Deux (application collection 2 €)

Sep 30, 2026 · @Nicolas

## 1. Vision, principes et périmètre

Deux est une application mobile (iOS et Android, web ensuite) qui permet à un collectionneur de pièces de 2 € d'inventorier sa collection, d'identifier une pièce par photo et de mobiliser ses proches pour trouver ce qui lui manque. Le différenciateur est le mode Aide : un proche non collectionneur scanne la pièce qu'il a en main et sait en deux secondes si elle manque à un ami.

Nom affiché en V1 : Collection2pièces. Nom de code du projet : Deux. Le nom définitif sera choisi après la V1 (section 12).

### Principes produit

1. Utile sans compte : catalogue, scan et collection locale fonctionnent sans inscription.
2. Rapide : de la photo à la réponse en moins de deux secondes, hors ligne.
3. L'entourage d'abord : amis et aides en V1 ; collectionneurs à proximité seulement en V3.
4. Modulaire : le moteur (collection, amis, correspondances, échanges) ignore ce qu'est une pièce. Le plugin « 2 € » apporte le catalogue, les règles de variantes et le modèle de reconnaissance.
5. Honnête sur les valeurs : fourchettes sourcées et datées, jamais de promesse de trésor.
6. Vie privée par défaut : les photos sont traitées sur l'appareil, rien n'est envoyé sans consentement explicite.
7. Pas de publicité, pas de mur de scan, pas d'abonnement piégeux.

### Périmètre par version

| Version | Contenu | Explicitement hors périmètre |
| --- | --- | --- |
| V1 (MVP) | Catalogue complet des 2 € (commémoratives et faces nationales de circulation), collection avec quantités et périmètre personnel, reconnaissance par photo, comptes optionnels avec synchronisation, amis avec options de partage, mode Aide, suggestions d'échange en lecture seule, FR/EN/DE, gratuite, lancement dans toute l'Europe | Millésimes de circulation, caméra en direct, flux d'échange suivi, valeurs, Premium, géolocalisation |
| V2 | Caméra en direct multi-pièces, millésimes de circulation, détection automatique de l'atelier et du millésime, flux d'échange suivi avec mise à jour des quantités, import Numista, valeurs indicatives, IT/ES/NL/PT, version web de consultation, Premium en achat unique | Géolocalisation, second type de collection |
| V3 | Collectionneurs à proximité (opt-in, position floutée), clubs et bourses, réputation d'échange, second type de collection branché comme plugin | Place de marché, paiement intégré, cotation en temps réel |

### Objectifs mesurables six mois après la sortie de V1

- 5 000 installations, dont au moins 25 % en mode Aide.
- 30 % des collectionneurs ont au moins un ami ou un aide actif.
- Rétention à 30 jours ≥ 20 %.
- Précision du scan sur photos réelles : top-1 ≥ 90 %, top-3 ≥ 97 %.
- Note moyenne sur les stores ≥ 4,5.

## 2. Personas et parcours

Quatre profils utilisent l'application, et deux d'entre eux (le collectionneur et l'aide) forment la boucle centrale du produit.

| Persona | Qui | Ce qu'il veut | Ce qui l'agace aujourd'hui |
| --- | --- | --- | --- |
| Camille, collectionneuse de circulation | 35 ans, remplit un classeur avec les pièces trouvées dans sa monnaie ; ses proches lui mettent des pièces de côté | Savoir en un coup d'œil ce qui lui manque, que ses proches puissent l'aider sans lui demander | Envoie sa liste de manques par WhatsApp ; ses proches ne savent pas lire une pièce |
| Lucas, aide | 28 ans, frère de Camille, ne collectionne pas | Aider sans effort, sans compte à créer, sans mot de passe | Une appli compliquée ; il ne l'installera pas si elle demande plus de 30 secondes |
| Théo, collectionneur avancé | 52 ans, utilise Numista, collectionne aussi les BE et coincards | Les ateliers allemands, l'export, des données exactes, importer sa collection existante | Les approximations, les valeurs fantaisistes, ressaisir 600 pièces |
| Visiteur curieux | A lu un article « cette pièce vaut 10 000 € » | Savoir ce qu'il a dans la main | Créer un compte pour un seul scan |

### Parcours clés

1. **Onboarding collectionneur sans compte.** Installation → choix de la langue → question « tu collectionnes ou tu aides quelqu'un ? » → périmètre de collection (commémoratives seules ou aussi circulation, ateliers allemands oui/non) → collection locale prête. Le compte n'est proposé qu'au premier besoin réel : inviter quelqu'un ou synchroniser un second appareil.
2. **Scan et ajout.** Photo de la face nationale → trois candidats classés → confirmation d'un geste → atelier pré-rempli ou à choisir (pièces allemandes ; millésime en V2) → quantité mise à jour → retour au scan.
3. **Inviter un aide.** Camille génère un lien ou un QR (7 jours, révocable) → Lucas l'ouvre → l'application s'installe ou s'ouvre → un compte anonyme lié à l'appareil est créé sans formulaire → Lucas voit un seul écran : « Tu aides Camille ». La personne qui aide peut aider plusieurs collectionneurs.
4. **L'aide trouve une pièce.** Lucas scanne → « Camille ne l'a pas, garde-la ! » → il appuie sur « Mise de côté » → Camille reçoit une notification → à la remise en main propre, Camille valide et sa quantité s'incrémente. Fonctionne hors ligne : les manques de Camille sont mis en cache sur le téléphone de Lucas.
5. **Suggestion d'échange entre collectionneurs.** Camille et Théo sont amis et partagent leurs manques et leurs doublons. L'écran Amis montre « Théo a un doublon de Grèce 2023 qui te manque, tu as un doublon de Lettonie 2022 qui lui manque ». En V1 c'est informatif ; en V2 cela ouvre un échange suivi.
6. **Nouvelle émission.** Une pièce est annoncée par la BCE → l'équipe ajoute l'entrée au catalogue et une image de référence → validation automatique → publication d'une version de catalogue → les applications la téléchargent sans mise à jour du store → le modèle de reconnaissance l'intègre à la version suivante de son index.

### Règles de visibilité entre profils

- Un aide voit uniquement la liste des manques des collectionneurs qu'il aide, jamais leur collection complète ni leurs autres amis.
- Un collectionneur voit de son aide uniquement les mises de côté et un compteur « pièces scannées » (pas forcément pour lui, puisqu'il peut aider plusieurs personnes).
- Entre collectionneurs amis, chacun choisit ce qu'il partage (F4.12) : un réglage général pour tous ses amis et, si besoin, un réglage différent pour certains amis. Trois options : ses manques, sa collection complète (sans le nombre d'exemplaires), ses doublons. Par défaut, rien n'est partagé. Les quantités exactes et les notes ne sont jamais partagées. Ces options ne changent rien à ce que voit un aide (première règle).
- Sur le profil d'un ami, chacun voit les pièces qu'il pourrait échanger avec l'autre : celles qu'il a en double et que l'autre n'a pas (F4.7), dans la limite de ce que l'autre partage.
- Un aide qui commence à collectionner bascule en mode collectionneur sans perdre ses liens.

## 3. Exigences fonctionnelles

Chaque exigence porte un identifiant stable (F1.1, F4.3…) repris dans le backlog, les tests et les PR. Priorité MoSCoW : M = indispensable, S = souhaitable, C = si le temps le permet.

### F1 — Catalogue de référence

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F1.1 | Toutes les 2 € commémoratives depuis 2004 et les faces nationales de circulation des 25 émetteurs (21 pays de la zone euro dont la Bulgarie depuis 2026, Monaco, Saint-Marin, Vatican, Andorre), une entrée par dessin sans distinction de millésime, soit environ 700 dessins | V1 | M |
| F1.2 | Par pièce : image de la face nationale, pays, année, titre, thème, tirage, graveur, série, émission commune, ateliers (Allemagne : A, D, F, G, J), description courte | V1 | M |
| F1.3 | Navigation par pays, par année, par série ; recherche texte ; filtres possédée / manquante / doublon | V1 | M |
| F1.4 | Fiche pièce : image zoomable, infos, « qui parmi mes amis la possède / la cherche » selon ce qu'ils partagent (F4.12) | V1 | M |
| F1.5 | Catalogue embarqué (instantané versionné) pour usage hors ligne et sans compte | V1 | M |
| F1.6 | Mise à jour du catalogue sans passer par les stores (fichier versionné, signé, téléchargé au lancement) | V1 | M |
| F1.7 | Catalogue traduit (titres, descriptions) en FR, EN, DE | V1 | S |
| F1.8 | Variantes de finition (BE, BU, coincard, colorisée) | V2 | C |
| F1.9 | Fourchette de valeur indicative avec source et date | V2 | S |

### F2 — Ma collection

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F2.1 | Ajouter ou retirer une pièce ; quantité de 0 à n ; incrément d'un geste | V1 | M |
| F2.2 | Périmètre de collection : commémoratives seules ou aussi faces nationales de circulation ; distinction des ateliers allemands oui/non (V1) ; distinction des millésimes de circulation oui/non (V2). Le périmètre définit ce qu'est un « manque » | V1 / V2 | M |
| F2.3 | Doublons calculés : quantité − exemplaires à garder (1 par défaut, modifiable par pièce) | V1 | M |
| F2.4 | Vue album : progression globale, par pays et par année ; listes Manques et Doublons | V1 | M |
| F2.5 | Par pièce, facultatif : état, notes, date et lieu d'acquisition, photo personnelle | V1 | S |
| F2.6 | Stockage local d'abord ; synchronisation multi-appareils si compte | V1 | M |
| F2.7 | Export CSV | V1 | S |
| F2.8 | Import CSV et import Numista via son API (OAuth) | V2 | S |
| F2.9 | Historique des mouvements (ajouts, échanges, mises de côté reçues) | V2 | C |

### F3 — Reconnaissance par photo

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F3.1 | Photo (appareil ou galerie) de la face nationale → trois candidats classés avec score ; l'utilisateur confirme d'un geste | V1 | M |
| F3.2 | Traitement intégralement sur l'appareil, hors ligne, sans compte | V1 | M |
| F3.3 | Atelier : pré-rempli quand lisible, sinon sélecteur rapide (V1). Millésime de circulation et lecture automatique (V2) | V1 / V2 | M |
| F3.4 | Retours explicites : « ce n'est pas une 2 € », « photo floue », « face commune détectée, retourne la pièce », avec guidage visuel | V1 | M |
| F3.5 | Correction manuelle toujours possible ; chaque correction alimente les métriques (sans image) | V1 | M |
| F3.6 | Option d'envoyer la photo pour améliorer le modèle, opt-in explicite, révocable | V1 | S |
| F3.7 | Mode caméra en direct : détection continue, encadré par pièce avec pays, année, statut (manque / doublon / possédée / recherchée par un ami) | V2 | M |
| F3.8 | Plusieurs pièces sur une même photo ou dans le champ de la caméra | V2 | S |
| F3.9 | Modèle et index mis à jour sans passer par les stores | V1 | M |

### F4 — Amis et mode Aide

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F4.1 | Invitation par lien ou QR, valable 7 jours, usage limité, révocable | V1 | M |
| F4.2 | Deux types de relation : collectionneur ↔ collectionneur (symétrique) et aide → collectionneur (asymétrique) | V1 | M |
| F4.3 | Mode Aide : un écran, un gros bouton Scanner, une réponse en une phrase (« Camille ne l'a pas, garde-la ! »), la liste visuelle des manques par ami, un bouton « Mise de côté » | V1 | M |
| F4.4 | Un aide peut aider plusieurs collectionneurs ; la réponse du scan agrège (« Camille et Paul la cherchent ») | V1 | M |
| F4.5 | Mise de côté → notification au collectionneur → validation à la remise → incrément de quantité ; annulation possible des deux côtés | V1 | M |
| F4.6 | Les manques des amis sont mis en cache localement pour que le mode Aide fonctionne hors ligne | V1 | M |
| F4.7 | Suggestions d'échange entre collectionneurs amis (doublon de l'un ↔ manque de l'autre), en lecture seule, dans la limite de ce que chacun partage (F4.12) | V1 | S |
| F4.8 | Flux d'échange suivi : proposition, acceptation, remise ou envoi, clôture, mise à jour automatique des quantités, notation | V2 | M |
| F4.9 | Notifications push opt-in : mise de côté, nouvelle relation, échange | V1 | S |
| F4.10 | Retirer un ami, bloquer, signaler | V1 | M |
| F4.11 | Compteur et petites récompenses pour l'aide (« 12 pièces trouvées pour Camille ») | V1 | C |
| F4.12 | Options de partage entre collectionneurs amis : un réglage général pour tous les amis, une exception possible par ami ; trois options cumulables : manques, collection complète (sans quantités), doublons ; rien n'est partagé par défaut | V1 | M |

### F5 — Comptes et accès sans compte

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F5.1 | Sans compte : catalogue, scan, collection locale, statistiques, export | V1 | M |
| F5.2 | Compte anonyme lié à l'appareil, créé silencieusement à la première action sociale (accepter une invitation) | V1 | M |
| F5.3 | Compte complet : e-mail par lien magique, Apple, Google ; conversion anonyme → complet sans perte de données | V1 | M |
| F5.4 | Multi-appareils ; conflits résolus par dernière écriture par élément (horodatage) | V1 | M |
| F5.5 | Suppression du compte et export de toutes les données depuis l'application | V1 | M |
| F5.6 | Profil minimal : pseudo et avatar facultatif ; aucun nom réel ni téléphone requis | V1 | M |

### F6 — Proximité et communauté

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F6.1 | Collectionneurs à proximité, opt-in, position floutée à 2 km, âge déclaré ≥ 16 ans | V3 | S |
| F6.2 | Annuaire de clubs, bourses et événements | V3 | C |
| F6.3 | Réputation d'échange (notes, nombre d'échanges) | V3 | S |

### F7 — Administration et données

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F7.1 | Pipeline d'import de la liste officielle BCE + validation par schéma + publication d'une version | V1 | M |
| F7.2 | Curation en V1 par fichiers JSON validés en CI et revus en PR ; interface web en V2 | V1 / V2 | S |
| F7.3 | Registre des versions de modèle avec métriques et version minimale d'application | V1 | M |
| F7.4 | Tableau de bord anonymisé : précision du scan, corrections, volume de mises de côté | V2 | S |

### F8 — Extensibilité

| ID | Exigence | Version | Priorité |
| --- | --- | --- | --- |
| F8.1 | Un second type de collection s'ajoute sans modifier le moteur ; preuve : un plugin « démo » couvert par les tests d'intégration dès V1 | V1 | M |
| F8.2 | Drapeaux de fonctionnalités pilotés à distance, par utilisateur et par version | V1 | S |
| F8.3 | API interne stable entre moteur et plugins, documentée et versionnée | V1 | M |

## 4. Exigences non fonctionnelles

Ces exigences sont des critères d'acceptation : une PR qui en dégrade une est refusée par la revue automatique (section 11).

| Domaine | Exigence | Cible mesurable |
| --- | --- | --- |
| Plateformes | iOS et Android depuis une seule base de code ; web en consultation en V2 | iOS 16+, Android 10+ (API 29) |
| Performance | Démarrage à froid, scan, catalogue fluide | Démarrage < 2 s ; photo → résultat < 1,5 s sur un Android milieu de gamme de 2021 ; 60 images/s sur la liste de 1 000 pièces |
| Taille | Application légère malgré 700 images | < 60 Mo installés ; vignettes embarquées (WebP, 10 Ko), images HD chargées à la demande et mises en cache |
| Hors ligne | Tout sauf le social fonctionne sans réseau ; le mode Aide fonctionne hors ligne grâce au cache des manques | File de synchronisation rejouée au retour du réseau, sans perte |
| Accessibilité | WCAG 2.1 AA ; VoiceOver et TalkBack ; taille de police dynamique ; mode Aide utilisable d'une main | Contraste ≥ 4,5:1 ; cibles ≥ 44 pt ; chaque écran testé au lecteur d'écran |
| Langues | Interface et catalogue traduits ; formats de date et de nombre localisés | FR, EN, DE en V1 ; IT, ES, NL, PT en V2 |
| Sécurité | Isolation des données par utilisateur au niveau base (RLS sur chaque table) ; jetons d'invitation à usage et durée limités ; aucun secret dans le dépôt ; dépendances auditées en CI | 0 table sans politique RLS ; audit `pnpm audit` sans vulnérabilité haute |
| Vie privée et RGPD | Hébergement UE ; minimisation ; photos jamais envoyées sans opt-in ; suppression et export depuis l'application ; analytics anonymisés et désactivables ; aucun traceur publicitaire | Suppression effective < 30 jours ; politique de confidentialité lisible en 3 minutes |
| Mineurs | Pas de géolocalisation, pas de profil public, invitations privées uniquement en V1 | Contrôle d'âge avant toute fonction de proximité (V3) |
| Fiabilité | Sessions sans plantage ; sauvegardes ; migrations réversibles | Crash-free ≥ 99,5 % ; sauvegarde quotidienne, rétention 30 jours |
| Observabilité | Rapports de plantage, journaux structurés, métriques de scan anonymisées | Sentry ; précision et taux de correction du scan par version de modèle |
| Stores | Conformité Apple et Google | Sign in with Apple si connexion tierce ; suppression de compte dans l'application ; justification des permissions caméra et notifications |
| Maintenabilité | Monorepo TypeScript, tests, décisions tracées | Couverture ≥ 80 % sur le moteur, ≥ 60 % sur l'application ; un ADR par décision structurante |
| Coût | Infrastructure proportionnée à une niche | < 100 €/mois jusqu'à 10 000 utilisateurs actifs mensuels |

## 5. Modèle de données et catalogue

Le modèle sépare un noyau générique (collections, relations, échanges) d'un plugin par type de collection. Le plugin 2 € est le premier ; un plugin « démo » existe dès V1 pour prouver la séparation.

### Noyau générique

| Entité | Rôle | Champs clés | Qui peut lire |
| --- | --- | --- | --- |
| catalogs | Un type de collection et sa version publiée | id, kind (`eur2`), version, published\_at, checksum | Tous |
| item\_types | Un dessin du catalogue | id, catalog\_id, key, country, year, category, title (i18n), description (i18n), series, mintage, designer, images, attrs (JSON), search\_text | Tous |
| item\_variants | Une déclinaison collectionnable d'un dessin | id, item\_type\_id, key (`default`, `A`, `D`…), label, attrs | Tous |
| users | Profil minimal | id, handle, avatar\_url, locale, settings, is\_anonymous | Soi ; handle et avatar visibles des amis |
| collections | Une collection d'un utilisateur pour un catalogue | id, user\_id, catalog\_id, scope (JSON : catégories, ateliers, millésimes) | Soi |
| collection\_items | Une ligne de collection | id, collection\_id, variant\_id, quantity, keep\_quantity, condition, notes, acquired\_at, updated\_at, deleted\_at | Soi ; agrégé pour les amis selon leurs options de partage (F4.12) |
| relationships | Un lien entre deux utilisateurs | id, user\_a, user\_b, kind (`collector`, `helper`), status (`pending`, `accepted`, `blocked`), created\_at | Les deux parties |
| invites | Un jeton d'invitation | token, inviter\_id, kind, expires\_at, max\_uses, uses | L'émetteur |
| setasides | Une pièce mise de côté par un aide | id, helper\_id, collector\_id, variant\_id, status (`set_aside`, `delivered`, `cancelled`), created\_at | Les deux parties |
| swaps, swap\_items, swap\_ratings (V2) | Un échange suivi | proposer\_id, receiver\_id, status, items par direction, notes, ratings | Les deux parties |
| recognition\_feedback | Une prédiction et sa correction | model\_version, predicted\_variant\_id, confirmed\_variant\_id, confidence, image\_ref (null sauf opt-in) | Équipe, anonymisé |
| catalog\_releases, model\_releases | Registres de versions | version, url, checksum, min\_app\_version, metrics | Tous |
| feature\_flags | Drapeaux | key, enabled, rollout (%), min\_app\_version | Tous |

### Règles dérivées (calculées, jamais stockées)

- Manques d'un utilisateur = variantes du catalogue filtrées par son périmètre − variantes possédées (quantité > 0).
- Doublons = max(0, quantity − keep\_quantity), keep\_quantity = 1 par défaut.
- Ce qu'un aide voit = union des manques des collectionneurs qu'il aide, exposée par une vue SQL `friend_wants` qui ne renvoie que des identifiants de variantes.
- Suggestion d'échange entre A et B = doublons(A) ∩ manques(B) et doublons(B) ∩ manques(A), limitée à ce que A et B partagent (F4.12).

### Base locale (SQLite sur l'appareil)

Miroir de `collection_items` et de `collections`, instantané du catalogue, cache des manques des amis (identifiants + horodatage), file d'attente des écritures à synchroniser (outbox). Fonctionne sans compte ; à la création du compte, le contenu local est poussé tel quel.

### Plugin 2 € : ce qu'il ajoute

- Schéma d'attributs : atelier allemand, émission commune, série (Länder, châteaux de Malte, cantons…), type (commémorative, circulation, émission commune UE).
- Règles de variantes : une pièce allemande = 5 variantes d'atelier ; les autres pays = 1 variante ; un périmètre « sans ateliers » replie les 5 sur une seule.
- Règles de recherche et de tri (par pays selon la langue, par année).
- Modèle de reconnaissance et index d'embeddings (section 7).

### Sources du catalogue et droits

| Source | Usage | Point d'attention |
| --- | --- | --- |
| Liste officielle des 2 € commémoratives de la BCE | Référence pour l'existence, la date, le tirage et la description de chaque émission | Les images sont fournies par les instituts d'émission nationaux ; les droits de réutilisation dans une application doivent être vérifiés ou demandés |
| Numista (API OAuth) | Import de collection en V2 ; recoupement des données | Conditions d'utilisation de l'API à respecter ; les images sont celles des contributeurs |
| Wikimedia Commons | Images de secours | Licence variable par fichier, à vérifier une à une |
| Photos de la communauté | Images de référence et données d'entraînement | Consentement explicite, licence CC0 à l'envoi |

Décision V1 : le catalogue est constitué à la main à partir de la liste BCE, dans des fichiers JSON validés par schéma. Les images de référence proviennent de sources dont les droits sont vérifiés, à défaut de photos prises par l'équipe ; c'est le premier risque listé en section 12.

## 6. Architecture technique

L'architecture est locale d'abord : l'application est complète sans réseau, Supabase n'intervient que pour le social et la synchronisation, et tout ce qui change souvent (catalogue, modèle) est livré comme une version signée téléchargée au lancement.

&#91;embedded content: architecture · 3 couches, 12 composants\]

L'application lit et écrit d'abord sur l'appareil ; la synchronisation, les invitations et les mises de côté passent par Supabase ; les pipelines publient des versions signées de catalogue et de modèle que l'application télécharge sans passer par les stores.

### Choix de stack

| Couche | Choix | Pourquoi | Alternative écartée |
| --- | --- | --- | --- |
| Application mobile | Expo (React Native) + TypeScript ; Expo Router ; Zustand + TanStack Query ; expo-sqlite avec Drizzle ; react-native-vision-camera 5 et react-native-fast-tflite 5 (Nitro Modules) dès V1 ; Expo SDK 57, React Native 0.86, TypeScript 7, Node 24 LTS (versions vérifiées le 30 septembre 2026, tenues à jour dans docs/versions.md du dépôt) | Un seul langage de bout en bout avec types partagés ; mises à jour JS sans passer par les stores (EAS Update) ; export web possible ; l'écosystème où Claude Code est le plus productif | Flutter : très bon aussi, mais Dart isolé du backend et moins de partage de code |
| Backend | Supabase : Postgres 15, Auth (connexion anonyme, lien magique, Apple, Google), Storage, Edge Functions (Deno), Realtime ; région eu-central-1 | RLS natif, comptes anonymes convertibles, hébergement UE, quasi aucune exploitation | Firebase : moins adapté au relationnel et à l'hébergement UE ; Node + Postgres maison : plus d'exploitation |
| ML | Python 3.13, PyTorch + timm ; export LiteRT (.tflite, via litert-torch, ex ai-edge-torch) et CoreML | Outillage standard, export mobile éprouvé | Inférence côté serveur : coût, latence, dépendance au réseau |
| Catalogue | Fichiers JSON validés par un schéma Zod, scripts TypeScript, publication dans Storage | Revue en PR, diff lisible, validation en CI | Base seule : pas d'historique lisible |
| CI/CD | GitHub Actions ; EAS Build, Submit et Update ; Supabase CLI avec branches de prévisualisation | Standard et gratuit à cette échelle | — |
| Observabilité | Sentry (UE) ; PostHog UE ou auto-hébergé, désactivable | Conformité RGPD | Firebase ou Google Analytics : transferts hors UE |

### Monorepo

```text
deux/
  apps/mobile             application Expo (écrans, navigation, modules par fonctionnalité)
  packages/core           moteur : entités, cas d'usage, ports ; aucune dépendance React Native
  packages/plugin-eur2    plugin 2 € : schéma, chargeur, règles de variantes, index de recherche
  packages/plugin-demo    plugin minimal qui prouve la séparation ; utilisé par les tests
  packages/recognition    chargement du modèle, prétraitement, kNN, seuils
  packages/data-local     schéma SQLite, dépôts, moteur de synchronisation (outbox)
  packages/api-client     adaptateurs Supabase des ports : social, synchro, releases, drapeaux
  packages/ui             jetons de design et composants
  supabase/               migrations, politiques RLS, fonctions, seed, tests SQL
  ml/                     données, entraînement, export, évaluation
  tools/catalog           import BCE → JSON → validation → release
  docs/                   cahier des charges exporté, ADR, backlog
  .claude/                skills, agents, hooks (section 11)
```

Outils : pnpm + Turborepo, ESLint + Prettier, Vitest, React Native Testing Library, Maestro pour les parcours de bout en bout, ruff + pytest côté ML.

### Ports du moteur

Le moteur ne dépend que de ces interfaces ; un plugin ou un adaptateur les implémente.

| Port | Rôle | Implémenté par |
| --- | --- | --- |
| CatalogPort | Lister, chercher, résoudre une variante, décrire les périmètres possibles | plugin-eur2, plugin-demo |
| RecognizerPort | Image → candidats classés avec score | recognition, avec le modèle fourni par le plugin |
| CollectionRepository | Lire et écrire les lignes de collection | data-local, avec synchronisation |
| SocialRepository | Relations, invitations, mises de côté, échanges | api-client (Supabase) |
| ReleaseChecker | Versions de catalogue et de modèle disponibles, vérification de signature | api-client |
| FeatureFlags | Drapeaux à distance avec cache local | api-client |

Cas d'usage du moteur, purs et testés : AddToCollection, SetScope, ComputeWants, ComputeDuplicates, MatchFriends, SuggestSwaps, ResolveScan, AcceptInvite, SetAside.

### Synchronisation

- Écriture locale immédiate ; une ligne est ajoutée à l'outbox avec horodatage et identifiant d'appareil.
- Poussée par lots dès que le réseau revient ; tirage de tout ce qui a changé depuis le dernier `updated_at` connu.
- Conflit sur une même ligne : la dernière écriture gagne, champ par champ ; suppressions logiques (`deleted_at`).
- Le cache des manques des amis est rafraîchi à l'ouverture du mode Aide et à chaque notification reçue.

### Sécurité

- Une politique RLS par table ; les manques d'un ami ne sont lisibles que par la vue `friend_wants`, qui vérifie l'existence d'une relation acceptée et, entre collectionneurs, les options de partage (F4.12).
- Les invitations sont des jetons aléatoires de 128 bits, expirés à 7 jours, à usage limité et révocables ; l'acceptation passe par une Edge Function qui crée la relation côté serveur.
- Les Edge Functions sont limitées en débit par utilisateur et par adresse IP.
- Les releases de catalogue et de modèle sont signées ; l'application vérifie la signature et la version minimale avant d'installer.
- Aucun secret dans le dépôt ; les clés vivent dans EAS Secrets et GitHub Environments.

## 7. Reconnaissance des pièces

Le problème est borné : environ 700 faces nationales, toutes rondes, toutes de même diamètre, photographiées de près. La reconnaissance tourne sur l'appareil avec un modèle d'embeddings et une recherche de plus proches voisins ; ajouter une nouvelle pièce ne demande qu'une image de référence, pas un réentraînement.

&#91;embedded content: reconnaissance · pipeline sur l’appareil et boucle d’entraînement\]

La chaîne du haut s'exécute entièrement sur le téléphone ; la chaîne du bas tourne sur GitHub Actions et publie une release signée que l'application télécharge ; les validations des utilisateurs (sans image, sauf opt-in) reviennent alimenter les références.

### Étapes sur l'appareil

1. **Capture.** Photo de la face nationale, guide visuel circulaire ; refus immédiat si l'image est floue (variance du laplacien sous seuil).
2. **Détection et normalisation.** Détection du cercle (transformée de Hough ou petit détecteur), recadrage carré, redimensionnement 224×224, normalisation de la luminosité. Aucune correction de rotation : le modèle est entraîné invariant.
3. **Embedding.** Réseau léger (EfficientNet-Lite0 ou MobileNetV3, environ 5 Mo en INT8) entraîné en apprentissage métrique (perte ArcFace) ; sortie : un vecteur de 128 dimensions.
4. **Recherche.** Distance cosinus vers un index de références (700 dessins × quelques vues), calculée en TypeScript pur, moins de 5 ms.
5. **Décision.** Score ≥ 0,80 : un candidat mis en avant ; entre 0,55 et 0,80 : trois candidats ; sous 0,55 : « pas reconnue ». Face commune détectée : « retourne la pièce ». Classe hors domaine (1 €, jeton, objet rond) : message dédié.
6. **Validation.** L'utilisateur confirme ou corrige ; prédiction, score et correction sont journalisés sans image (F3.5) ; la photo ne part qu'en opt-in (F3.6).

### Atelier et millésime

V1 : sélecteur d'atelier pré-rempli. Le pré-remplissage vient d'un second passage sur la zone de la lettre d'atelier (position connue pour chaque dessin allemand) avec un petit classifieur A, D, F, G, J. V2 : lecture automatique du millésime par OCR léger sur la zone de date, avec validation manuelle si la confiance est basse.

### Données d'entraînement

| Source | Volume cible V1 | Rôle |
| --- | --- | --- |
| Images de référence du catalogue | 1 à 3 par dessin, environ 1 500 | Base de l'index et de l'entraînement |
| Augmentations synthétiques | ×200 par référence | Reflets métalliques, usure, rotation 0–360°, flou, perspective, éclairage, fonds variés |
| Photos réelles prises par l'équipe | 20 par dessin sur les 100 dessins les plus fréquents, soit 2 000 | Jeu de test « réel », jamais utilisé en entraînement |
| Photos des utilisateurs (opt-in) | Croissance continue | Réentraînement trimestriel |

### Métriques et seuils de publication

| Métrique | Seuil pour publier | Mesuré sur |
| --- | --- | --- |
| Top-1 | ≥ 90 % | Jeu de test réel |
| Top-3 | ≥ 97 % | Jeu de test réel |
| Faux positifs sur hors domaine | ≤ 2 % | 500 images de 1 €, jetons, objets ronds |
| Latence photo → résultat (P90) | ≤ 1,5 s | Pixel 6a et iPhone 12 |
| Taille modèle + index | ≤ 12 Mo | — |

Une release de modèle sous l'un de ces seuils est refusée par le pipeline ; l'agent ml-engineer (section 11) applique cette règle.

### Versionnage et diffusion

- Modèle et index sont publiés ensemble sous `model-eur2-<semver>` avec métriques, somme de contrôle, signature et version minimale d'application.
- Ajout d'une pièce sans réentraînement : nouvelle image de référence, nouvel index, release mineure. Réentraînement : release majeure.
- L'application embarque la dernière release à la compilation et télécharge les suivantes au lancement (F3.9).
- Retour arrière : l'application conserve la release précédente et y revient si la nouvelle échoue à charger.

### Mode caméra en direct (V2)

react-native-vision-camera avec un frame processor ; détection sur une image sur trois à 640 px ; suivi des cercles entre images ; l'embedding n'est calculé qu'une fois par cercle stable sur trois images ; un encadré par pièce avec pays, année et statut. Cible : 15 images par seconde sur un téléphone de 2021.

## 8. Design et maquettes

Trois directions sont maquettées sur le même jeu de trois écrans (Ma collection, Résultat de scan, Mode Aide), pour choisir sur des cas réels plutôt que sur une palette : [Deux — maquettes, trois directions de style](https://claude.ai/artifact/EuwQfYbZ51c8NheWjAHEvy).

| Direction | Ambiance | Typographie | Couleurs | Pour qui ça marche | Risque |
| --- | --- | --- | --- | --- | --- |
| A. Musée | Éditorial, calme, premium ; les pièces sont présentées comme dans un catalogue de numismate | Titres en serif (Fraunces), texte en sans humaniste (Source Sans 3) | Ivoire, encre, laiton en accent ; statuts portés par une icône plus une couleur | Théo et les collectionneurs adultes ; crédibilité | Peut paraître austère aux aides et aux familles |
| B. Terrain | Utilitaire, contrasté, rapide ; conçu pour l'aide qui scanne dans une file de caisse | Sans géométrique (Manrope), gros chiffres | Fond sombre par défaut, accent menthe, trois couleurs de statut distinguables par luminosité | Lucas ; usage d'une main, en mouvement | Moins « collection », plus « outil » ; le mode clair doit exister |
| C. Album | Ludique et familial ; l'écran reproduit une page de classeur avec ses alvéoles vides à remplir | Sans arrondi (Nunito) | Papier chaud, alvéoles vertes, ambre et grises, illustrations plates | Camille et les familles ; motivation par la progression visible | Peut sembler enfantin aux numismates avancés |

### Ce que les trois directions partagent

- Le résultat de scan tient en une phrase et un statut lisible sans lire : manque (à garder), doublon, déjà possédée, recherchée par un ami.
- Le mode Aide est un écran unique : un bouton Scanner d'au moins 64 pt de haut et la liste visuelle des manques.
- Jetons de design partagés (espacements par pas de 4, rayons, échelle de police) : changer de direction change les jetons, pas les écrans.
- Mode clair et mode sombre pour chaque direction ; contraste 4,5:1 ; taille de police dynamique.
- Icônes en traits (Lucide). Aucune photo de pièce réelle dans les maquettes (droits, section 5) : des pastilles typées les remplacent.

### Trois thèmes commutables

Les trois directions sont conservées et livrées comme thèmes, choisis dans Réglages › Apparence (thème et mode clair, sombre ou système), persistés localement puis dans `users.settings`. Un seul jeu d'écrans et de composants : un thème est un jeu de jetons plus quatre drapeaux de forme (police des titres, style des pastilles, forme du bouton Scanner, style des filtres), et aucun écran ne teste le thème actif. Chaque thème existe en clair et en sombre ; les maquettes livrent Musée clair, Terrain sombre et Album clair, les trois autres variantes sont dérivées en phase 0 avec les mêmes exigences de contraste. Les polices des trois thèmes sont embarquées (environ 1,2 Mo). Le skill `design-system` du kit Claude Code (section 11) décrit le mécanisme et les jetons ; `packages/ui` les implémente avec les composants CoinTile, ScanResultCard, ProgressRing, HelperHero. Le thème par défaut, celui de l'onboarding et des captures pour les stores, est Album, le plus proche du classeur de Camille et des familles ; Musée et Terrain se choisissent dans les réglages. Reste à décider en V2 si les deux autres restent gratuits ou deviennent un argument Premium.

## 9. Modèle économique et coûts

L'application est gratuite pour tout ce qui fait la boucle centrale (catalogue, scan, collection, amis, mode Aide) et se finance par un Premium en achat unique à partir de V2, jamais par la publicité ni par un mur de scan. Le mode Aide reste gratuit sans limite : c'est lui qui fait entrer les collectionneurs.

| Offre | Contenu | Prix indicatif |
| --- | --- | --- |
| Gratuit | Catalogue, scan illimité, collection, amis et aides, synchronisation sur 2 appareils, export CSV | 0 € |
| Premium (V2) | Synchronisation illimitée, valeurs indicatives et valeur de collection, historique, thèmes des deux autres directions, import Numista, caméra en direct en avant-première | 6,99 € une fois, ou 14,99 € en achat « soutien » |

Ce choix répond aux reproches faits aux applications existantes : abonnements piégeux, essais qui facturent, publicité avant chaque scan. Il assume un revenu modeste, cohérent avec une niche.

### Coûts d'exploitation estimés

| Poste | Jusqu'à 1 000 utilisateurs actifs | Jusqu'à 10 000 | Note |
| --- | --- | --- | --- |
| Supabase | 0 € (offre gratuite) | 25 €/mois (Pro) | Passer en Pro dès la bêta pour les sauvegardes |
| EAS (builds et mises à jour) | 0 € | 0 à 19 €/mois | Selon le nombre de builds |
| Sentry, PostHog | 0 € | 0 à 30 €/mois | Offres gratuites suffisantes longtemps |
| Comptes développeur | 99 $/an Apple, 25 $ une fois Google | idem | — |
| Entraînement ML | 0 à 20 €/mois | 0 à 20 €/mois | GPU à la demande, quelques heures par trimestre |
| Total | environ 10 €/mois | environ 80 €/mois | Sous la cible de 100 €/mois (section 4) |

## 10. Roadmap et jalons

Cinq phases séparées par des portes : la suivante ne démarre pas tant que les critères de la porte ne sont pas atteints. Les durées sont des estimations pour un développement mené par Claude Code avec une personne en revue ; démarrage le 2 octobre 2026 (section 12).

&#91;embedded content: roadmap · 5 phases, 4 portes\]

Critères des portes, repris du schéma de la roadmap (l'export Markdown ne contient pas le schéma) :

- Porte 0, entre les fondations et la bêta V1 : plugin démo testé ; catalogue validé.
- Porte 1, entre la bêta V1 et la V1 en stores : 50 testeurs ; top-1 ≥ 90 % sur le jeu de test réel.
- Porte 2, entre la V1 en stores et la V2 : crash-free ≥ 99,5 % ; note moyenne ≥ 4,5.
- Porte 3, entre la V2 et la V3 : 1 000 utilisateurs actifs ; rétention à 30 jours ≥ 20 %.

La phase 0 livre l'outillage qui rend les suivantes autonomes ; V1 sort en bêta fermée avant les stores ; V2 et V3 n'ouvrent qu'après les critères d'usage réel.

### Livrables par phase

| Phase | Livrables |
| --- | --- |
| 0 · Fondations | Monorepo, CI, design system de la direction choisie, catalogue v0 (commémoratives) validé par schéma, plugin démo, premier modèle entraîné sur les références, kit Claude Code installé et hooks actifs, ADR 0001 à 0005 |
| 1 · V1 bêta | Collection avec quantités et périmètre, scan photo, comptes et synchronisation, invitations, amis, mode Aide, suggestions d'échange, FR/EN/DE, bêta TestFlight et Play interne avec 50 testeurs, jeu de test réel de 2 000 photos |
| 2 · V1 stores | Corrections de la bêta, politique de confidentialité, fiches stores, suppression de compte, revue d'accessibilité, publication |
| 3 · V2 | Caméra en direct, millésimes de circulation, atelier et millésime automatiques, flux d'échange suivi, valeurs indicatives, import Numista, Premium, IT/ES/NL/PT, web de consultation, interface de curation |
| 4 · V3 | Proximité avec contrôle d'âge, clubs et bourses, réputation, second type de collection choisi après étude |

## 11. Développement autonome par Claude Code

Claude Code développe l'application tâche par tâche depuis un backlog, dans des branches, avec des sous-agents spécialisés pour tester et relire, et des hooks qui bloquent ce qui ne doit pas passer. Une personne garde trois responsabilités : fusionner les PR, détenir les secrets, publier sur les stores. Le kit (`CLAUDE.md`, `.claude/`, backlog, gabarit de PR, CI) est livré en fichiers à côté de ce document.

### Qui fait quoi

| La personne | Claude Code |
| --- | --- |
| Choisit la direction de design et tranche les questions ouvertes | Planifie, implémente, teste, documente |
| Relit et fusionne les PR (possible depuis le téléphone) | Ouvre une PR par tâche avec résumé, captures et Definition of Done cochée |
| Détient les secrets Supabase, EAS et stores | Ne voit que des variables d'environnement de développement local |
| Publie sur les stores, signe les releases de catalogue et de modèle | Prépare builds, notes de version et métadonnées |
| Répond aux questions juridiques (droits d'images, RGPD) | Signale les points juridiques dans la PR et s'arrête |

### Boucle de travail

1. `/next-task` : Claude lit `docs/backlog.md`, prend la première tâche non bloquée, relit les exigences F-xx citées et charge le skill concerné.
2. Plan court, puis branche `feat/F4.3-mode-aide`.
3. Implémentation avec les skills ; sous-agents appelés pour les tests, la revue, la sécurité et l'accessibilité.
4. Le hook Stop lance typecheck, lint et tests ; s'ils échouent, Claude continue au lieu de s'arrêter.
5. PR avec le gabarit : exigences couvertes, tests, captures, risques, points à trancher par la personne.
6. CI GitHub : lint, typecheck, tests, validation du catalogue, évaluation ML si `ml/` a changé, build EAS de prévisualisation.
7. Fusion par la personne ; Claude met à jour le backlog et le changelog.

### Definition of Done d'une PR

- [ ] Exigences F-xx citées et couvertes ; l'agent spec-guardian a validé la conformité
- [ ] Tests unitaires sur les cas d'usage touchés de `packages/core` ; tests d'intégration ; parcours Maestro pour tout nouvel écran
- [ ] Typecheck, lint et format propres ; toute dépendance ajoutée est justifiée dans la PR
- [ ] Chaînes traduites FR, EN, DE ; aucune chaîne en dur
- [ ] Accessibilité vérifiée : labels, contraste, cibles, lecteur d'écran
- [ ] Politique RLS et test SQL pour toute table nouvelle ou modifiée
- [ ] Aucune donnée personnelle dans les logs ; aucune photo envoyée sans opt-in
- [ ] ADR si décision structurante ; changelog mis à jour

### Contenu du kit

| Élément | Emplacement | Rôle |
| --- | --- | --- |
| Constitution | `CLAUDE.md` | Stack, commandes, conventions, DoD, interdits ; chargée à chaque session |
| Skills (11) | `.claude/skills/<nom>/SKILL.md` | Conventions et procédures, chargées quand la tâche s'y rapporte ou par `/nom` |
| Agents (7) | `.claude/agents/<nom>.md` | Sous-agents à contexte isolé pour tester, relire, auditer, curer |
| Hooks | `.claude/settings.json` et `.claude/hooks/*.sh` | Garde-fous déterministes : bloquer, formater, vérifier |
| Backlog | `docs/backlog.md` | Tâches ordonnées, chacune liée à des F-xx et à des critères d'acceptation |
| Gabarit de PR | `.github/pull_request_template.md` | La Definition of Done en cases à cocher |
| CI | `.github/workflows/ci.yml` | Les mêmes vérifications que le hook Stop, côté serveur |

### Skills

| Skill | Se charge pour | Contenu |
| --- | --- | --- |
| next-task | Invocation manuelle /next-task | La boucle complète : choisir la tâche, spec-guardian, branche, tests d'abord, DoD avec agents, PR, backlog et changelog |
| project-workflow | Toute tâche, `/next-task` | Prendre une tâche, branche, commits, PR, DoD, mise à jour du backlog |
| mobile-expo | `apps/mobile`, `packages/ui` | Structure d'un module, navigation, état, hors ligne d'abord, images, performances |
| backend-supabase | `supabase/`, `packages/api-client` | Migrations, gabarit de politique RLS, Edge Functions, tests SQL, environnement local |
| catalog-eur2 | `packages/plugin-eur2/data`, `tools/catalog` | Schéma, ajout d'une pièce, sources, validation, publication d'une version |
| coin-recognition-ml | `ml/`, `packages/recognition` | Jeu de données, entraînement, export, seuils, publication d'un modèle |
| design-system | `packages/ui`, écrans | Jetons de la direction choisie, composants, règles d'accessibilité |
| testing-qa | Tout code | Quoi tester et comment : Vitest, RNTL, Maestro, fixtures, couverture |
| i18n-copy | Toute chaîne visible | Clés, pluriels, ton, langues, flux de traduction |
| privacy-rgpd | Données, logs, analytics | Ce qui peut être stocké, journalisé, envoyé ; consentements |
| release | Sortie d'une version | EAS, versionnage, notes, métadonnées stores, liste de vérification |

### Agents

| Agent | Outils | Mission |
| --- | --- | --- |
| spec-guardian | Read, Grep, Glob | Vérifie qu'une tâche ou une PR respecte ce cahier des charges ; signale les dérives de périmètre |
| reviewer | Read, Grep, Glob, Bash | Revue de code : lisibilité, conventions, régressions, performance |
| test-engineer | Read, Edit, Write, Bash | Écrit et fait passer les tests manquants |
| security-privacy-auditor | Read, Grep, Glob | RLS, secrets, flux de données personnelles, permissions |
| catalog-curator | Read, Edit, Write, Bash | Ajoute et valide des entrées de catalogue depuis la liste BCE ; n'invente jamais une donnée |
| ml-engineer | Read, Edit, Write, Bash | Pipeline ML, entraînement, évaluation ; refuse une release sous les seuils |
| ux-a11y-i18n | Read, Grep, Glob | Accessibilité, chaînes traduites, simplicité du mode Aide |

### Hooks

| Événement | Filtre | Script | Effet |
| --- | --- | --- | --- |
| SessionStart | startup, resume | `session-start.sh` | Injecte branche, état git, tâche en cours, versions du catalogue et du modèle |
| PreToolUse | Bash | `guard-bash.sh` | Refuse `rm -rf`, `git push --force`, push sur `main`, `supabase db reset --linked`, `eas submit` |
| PreToolUse | Edit, Write | `guard-files.sh` | Refuse d'écrire `.env*`, une migration déjà appliquée, une release publiée |
| PostToolUse | Edit, Write | `format-on-edit.sh` | Prettier et ESLint, ou ruff, sur le fichier touché |
| PostToolUse | Edit, Write dans `data/` | `validate-catalog.sh` | Valide le JSON de catalogue et renvoie les erreurs à Claude |
| Stop | — | `stop-quality-gate.sh` | Typecheck, lint et tests des packages modifiés ; en cas d'échec, empêche l'arrêt et renvoie la raison |
| PreCompact | — | `precompact-notes.sh` | Sauvegarde branche, diff et tâche en cours dans `docs/session-notes/` |

### Permissions et garde-fous

- `.claude/settings.json` autorise sans confirmation pnpm, git (sauf push forcé), Supabase local et `eas build --profile preview` ; refuse `sudo`, `rm -rf` et les appels réseau vers des hôtes inconnus.
- Mode recommandé : `acceptEdits` pour les sessions autonomes, `plan` pour les tâches ambiguës.
- Claude ne fusionne jamais ; les branches protégées exigent une revue humaine.
- Les tâches qui touchent la vie privée ou les mineurs portent l'étiquette `needs-human` et s'arrêtent après le plan.
- Une tâche sans critère d'acceptation vérifiable est renvoyée en rédaction avant tout code.

## 12. Risques et questions ouvertes

Les deux risques qui peuvent bloquer V1 sont les droits sur les images de référence et la précision du scan sur des pièces usées ; ils sont traités dès la phase 0.

| Risque | Probabilité | Impact | Parade |
| --- | --- | --- | --- |
| Droits d'utilisation des images de pièces (instituts d'émission, Numista, Commons) | Élevée | Bloque le catalogue et l'entraînement | Vérifier les licences source par source dès la phase 0 ; demander l'autorisation aux instituts ; à défaut, photographier les pièces soi-même et collecter des photos CC0 de la communauté |
| Précision du scan sous 90 % sur pièces usées ou mal éclairées | Moyenne | Frustration, corrections fréquentes | Jeu de test réel dès la bêta ; top-3 avec confirmation ; guidage de prise de vue ; réentraînement trimestriel |
| Démarrage à froid du social : un collectionneur sans ami actif n'a aucun bénéfice | Élevée | Rétention faible | Invitation d'un aide dès l'onboarding ; l'application est déjà utile seule (catalogue, scan) ; V3 seulement quand la base existe |
| Maintenance du catalogue : 30 à 40 nouvelles pièces par an | Certaine | Catalogue obsolète en quelques mois | Agent catalog-curator plus pipeline d'import ; publication sans mise à jour store |
| Refus ou retard de publication sur les stores | Moyenne | Décalage de V1 | Suppression de compte, Sign in with Apple, justification des permissions et politique de confidentialité prêts avant soumission |
| Réaction d'un concurrent (CoinDetect, Albegor) qui ajoute une couche sociale | Moyenne | Différenciation réduite | Vitesse d'exécution ; mode Aide comme axe de communication ; qualité du hors ligne |
| Dépendance à Supabase | Faible | Migration coûteuse | Ports du moteur et adaptateurs isolés ; export complet des données possible |
| Mineurs et données personnelles | Faible en V1, moyenne en V3 | Juridique | Pas de géolocalisation ni de profil public avant V3 ; contrôle d'âge et position floutée en V3 |

### Questions ouvertes

- [x] Nom : Collection2pièces pour la V1, décidé le 2 octobre 2026 ; nom définitif choisi après la V1 ; disponibilité sur les stores et en nom de domaine à vérifier avant soumission (T-040)
- [x] Démarrage : dès le 2 octobre 2026 ; la personne consacre 30 minutes par jour au suivi et à la revue des PR
- [x] Thème par défaut : Album, décidé le 30 septembre 2026 ; Musée et Terrain restent commutables dans les réglages (section 8)
- [x] Périmètre V1 : commémoratives et faces nationales de circulation, décidé le 2 octobre 2026 ; les millésimes de circulation passent en V2 (F2.2, F3.3)
- [x] Images de référence : celles de la BCE, décidé le 2 octobre 2026 ; les droits d'utilisation restent à vérifier (premier risque ci-dessus, T-042)
- [x] Import Numista : V2, décidé le 2 octobre 2026 (F2.8)
- [x] Prix et lancement : V1 gratuite, Premium en V2 (section 9, prix à fixer avec T-053) ; lancement dans toute l'Europe dès V1 ; langues FR/EN/DE en V1 ; décidé le 2 octobre 2026
- [x] Comptes développeur Apple et Google : au nom de la personne, décidé le 2 octobre 2026 ; pas encore créés (nécessaires pour les builds iOS sur appareil et la bêta T-036)
- [ ] Périmètre par défaut d'un nouveau collectionneur : commémoratives seules (proposition du backlog, T-022) ?
- [ ] Conflits de synchronisation : dernière écriture par élément (F5.4) ou par champ (section 6, Synchronisation) ?
- [ ] Atelier : lecture proposée, en V1 un sélecteur pré-rempli que l'utilisateur confirme (F3.3, section 7), en V2 une détection automatique sans sélecteur (sections 1 et 10) ?
- [ ] Modèle de données (section 5) : où stocker le compteur « pièces scannées » de l'aide (section 2) et les signalements (F4.10) ?
- [ ] Images sous licence : seuil de 90 % des pièces avant la publication en stores (T-042) ?

## 13. Glossaire

| Terme | Définition dans ce document |
| --- | --- |
| Aide | Personne non collectionneuse liée à un collectionneur, qui utilise le mode Aide pour repérer les pièces qui lui manquent |
| Atelier | Lieu de frappe ; en Allemagne, la lettre A, D, F, G ou J sur la pièce distingue cinq variantes d'une même émission |
| BE, BU | Belle Épreuve et Brillant Universel : finitions de qualité supérieure vendues hors circulation ; hors périmètre V1 |
| Commémorative | Pièce de 2 € à face nationale spécifique, émise pour un événement, en circulation depuis 2004 |
| Dessin | Une face nationale distincte ; unité de base du catalogue et de la reconnaissance |
| Doublon | Exemplaires au-delà de ceux que l'utilisateur garde : quantité − exemplaires à garder |
| Embedding | Vecteur numérique décrivant l'image d'une pièce, comparé aux vecteurs de référence pour l'identifier |
| Face commune | Côté de la pièce identique dans toute la zone euro (carte et valeur) |
| Face nationale | Côté propre à chaque pays ; c'est elle que l'utilisateur photographie |
| Manque | Variante incluse dans le périmètre de collection et non possédée |
| Mise de côté | Déclaration d'un aide qu'il garde une pièce pour un collectionneur, en attente de remise |
| Périmètre | Réglage d'un collectionneur définissant ce qu'il collectionne (commémoratives, circulation, ateliers, millésimes) |
| Plugin | Module qui apporte un type de collection au moteur : catalogue, règles de variantes, modèle de reconnaissance |
| Port | Interface du moteur qu'un plugin ou un adaptateur implémente |
| Release | Version signée du catalogue ou du modèle, téléchargée par l'application sans passer par les stores |
| RLS | Row Level Security : règles Postgres qui limitent chaque utilisateur à ses propres lignes |
| Variante | Déclinaison collectionnable d'un dessin (par exemple une lettre d'atelier) ; unité de la collection |
