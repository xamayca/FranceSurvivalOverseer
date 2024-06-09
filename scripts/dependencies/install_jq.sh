#!/bin/bash
set -euo pipefail

install_jq(){

   log "[LOG] VÉRIFICATION DE L'INSTALLATION DE JQ..."

   if ! command -v jq &>/dev/null; then
     log "[WARNING] LE PAQUET JQ N'EST PAS INSTALLÉ, INSTALLATION EN COURS..."
     if sudo apt-get install jq -y; then
       log "[SUCCESS] LE PAQUET JQ A ÉTÉ INSTALLÉ AVEC SUCCÈS."
       jq -V
     else
       log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET JQ."
       exit 1
     fi
   else
     log "[OK] LE PAQUET JQ EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
   fi

}