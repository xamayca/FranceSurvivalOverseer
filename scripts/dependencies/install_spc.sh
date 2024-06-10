#!/bin/bash
set -euo pipefail

install_spc(){

 log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET SOFTWARE PROPERTIES COMMON EN COURS SUR $HOSTNAME..."

 if ! dpkg -l software-properties-common &> /dev/null; then
   log "[WARNING] LE PAQUET SOFTWARE PROPERTIES COMMON N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
   if sudo apt-get install software-properties-common -y; then
     log "[SUCCESS] LE PAQUET SOFTWARE PROPERTIES COMMON A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
     dpkg -s software-properties-common | grep 'Version'
   else
     log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET SOFTWARE PROPERTIES COMMON SUR $HOSTNAME."
     log "[DEBUG] ESSAYEZ D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install software-properties-common -y"
     exit 1
   fi
 else
   log "[OK] LE PAQUET SOFTWARE PROPERTIES COMMON EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
   dpkg -s software-properties-common | grep 'Version'
 fi

}