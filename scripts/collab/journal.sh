#!/usr/bin/env bash
# Ajoute une entrée en haut de COLLABORATION.md puis la commite (seul ce fichier est commité).
#   scripts/collab/journal.sh "Description courte"                -> lie l'entrée au dernier commit (HEAD)
#   scripts/collab/journal.sh --commit abc1234 "Description"      -> lie l'entrée à un commit précis
#   scripts/collab/journal.sh --sans-commit "Description"         -> aucun commit Git associé
# Usage normal : 1) commiter le travail, 2) lancer ce script.
set -eu
. "$(dirname "$0")/_commun.sh"

nom="$(lire_identite)" || { echo "Identité inconnue : lancer d'abord scripts/collab/identite.sh <Lenny|Yotam>." >&2; exit 1; }

commit=""
sans_commit=0
while [ $# -gt 0 ]; do
  case "$1" in
    --commit) commit="$2"; shift 2 ;;
    --sans-commit) sans_commit=1; shift ;;
    *) break ;;
  esac
done
description="$*"
[ -n "$description" ] || { echo "Description manquante." >&2; exit 1; }
grep -qF "$MARQUEUR" "$JOURNAL" || { echo "Marqueur introuvable dans COLLABORATION.md." >&2; exit 1; }

if [ "$sans_commit" -eq 1 ]; then
  ref="aucun commit"
else
  [ -n "$commit" ] || commit="HEAD"
  court="$(git -C "$RACINE" rev-parse --short "$commit" 2>/dev/null)" || { echo "Commit introuvable : $commit" >&2; exit 1; }
  ref="commit \`$court\`"
fi
quand="$(date '+%Y-%m-%d %H:%M (%Z)')"

tmp="$(mktemp)"
awk -v m="$MARQUEUR" -v e1="**$nom :** $description" -v e2="_${quand} · ${ref}_" '
  { print }
  $0 == m && !fait { print ""; print e1; print e2; fait = 1 }
' "$JOURNAL" > "$tmp"
mv "$tmp" "$JOURNAL"

git -C "$RACINE" add COLLABORATION.md
git -C "$RACINE" commit -q -m "Journal : $description" -- COLLABORATION.md
echo "Entrée ajoutée et commitée : $nom — $description ($ref)"
