#!/bin/bash
set -euo pipefail

install_jq(){

   log "[LOG] VÉRIFICATION DE L'INSTALLATION DE JQ (JSON PROCESSOR) SUR LE SYSTÈME..."

   if ! command -v jq &>/dev/null; then
     log "[WARNING] LE PAQUET JQ N'EST PAS INSTALLÉ SUR LE SYSTÈME, INSTALLATION EN COURS..."
     if sudo apt-get install jq -y; then
       log "[SUCCESS] LE PAQUET JQ A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR LE SYSTÈME."
       jq -V
     else
       log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET JQ."
       log "[DEBUG] ESSAYEZ D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install jq -y"
       exit 1
     fi
   else
     log "[OK] LE PAQUET JQ EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
     jq -V
   fi

}