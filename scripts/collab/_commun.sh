#!/usr/bin/env bash
# Fonctions partagées par les scripts de collaboration. Ne pas exécuter directement.

RACINE="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Erreur : ce script doit être lancé depuis le dépôt Git du projet." >&2
  exit 1
}
FICHIER_IDENTITE="$RACINE/.claude/identite.local"
JOURNAL="$RACINE/COLLABORATION.md"
MARQUEUR='<!-- NOUVELLES ENTRÉES CI-DESSOUS (la plus récente en premier) -->'

# Affiche le prénom enregistré sur cet ordinateur (Lenny ou Yotam), ou rien.
lire_identite() {
  [ -f "$FICHIER_IDENTITE" ] || return 1
  normaliser_nom "$(tr -d '[:space:]' < "$FICHIER_IDENTITE")"
}

# Normalise une saisie (« lenny », « YOTAM »…) vers Lenny ou Yotam.
normaliser_nom() {
  case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    lenny) echo "Lenny" ;;
    yotam) echo "Yotam" ;;
    *) return 1 ;;
  esac
}
