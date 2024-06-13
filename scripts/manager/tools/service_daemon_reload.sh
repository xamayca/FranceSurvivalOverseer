#!/bin/bash
set -euo pipefail

service_daemon_reload() {

  log "[LOG] RECHARGEMENT DU SERVICE $SERVICE_NAME..."

  if sudo systemctl daemon-reload; then
    log "[SUCCESS] RECHARGEMENT DU SERVICE $SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU RECHARGEMENT DU SERVICE $SERVICE_NAME."
    log "[DEBUG] VEUILLER ESSAYER DE RECHARGER LE SERVICE $SERVICE_NAME MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl daemon-reload"
  fi

}