#!/bin/bash
set -euo pipefail

install_32_bit_arch(){

  log "[LOG] VÉRIFICATION DE L'ACTIVATION DE L'ARCHITECTURE 32 BITS SUR LE SYSTÈME..."

  # Vérifier si l'architecture 32 bits est activée
  if dpkg --print-foreign-architectures | grep -q "i386"; then
    log "[OK] L'ARCHITECTURE 32 BITS EST DÉJÀ ACTIVÉE SUR CE SYSTÈME."
    dpkg --print-foreign-architectures | grep "i386"
  else
    log "[WARNING] L'ARCHITECTURE 32 BITS N'EST PAS ACTIVÉE, ACTIVATION EN COURS..."
    # Activer l'architecture 32 bits
    if dpkg --add-architecture i386; then
      log "[SUCCESS] L'ARCHITECTURE 32 BITS A ÉTÉ ACTIVÉE AVEC SUCCÈS."
      dpkg --print-foreign-architectures | grep "i386"
    else
      log "[ERROR] ERREUR LORS DE L'ACTIVATION DE L'ARCHITECTURE 32 BITS."
      log "[DEBUG] ESSAYEZ D'ACTIVER L'ARCHITECTURE 32 BITS MANUELLEMENT AVEC LA COMMANDE: sudo dpkg --add-architecture i386"
      exit 1
    fi
  fi
}
