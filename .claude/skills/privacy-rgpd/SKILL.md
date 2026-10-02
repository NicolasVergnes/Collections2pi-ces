---
name: privacy-rgpd
description: Règles de protection des données de Deux — inventaire des données traitées et bases légales, ce qui peut être journalisé, consentements et opt-in (photos, notifications, analytics), suppression et export de compte, hébergement UE, mineurs, checklist à passer avant toute PR touchant des données personnelles. À charger pour comptes, photos, notifications, analytics, supabase/ ou api-client.
---
# Vie privée et RGPD

## Inventaire (à tenir à jour dans `docs/privacy/registre.md`)
| Donnée | Finalité | Base | Durée | Où |
| --- | --- | --- | --- | --- |
| id anonyme, appareil | fonctionnement du compte | contrat | vie du compte | Supabase UE |
| e-mail (compte complet) | connexion, récupération | contrat | vie du compte | Supabase Auth |
| prénom, avatar | affichage aux amis | contrat | vie du compte | `users` |
| collection (variantes, quantités) | service | contrat | vie du compte | `collection_items` |
| relations, invitations, mises de côté | service | contrat | vie du compte / 7 j pour les invitations | `relationships` `invites` `setasides` |
| photos de scan | reconnaissance | jamais envoyées sans opt-in | locale, effacée après résultat | appareil |
| photos partagées (opt-in) | amélioration du modèle | consentement | 24 mois | Storage UE, bucket privé |
| événements produit | mesure d'usage | intérêt légitime, désactivable | 13 mois | analytics anonymisés |
| position | proximité (V3 seulement) | consentement | — | — |

## Règles
- Aucune photo ne quitte l'appareil sans le drapeau d'opt-in explicite (`settings.sharePhotos = true`), et `recognition_feedback.image_ref` reste `null` sinon.
- Journaux (application, Edge Functions, CI) : aucun e-mail, prénom, image, jeton d'invitation ni identifiant d'appareil. Identifiant utilisateur haché si nécessaire.
- Analytics : événements sans contenu (`scan_completed`, `helper_set_aside`), pas d'identifiant publicitaire, désactivables dans les réglages, pas de SDK tiers non listé dans l'ADR.
- Permissions mobiles demandées au moment de l'usage avec une phrase d'explication ; refus toujours possible sans bloquer le reste de l'application.
- Compte : export JSON (`export-data`) et suppression (`delete-account`) en un écran ; purge complète sous 30 jours ; les mises de côté et relations sont supprimées côté amis.
- Mineurs : pas de profil public, pas de position, pas de messagerie libre ; les échanges V2 sont limités aux relations acceptées.
- Hébergement et sous-traitants : UE uniquement ; toute nouvelle dépendance réseau est listée dans `docs/privacy/sous-traitants.md`.

## Checklist PR (à recopier dans la description)
- [ ] Nouvelle donnée personnelle ? → ligne ajoutée au registre, base légale, durée.
- [ ] Nouvelle table ? → RLS + test pgTAP.
- [ ] Nouveau log ? → vérifié sans donnée personnelle.
- [ ] Nouvelle permission ou SDK ? → justification et ADR.
- [ ] Suppression de compte toujours complète (test `delete-account.yaml`).
