# ios — jeu iPhone de Lenny & Yotam

Le concept du jeu n'est pas encore défini. Ce dépôt contient pour l'instant le système de collaboration entre nos deux Claude Code (voir `CLAUDE.md` et `COLLABORATION.md`).

## Mise en place sur un nouvel ordinateur

1. Avoir accès au dépôt : le propriétaire invite l'autre développeur dans **Settings → Collaborators → Add people** sur GitHub, puis l'invitation est acceptée par e-mail ou sur github.com.
2. Cloner : `git clone https://github.com/ougot0/ios.git && cd ios`
3. Lancer Claude Code dans le dossier. Au premier lancement, il demande « Tu es Lenny ou Yotam ? » et enregistre la réponse sur l'ordinateur (`.claude/identite.local`, jamais envoyé sur GitHub).
   Manuellement : `scripts/collab/identite.sh Lenny` (ou `Yotam`).
4. Claude Code demandera d'approuver les hooks du projet (`.claude/settings.json`) : les accepter.

Les scripts sont en bash (macOS et Linux ; sous Windows, utiliser Git Bash ou WSL). Aucune dépendance à installer.
