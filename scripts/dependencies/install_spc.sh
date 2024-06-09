#!/bin/bash
set -euo pipefail

install_spc(){

 log "[LOG] VÉRIFICATION DE L'INSTALLATION DE SOFTWARE PROPERTIES COMMON..."

 if ! dpkg -l software-properties-common &> /dev/null; then
   log "[WARNING] LE PAQUET SOFTWARE PROPERTIES COMMON N'EST PAS INSTALLÉ, INSTALLATION EN COURS..."
   if sudo apt-get install software-properties-common -y; then
     log "[SUCCESS] LE PAQUET SOFTWARE PROPERTIES COMMON A ÉTÉ INSTALLÉ AVEC SUCCÈS."
   else
     log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET SOFTWARE PROPERTIES COMMON."
     exit 1
   fi
 else
   log "[OK] LE PAQUET SOFTWARE PROPERTIES COMMON EST DÉJÀ INSTALLÉ SUR LE SYSTÈME."
 fi

}