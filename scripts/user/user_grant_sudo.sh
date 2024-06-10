#!/bin/bash
set -euo pipefail

grant_sudo(){

  log "[LOG] VÉRIFICATION & AJOUT DE L'UTILISATEUR $USER_ACCOUNT AU GROUPE SUDO EN COURS SUR $HOSTNAME..."

  # Vérifier si l'utilisateur est dans le groupe sudo
  if groups "$USER_ACCOUNT" | grep "\bsudo\b" &>/dev/null; then
  log "[OK] L'UTILISATEUR $USER_ACCOUNT EST DÉJÀ DANS LE GROUPE SUDO SUR $HOSTNAME."
  echo "Groupes: $(groups "$USER_ACCOUNT")"

  else
      log "[WARNING] L'UTILISATEUR $USER_ACCOUNT N'EST PAS DANS LE GROUPE SUDO SUR $HOSTNAME, AJOUT EN COURS..."

      if sudo usermod -aG sudo "$USER_ACCOUNT"; then
        log "[SUCCESS] L'UTILISATEUR $USER_ACCOUNT A ÉTÉ AJOUTÉ AU GROUPE SUDO SUR $HOSTNAME AVEC SUCCÈS."
        echo "Groupes: $(groups "$USER_ACCOUNT")"

      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE L'UTILISATEUR $USER_ACCOUNT AU GROUPE SUDO SUR $HOSTNAME."
        log "[DEBUG] ESSAYEZ D'AJOUTER L'UTILISATEUR $USER_ACCOUNT AU GROUPE SUDO MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo usermod -aG sudo $USER_ACCOUNT"
        exit 1
      fi
  fi

}