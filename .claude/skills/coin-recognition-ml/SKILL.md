---
name: coin-recognition-ml
description: Pipeline de reconnaissance des pièces de Deux — organisation de ml/, jeux de données et augmentations, entraînement de l'embedding ArcFace, construction de l'index, export TFLite/CoreML, évaluation et seuils de publication, seuils d'inférence, ajout d'une pièce sans réentraînement, versionnage des releases, intégration dans packages/recognition. À charger pour ml/ ou packages/recognition.
---
# Reconnaissance des pièces

## Organisation
```
ml/
  configs/effnet_lite0.yaml           hyperparamètres, seed
  data/references/<coin-id>/*.jpg     images de référence ; licences dans data/references/LICENSES.csv
  data/real-test/<coin-id>/*.jpg      photos réelles de test — JAMAIS en entraînement ni en sélection de modèle
  data/ood/*.jpg                      hors domaine : 1 €, 50 c, jetons, boutons, objets ronds
  src/augment.py train.py build_index.py export.py eval.py
  runs/<id>/                          journaux, best.pt, config figée
  releases/<semver>/                  model.tflite model.mlpackage index.bin metrics.json manifest.json
  releases/LATEST                     version courante
```

## Commandes (Python 3.13, uv)
```
uv run python -m src.train --config configs/effnet_lite0.yaml
uv run python -m src.build_index --model runs/<id>/best.pt --out runs/<id>/index.bin
uv run python -m src.export --model runs/<id>/best.pt --index runs/<id>/index.bin --out releases/<semver>/
uv run python -m src.eval --release releases/<semver>/          # écrit metrics.json, échoue sous les seuils
pnpm ml:eval                                                     # alias utilisé par la CI
```

## Modèle
- Détection : recadrage du disque par transformée de Hough (OpenCV) côté application, entrée 224×224.
- Embedding : EfficientNet-Lite0 (ou MobileNetV3-Large si la latence l'exige) → projection 128-d, perte ArcFace (m = 0,3, s = 30), invariance à la rotation apprise par augmentation 0–360°.
- Index : embedding moyen par dessin et par vue, distance cosinus, kNN k = 5 ; deux classes de rejet : `common_side` (face commune → « retourne la pièce ») et `ood`.
- Quantification INT8 post-entraînement (AI Edge Quantizer) ; export LiteRT `.tflite` via `litert-torch` (ex ai-edge-torch ; format de fichier inchangé) pour react-native-fast-tflite 5, et CoreML via coremltools pour iOS.

## Augmentations obligatoires
Rotation 0–360°, flou de bougé, bruit, reflets spéculaires synthétiques, usure (érosion des reliefs), variations d'éclairage et de balance des blancs, perspective ±15°, fonds variés (main, table, tissu, tapis de caisse), recadrage imparfait ±10 %, compression JPEG.

## Seuils de publication (`metrics.json`)
`top1_real ≥ 0.90`, `top3_real ≥ 0.97`, `ood_fp ≤ 0.02`, `common_side_recall ≥ 0.95`, `p90_latency_ms ≤ 1500` (Pixel 6a et iPhone 12), `size_mb ≤ 12`. `src/eval.py` sort en erreur si un seuil manque ; on ne publie jamais en contournant ni en abaissant un seuil.

## Seuils d'inférence (`packages/recognition/src/thresholds.ts`)
`score ≥ 0.80` → un candidat ; `0.55 ≤ score < 0.80` → trois candidats ; `< 0.55` → non reconnue avec conseils (lumière, cadrage) ; classe `common_side` → « retourne la pièce » ; classe `ood` → « ce n'est pas une pièce de 2 € ». Les seuils sont des constantes versionnées avec le modèle (`manifest.json.thresholds`), pas des valeurs en dur dans l'UI.

## Ajouter une pièce sans réentraîner
Ajouter ≥ 1 image de référence licenciée → `build_index` → `export` → release mineure (`x.(y+1).0`). Réentraînement complet chaque trimestre ou si `top1_real < 0.90` → release majeure. `manifest.json` porte `catalogVersion` minimale compatible.

## Boucle de retour
Les corrections d'utilisateurs (`recognition_feedback`) alimentent les métriques ; leurs photos n'entrent dans `data/` que si `image_ref` est non nul (opt-in) et après revue de la personne. Rien d'automatique.
