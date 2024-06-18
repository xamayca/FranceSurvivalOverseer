#!/bin/bash
set -euo pipefail

install_32_bit_arch(){

  log "[LOG] VÉRIFICATION & ACTIVATION DE L'ARCHITECTURE 32 BITS EN COURS SUR $HOSTNAME..."
  if dpkg --print-foreign-architectures | grep -q "i386"; then
    log "[OK] L'ARCHITECTURE 32 BITS EST DÉJÀ ACTIVÉE SUR $HOSTNAME."
    dpkg --print-foreign-architectures | grep "i386"
  else
    log "[WARNING] L'ARCHITECTURE 32 BITS N'EST PAS ACTIVÉE SUR $HOSTNAME, ACTIVATION EN COURS."
    if dpkg --add-architecture i386; then
      log "[SUCCESS] L'ARCHITECTURE 32 BITS A ÉTÉ ACTIVÉE AVEC SUCCÈS SUR $HOSTNAME."
      dpkg --print-foreign-architectures | grep "i386"
    else
      log "[ERROR] ERREUR LORS DE L'ACTIVATION DE L'ARCHITECTURE 32 BITS SUR $HOSTNAME."
      log "[DEBUG] ESSAYEZ D'ACTIVER L'ARCHITECTURE 32 BITS MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] dpkg --add-architecture i386"
      exit 1
    fi
  fi

}