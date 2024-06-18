#!/bin/bash
set -euo pipefail

system_update(){

if [ "$(id -u)" != "0" ] && [ "$USER" != "$USER_ACCOUNT" ]; then
  log "[ERROR] CE SCRIPT DOIT ÊTRE EXÉCUTÉ AVEC LES PRIVILÈGES ROOT OU AVEC L'UTILISATEUR $USER_ACCOUNT."
  log "[DEBUG] VEUILLEZ EXECUTER LE SCRIPT AVEC LA COMMANDE: sudo $0 OU sudo -u $USER_ACCOUNT $0"
  exit 1
else
  log "[INFO] VÉRIFICATION DES PRIVILÈGES ROOT OU DE L'UTILISATEUR $USER_ACCOUNT: OK."
fi

update(){
  log "[LOG] VÉRIFICATION DES MISES À JOUR DISPONIBLES EN COURS..."
  if $1 apt-get update && $1 apt-get upgrade --simulate && $1 apt-get dist-upgrade --simulate | grep -q "The following packages will be upgraded"; then
    log "[WARNING] UNE MISE À JOUR EST DISPONIBLE POUR $HOSTNAME."
  else
    log "[OK] AUCUNE MISE À JOUR DISPONIBLE POUR $HOSTNAME."
    return 0
  fi

  # Si des mises à jour sont disponibles, procéder à leur installation
  if $1 apt-get update && $1 apt-get upgrade -y && $1 apt-get dist-upgrade -y; then
    log "[SUCCESS] MISES À JOUR INSTALLÉES AVEC SUCCÈS SUR $HOSTNAME."
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DES MISES À JOUR SUR $HOSTNAME."
    log "[DEBUG] VEUILLEZ VÉRIFIER VOTRE CONNEXION INTERNET ET ESSAYER À NOUVEAU."
    exit 1
  fi
}

if [ "$(id -u)" = "0" ]; then
  update ""
elif [ "$USER" = "$USER_ACCOUNT" ]; then
  update "sudo"
elif [ -n "$USER" ]; then
  update "sudo -u $USER_ACCOUNT"
fi

}

