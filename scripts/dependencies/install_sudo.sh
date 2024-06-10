#!/bin/bash
set -euo pipefail

install_sudo(){

  log "[LOG] VÉRIFICATION DE L'INSTALLATION DE SUDO..."

  if ! command -v sudo &>/dev/null; then
    log "[WARNING] LE PAQUET SUDO N'EST PAS INSTALLÉ, INSTALLATION EN COURS..."
    if apt-get install sudo -y; then
      log "[SUCCESS] LE PAQUET SUDO A ÉTÉ INSTALLÉ AVEC SUCCÈS."
      sudo -V | grep -o "Sudo version [0-9.]*"
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET SUDO."
      exit 1
    fi
  else
    log "[OK] LE PAQUET SUDO EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
    sudo -V | grep -o "Sudo version [0-9.]*"
  fi

}