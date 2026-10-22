# CLAUDE.md — Projet de jeu iPhone de Lenny & Yotam

Ce dépôt est partagé par deux développeurs, **Lenny** et **Yotam**, qui travaillent chacun avec leur propre Claude Code. GitHub (`origin`) est la source commune. Ces règles s'appliquent à **toutes** les sessions, même si elles ne sont pas rappelées. Réponds toujours en français.

## 1. Identité du développeur

- L'identité est stockée **sur chaque ordinateur** dans `.claude/identite.local` (ignoré par Git). Lis-la avec `scripts/collab/identite.sh`.
- Si elle est inconnue, la première chose à faire est de demander simplement : **« Tu es Lenny ou Yotam ? »**, puis d'enregistrer la réponse avec `scripts/collab/identite.sh <Lenny|Yotam>` (ce script active aussi les hooks Git).
- Ne déduis **jamais** l'identité à partir du compte GitHub, de l'adresse e-mail ou du nom d'utilisateur système.
- « L'autre développeur » désigne Yotam si l'utilisateur est Lenny, et inversement.

## 2. Avant de commencer une tâche

Le hook `SessionStart` affiche automatiquement l'identité, l'état Git et les dernières entrées du journal. Avant toute modification du projet, même si ce résumé est déjà présent :

1. `git status` : repérer les modifications locales non commitées (ne jamais les écraser).
2. `git fetch origin`, puis récupérer les changements distants **sans écraser le travail local** : `git pull --ff-only`. Si l'historique a divergé ou qu'il y a des modifications locales, ne force rien : explique la situation et propose une fusion contrôlée.
3. Lire les dernières entrées de `COLLABORATION.md` (`scripts/collab/historique.sh`) et, si utile, `git log --oneline -15 origin/main`.
4. Vérifier que la tâche demandée n'a pas déjà été réalisée par l'autre développeur. Si c'est le cas, le signaler avant de refaire quoi que ce soit.
5. Signaler tout conflit (fichiers en conflit, travail de l'autre sur les mêmes fichiers, branche en retard).

## 3. Pendant le travail

- Ne jamais supprimer, écraser ou réécrire le travail de l'autre développeur sans l'autorisation explicite de l'utilisateur.
- Si une modification contredit un choix fait par l'autre (visible dans le journal ou les commits), le dire et demander avant de continuer.
- Si les deux travaillent en même temps, travailler sur une branche séparée (ex. `lenny/menu-principal`, `yotam/deplacement`) et fusionner de façon contrôlée (pull request sur GitHub de préférence).
- Une modification locale n'est **pas** visible par l'autre tant qu'elle n'a pas été poussée sur GitHub.

## 4. Après une tâche qui a réellement modifié le projet

1. Identifier les fichiers modifiés (`git status`, `git diff --stat`).
2. Résumer les changements en une phrase courte et compréhensible.
3. Vérifier qu'ils ne contredisent pas le travail de l'autre développeur.
4. Créer un commit clair (après validation de l'utilisateur si nécessaire). Le hook Git ajoute automatiquement la ligne `Developpeur: <prénom>`.
5. Ajouter l'entrée au journal : `scripts/collab/journal.sh "Description courte"`. Le script écrit le prénom, la date, l'heure et le commit, en haut de `COLLABORATION.md`, puis commite le journal.
6. Proposer l'envoi vers GitHub (`git push`, ou `git push -u origin <branche>` pour une nouvelle branche).

Pas d'entrée de journal pour une simple conversation, une question ou une lecture sans modification.

Le hook `Stop` rappelle une fois cette procédure s'il voit des fichiers non commités ou un commit sans entrée. C'est un filet de sécurité, pas une garantie : la responsabilité de tenir le journal reste dans cette procédure.

## 5. Le journal `COLLABORATION.md`

- Format d'une entrée (ajoutée par `scripts/collab/journal.sh`) :
  ```
  **Yotam :** Modification du système de déplacement du personnage.
  _2026-10-22 18:30 (CEST) · commit `abc1234`_
  ```
- Ordre : la plus récente en premier, juste sous le marqueur.
- Ne jamais effacer ni réécrire une ancienne entrée. Pour corriger, ajouter une nouvelle entrée.
- En cas de conflit Git sur ce fichier, garder les entrées des deux développeurs et les classer par date.

## 6. Questions sur le travail de l'autre

Exemples : « Qu'est-ce que Yotam a fait la dernière fois ? », « Qui a fait la dernière modification ? », « Qu'est-ce qui a changé depuis ma dernière session ? », « Résume-moi les dernières modifications de Lenny ».

1. Actualiser si possible : `git fetch origin` (et comparer avec `origin/main` et les branches de l'autre : `git branch -r`).
2. Consulter le journal : `scripts/collab/historique.sh Yotam 1` (dernière entrée de Yotam), `scripts/collab/historique.sh Lenny 5`, `scripts/collab/historique.sh` (tout le monde). Penser à lire aussi la version distante : `git show origin/main:COLLABORATION.md`.
3. Vérifier les commits si nécessaire : `git log origin/main --oneline`, `git log --grep "Developpeur: Lenny"`.
4. Répondre clairement en français, sans jamais inventer de modification. Si on demande la dernière modification de Yotam, donner directement la dernière entrée de **Yotam**, même si Lenny a travaillé depuis (et inversement).
5. « Depuis ma dernière session » : prendre la dernière entrée du développeur actuel comme repère et lister ce qui a été ajouté après.

## 7. Git : interdits sans autorisation explicite

- `git push --force` / `--force-with-lease`, `git reset --hard`, `git rebase` d'une branche publiée, `git clean -fd`.
- Supprimer une branche (locale ou distante) ou un fichier appartenant au travail de l'autre.
- Ne jamais réinitialiser le dépôt ni recréer le système de collaboration : s'il existe déjà, le réutiliser.

## 8. Le jeu

Objectif : un jeu mobile iPhone pour l'App Store. **Aucun concept, genre, moteur ni gameplay n'est encore choisi.** Ne commence pas à développer le jeu tant que Lenny et Yotam n'ont pas décidé ensemble du concept et des technologies. Les décisions prises seront notées dans la section « Décisions » de `COLLABORATION.md`.

Le système de collaboration est indépendant du moteur (Unity, Godot, Swift…). Quand le moteur sera choisi, compléter `.gitignore` avec les fichiers à ignorer pour ce moteur.

## 9. Outils de collaboration

| Fichier | Rôle |
|---|---|
| `scripts/collab/identite.sh` | Lire / enregistrer l'identité de l'ordinateur |
| `scripts/collab/journal.sh` | Ajouter une entrée au journal et la commiter |
| `scripts/collab/historique.sh` | Lire le journal, filtré par développeur |
| `scripts/collab/debut-session.sh` | Hook `SessionStart` (lecture seule) |
| `scripts/collab/fin-tache.sh` | Hook `Stop` (rappel du journal) |
| `.githooks/commit-msg` | Ajoute `Developpeur: <prénom>` aux commits |
| `.claude/settings.json` | Déclare les hooks Claude Code (partagé) |
