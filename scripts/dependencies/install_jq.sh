#!/bin/bash
set -euo pipefail

install_jq(){

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET JQ EN COURS SUR $HOSTNAME..."
  if command -v jq &>/dev/null; then
    log "[OK] LE PAQUET JQ EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
     jq -V
   else
     log "[WARNING] LE PAQUET JQ N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS."
     if sudo apt-get install jq -y; then
       log "[SUCCESS] LE PAQUET JQ A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
       jq -V
     else
       log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET JQ SUR $HOSTNAME."
       log "[DEBUG] ESSAYEZ D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
       log "[DEBUG] sudo apt-get install jq -y"
       exit 1
     fi
  fi

}