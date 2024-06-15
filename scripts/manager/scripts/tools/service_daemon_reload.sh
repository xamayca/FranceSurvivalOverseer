#!/bin/bash
set -euo pipefail

service_daemon_reload() {

  log "[LOG] RECHARGEMENT DU SERVICE $SERVER_SERVICE_NAME..."

  if sudo systemctl daemon-reload; then
    log "[SUCCESS] RECHARGEMENT DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU RECHARGEMENT DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLER ESSAYER DE RECHARGER LE SERVICE $SERVER_SERVICE_NAME MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl daemon-reload"
  fi

}