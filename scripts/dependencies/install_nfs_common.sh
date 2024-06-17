#!/bin/bash
set -euo pipefail

install_nfs_common(){

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET NFS-COMMON SUR $HOSTNAME..."
  if dpkg -s nfs-common &> /dev/null; then
    log "[OK] LE PAQUET NFS-COMMON EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
  else
    log "[WARNING] LE PAQUET NFS-COMMON N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
    if sudo apt-get install nfs-common -y; then
      log "[SUCCESS] LE PAQUET NFS-COMMON A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET NFS-COMMON."
      log "[DEBUG] VEUILLEZ INSTALLER LE PAQUET NFS-COMMON À L'AIDE DE LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo apt-get install nfs-common -y"
      exit 1
    fi
  fi

}