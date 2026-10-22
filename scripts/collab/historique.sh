#!/usr/bin/env bash
# Lit le journal COLLABORATION.md.
#   scripts/collab/historique.sh            -> 10 dernières entrées (tous)
#   scripts/collab/historique.sh Yotam      -> 10 dernières entrées de Yotam
#   scripts/collab/historique.sh Lenny 1    -> dernière entrée de Lenny
set -eu
. "$(dirname "$0")/_commun.sh"

filtre=""
nombre=10
if [ $# -ge 1 ]; then
  if n="$(normaliser_nom "$1")"; then filtre="$n"; shift; fi
fi
[ $# -ge 1 ] && nombre="$1"

awk -v f="$filtre" -v max="$nombre" '
  /^\*\*(Lenny|Yotam) :\*\*/ {
    garde = (f == "" || index($0, "**" f " :**") == 1)
    if (garde) { if (n >= max) exit; n++; print ""; print }
    prev_entree = 1; next
  }
  /^_.*_$/ && garde && prev_entree { print }
  { prev_entree = ($0 ~ /^\*\*(Lenny|Yotam) :\*\*/) }
  END { if (n == 0) print "Aucune entrée" (f == "" ? "" : " pour " f) " dans le journal." }
' "$JOURNAL"
