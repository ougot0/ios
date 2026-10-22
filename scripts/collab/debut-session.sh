#!/usr/bin/env bash
# Lancé automatiquement au début de chaque session Claude Code (hook SessionStart).
# Sa sortie est ajoutée au contexte de Claude. Ne modifie jamais les fichiers du projet.
. "$(dirname "$0")/_commun.sh"
cd "$RACINE" || exit 0

echo "=== Collaboration Lenny & Yotam ==="
if nom="$(lire_identite)"; then
  echo "Développeur sur cet ordinateur : $nom"
  [ "$(git config core.hooksPath)" = ".githooks" ] || git config core.hooksPath .githooks
else
  echo "IDENTITÉ INCONNUE sur cet ordinateur. Avant toute autre chose, demander : « Tu es Lenny ou Yotam ? »"
  echo "puis enregistrer la réponse avec : scripts/collab/identite.sh <Lenny|Yotam>"
fi

branche="$(git branch --show-current 2>/dev/null)"
echo "Branche actuelle : ${branche:-(détachée)}"

# Récupère l'état distant sans rien modifier localement (fetch uniquement).
if git remote get-url origin >/dev/null 2>&1; then
  if git fetch --quiet origin 2>/dev/null; then
    amont="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)"
    if [ -n "$amont" ]; then
      set -- $(git rev-list --left-right --count "HEAD...$amont" 2>/dev/null)
      echo "Par rapport à $amont : ${1:-0} commit(s) local(aux) non publié(s), ${2:-0} commit(s) distant(s) à récupérer."
      [ "${2:-0}" -gt 0 ] && echo "-> Récupérer avec : git pull --ff-only (ou fusion contrôlée si l'historique a divergé)."
    else
      echo "La branche n'a pas de branche distante associée (pas encore publiée sur GitHub)."
    fi
    git show origin/main:COLLABORATION.md >/dev/null 2>&1 && ! git diff --quiet HEAD origin/main -- COLLABORATION.md 2>/dev/null \
      && echo "Le journal sur origin/main diffère de la version locale : consulter 'git log origin/main -- COLLABORATION.md'."
  else
    echo "Impossible de contacter GitHub (hors ligne ?). Les informations ci-dessous peuvent être en retard."
  fi
else
  echo "Aucun dépôt distant 'origin' configuré : voir README.md pour connecter GitHub."
fi

if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  echo "Modifications locales non commitées :"
  git status --short | head -20
fi
git ls-files -u 2>/dev/null | grep -q . && echo "ATTENTION : conflits de fusion non résolus. Les signaler au développeur."

echo
echo "Dernières entrées du journal :"
"$RACINE/scripts/collab/historique.sh" 5
exit 0
