#!/usr/bin/env bash
# Lancé automatiquement quand Claude termine de répondre (hook Stop).
# Rappelle UNE fois de tenir le journal si le projet a changé sans entrée correspondante.
. "$(dirname "$0")/_commun.sh"
cd "$RACINE" || exit 0

entree="$(cat)"
# Évite une boucle : si Claude répond déjà à un rappel de ce hook, on laisse passer.
printf '%s' "$entree" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

messages=""
modifs="$(git status --porcelain 2>/dev/null)"
[ -n "$modifs" ] && messages="Des fichiers du projet sont modifiés mais non commités. "

# Dernier commit de travail (hors commits « Journal : ») absent du journal ?
dernier="$(git log --no-merges -n 20 --format='%h %s' 2>/dev/null | grep -v ' Journal : ' | head -n 1 | cut -d' ' -f1)"
if [ -n "$dernier" ] && ! grep -q "\`$dernier" "$JOURNAL" 2>/dev/null; then
  messages="${messages}Le commit $dernier n'a pas d'entrée dans COLLABORATION.md. "
fi

# Ne rappeler qu'une fois pour un même état, pour ne pas gêner une simple conversation.
etat="$(printf '%s|%s' "$modifs" "$dernier" | cksum | cut -d' ' -f1)"
rappel="$RACINE/.claude/collab-rappel.local"
[ -f "$rappel" ] && [ "$(cat "$rappel")" = "$etat" ] && exit 0

if [ -n "$messages" ]; then
  printf '%s' "$etat" > "$rappel"
  echo "Rappel collaboration : ${messages}Si cette tâche a réellement modifié le projet, suivre la procédure de fin de tâche de CLAUDE.md (commit clair, puis scripts/collab/journal.sh). Sinon (simple conversation, ou travail déjà journalisé par l'autre développeur), ignorer ce rappel." >&2
  exit 2
fi
exit 0
