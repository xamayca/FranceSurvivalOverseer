#!/bin/bash
set -euo pipefail

install_non_free_repo(){
  log "[LOG] VÉRIFICATION & AJOUT DES DÉPÔTS NON FREE SUR $HOSTNAME..."
  if grep -q "$NON_FREE_REPO" /etc/apt/sources.list; then
    log "[OK] LES DÉPÔTS NON FREE SONT DÉJÀ AJOUTÉS SUR $HOSTNAME."
  else
    log "[WARNING] LES DÉPÔTS NON FREE NE SONT PAS ENCORE AJOUTÉS SUR $HOSTNAME, AJOUT EN COURS."
    if sudo add-apt-repository "deb $NON_FREE_REPO" -y; then
      log "[SUCCESS] LES DÉPÔTS NON FREE ONT ÉTÉ AJOUTÉS AVEC SUCCÈS SUR $HOSTNAME."
      system_update
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DES DÉPÔTS NON FREE SUR $HOSTNAME."
      log "[DEBUG] POUR AJOUTER LES DÉPÔTS NON FREE MANUELLEMENT, VEUILLEZ AJOUTER LA LIGNE SUIVANTE DANS VOTRE FICHIER /etc/apt/sources.list:"
      log "[DEBUG] deb $NON_FREE_REPO"
      exit 1
    fi
  fi

}