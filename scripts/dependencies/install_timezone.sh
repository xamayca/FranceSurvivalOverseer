#!/bin/bash
set -euo pipefail

install_timezone(){

  local server_timezone=$(timedatectl show --property=Timezone --value)

  log "[LOG] VÉRIFICATION DU FUSEAU HORAIRE DU SYSTÈME..."
  if [[ "$server_timezone" != "$SYSTEM_TIMEZONE" ]];then
    log "[WARNING] LE FUSEAU HORAIRE DU SYSTÈME N'EST PAS CONFIGURÉ CORRECTEMENT, CONFIGURATION EN COURS..."
    if sudo timedatectl set-timezone "$SYSTEM_TIMEZONE"; then
      log "[SUCCESS] LE FUSEAU HORAIRE DU SYSTÈME A ÉTÉ CONFIGURÉ AVEC SUCCÈS."
      timedatectl show --property=Timezone --value
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CONFIGURATION DU FUSEAU HORAIRE DU SYSTÈME."
      exit 1
    fi
  else
    log "[OK] LE FUSEAU HORAIRE DU SYSTÈME EST DÉJÀ CONFIGURÉ CORRECTEMENT."
  fi

}