---
name: backend-supabase
description: Conventions Supabase de Deux — environnement local, migrations immuables, gabarit de politique RLS et test pgTAP, vues friend_wants et friend_duplicates, Edge Functions (invitations, mises de côté, suppression de compte, export), auth anonyme, releases signées de catalogue et de modèle, types générés. À charger pour tout fichier de supabase/ ou packages/api-client.
---
# Backend Supabase

## Environnement
- Supabase CLI ≥ 2.107 (`pg-delta` est le moteur de diff par défaut). `supabase start` (Docker) ; `supabase db reset` rejoue migrations + `supabase/seed.sql` ; `supabase test db` lance pgTAP ; `supabase db advisors` avant chaque PR touchant le schéma.
- Jamais de commande `--linked`, `db push` ou `db remote` : la base distante est réservée à la personne et à la CI.
- Région du projet distant : UE (eu-central-1). Ne change pas de région.

## Migrations
- `supabase migration new <verbe_objet>` → fichier daté ; jamais modifié après fusion (le hook le bloque).
- Une migration = tables + index + politiques RLS + test pgTAP dans `supabase/tests/<nom>.test.sql`.
- Colonnes standard : `id uuid default gen_random_uuid()`, `created_at timestamptz default now()`, `updated_at timestamptz` (trigger `set_updated_at`), `deleted_at timestamptz` pour la suppression logique synchronisée.

## Gabarit RLS (obligatoire pour chaque table)
```sql
alter table public.collection_items enable row level security;
create policy "owner select" on public.collection_items for select
  using (exists (select 1 from public.collections c where c.id = collection_id and c.user_id = auth.uid()));
create policy "owner insert" on public.collection_items for insert
  with check (exists (select 1 from public.collections c where c.id = collection_id and c.user_id = auth.uid()));
create policy "owner update" on public.collection_items for update
  using (exists (select 1 from public.collections c where c.id = collection_id and c.user_id = auth.uid()));
create policy "owner delete" on public.collection_items for delete
  using (exists (select 1 from public.collections c where c.id = collection_id and c.user_id = auth.uid()));
```
Test pgTAP minimal : A lit ses lignes ; A ne lit pas celles de B ; un anonyme (`anon`) ne lit rien ; un ami lit `friend_wants` mais pas `collection_items`.

## Ce que voit un ami ou un aide
Jamais la table brute. La vue `friend_wants(collector_id, variant_id)` (`security_invoker = true`) joint `relationships` acceptées et calcule manques = périmètre du collectionneur − variantes possédées. `friend_duplicates(collector_id, variant_id, quantity)` expose quantité − à garder, uniquement entre collectionneurs.

## Edge Functions (Deno, `supabase/functions/<nom>/index.ts`)
V1 : `create-invite`, `accept-invite`, `set-aside`, `cancel-set-aside`, `delete-account`, `export-data`. V2 : `swap-propose`, `swap-accept`, `swap-complete`, `numista-import`.
Règles : vérifier le JWT (`auth.getUser`) ; valider l'entrée avec zod ; limite de débit 30 requêtes/min/utilisateur (table `rate_limits`) ; ne jamais renvoyer une ligne d'un autre utilisateur ; journaliser sans donnée personnelle ; réponse `{ ok, data | error }`.
Invitations : jeton 128 bits aléatoires (`gen_random_bytes(16)` encodé base64url), expiration 7 jours, usage unique par défaut, révocable.

## Comptes
Auth anonyme activée ; conversion via `updateUser({ email })` puis vérification ; l'id est conservé. `delete-account` supprime en cascade et planifie la purge Storage sous 30 jours (pg_cron). `export-data` renvoie un JSON de toutes les données de l'utilisateur.

## Releases (catalogue et modèle)
Tables `catalog_releases` et `model_releases` : `version` semver, `url` Storage, `sha256`, `signature` (Ed25519, clé privée détenue par la personne), `min_app_version`, `published_at`. L'application refuse une release dont la signature ne vérifie pas. Claude prépare la ligne avec `signature = null` ; la personne signe et publie.

## Client
`packages/api-client` implémente `SocialRepository`, `SyncTransport`, `ReleaseChecker`, `FeatureFlags`. Types générés : `supabase gen types typescript --local > packages/api-client/src/database.types.ts` après chaque migration (commité).
