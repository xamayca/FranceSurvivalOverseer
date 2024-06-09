#!/bin/bash
set -euo pipefail

install_curl(){

  log "[LOG] VÉRIFICATION DE L'INSTALLATION DE CURL..."

   if ! command -v curl &>/dev/null; then
    log "[WARNING] LE PAQUET CURL N'EST PAS INSTALLÉ, INSTALLATION EN COURS..."
    if sudo apt-get install curl -y; then
      log "[SUCCESS] LE PAQUET CURL A ÉTÉ INSTALLÉ AVEC SUCCÈS."
      curl -V 2>&1 | grep -o "curl [0-9.]*"
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET CURL."
      exit 1
    fi
  else
    log "[OK] LE PAQUET CURL EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
  fi

}