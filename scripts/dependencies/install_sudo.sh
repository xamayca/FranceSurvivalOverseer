#!/bin/bash
set -euo pipefail

install_sudo(){

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET SUDO EN COURS SUR $HOSTNAME..."
  if command -v sudo &>/dev/null; then
    log "[OK] LE PAQUET SUDO EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    sudo -V | grep -o "Sudo version [0-9.]*"
  else
    log "[WARNING] LE PAQUET SUDO N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS."
    if apt-get install sudo -y; then
      log "[SUCCESS] LE PAQUET SUDO A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
      sudo -V | grep -o "Sudo version [0-9.]*"
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET SUDO."
      log "[DEBUG] ESSAYEZ D'INSTALLEZ LE PAQUET SUDO MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] apt-get install sudo -y"
      exit 1
    fi
  fi

}