#!/usr/bin/env bash
# Identité du développeur sur CET ordinateur (fichier .claude/identite.local, ignoré par Git).
#   scripts/collab/identite.sh          -> affiche l'identité (code 1 si inconnue)
#   scripts/collab/identite.sh Yotam    -> enregistre l'identité et active les hooks Git
set -u
. "$(dirname "$0")/_commun.sh"

if [ $# -eq 0 ]; then
  if nom="$(lire_identite)"; then
    echo "$nom"
  else
    echo "Identité inconnue. Demander : « Tu es Lenny ou Yotam ? » puis lancer : scripts/collab/identite.sh <Lenny|Yotam>" >&2
    exit 1
  fi
  exit 0
fi

nom="$(normaliser_nom "$1")" || { echo "Prénom invalide : « $1 ». Valeurs possibles : Lenny, Yotam." >&2; exit 1; }
mkdir -p "$RACINE/.claude"
printf '%s\n' "$nom" > "$FICHIER_IDENTITE"
git -C "$RACINE" config core.hooksPath .githooks
echo "Identité enregistrée sur cet ordinateur : $nom (hooks Git activés)."
