#!/bin/bash
set -euo pipefail

user_create(){

  log "[LOG] VÉRIFICATION & CRÉATION DE L'UTILISATEUR $USER_ACCOUNT SUR $HOSTNAME EN COURS..."

  if id "$USER_ACCOUNT" &>/dev/null; then
    log "[OK] L'UTILISATEUR $USER_ACCOUNT EXISTE DÉJÀ SUR $HOSTNAME."
    echo "Utilisateur: $(id -u "$USER_ACCOUNT")"

  else
    log "[WARNING] L'UTILISATEUR $USER_ACCOUNT N'EXISTE PAS SUR $HOSTNAME, CRÉATION EN COURS..."
    sleep 1

    if sudo adduser "$USER_ACCOUNT" -c "ARK: Ascended Server" --gecos ""; then
      log "[SUCCESS] L'UTILISATEUR $USER_ACCOUNT A ÉTÉ CRÉÉ AVEC SUCCÈS SUR $HOSTNAME."
      echo "Utilisateur: $(id -u "$USER_ACCOUNT")"

    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CRÉATION DE L'UTILISATEUR $USER_ACCOUNT."
      log "[DEBUG] ESSAYEZ DE CRÉER L'UTILISATEUR $USER_ACCOUNT MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo adduser $USER_ACCOUNT -c \"ARK: Ascended Server\" --gecos \"\""
      exit 1
    fi
  fi

}