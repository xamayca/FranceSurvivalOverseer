#!/bin/bash
set -euo pipefail

service_edit_restart() {

  local restart="$1"
  log "[LOG] MODIFICATION DU SERVICE $SERVICE_NAME POUR LE REDÉMARRAGE: $restart (on-failure/no)..."

  if sudo sed -i "s|^ExecStop=.*|ExecStop=/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE_PATH|" "$ARK_SERVICE_PATH"; then
    log "[SUCCESS] MODIFICATION DE ExecStop POUR LE SERVICE $SERVICE_NAME RÉUSSIE."
  else
    log "[ERROR] ERREUR LORS DE LA MODIFICATION DE ExecStop POUR LE SERVICE $SERVICE_NAME."
    log "[DEBUG] VÉRIFIEZ LE FICHIER DE SERVICE $SERVICE_NAME À L'EMPLACEMENT: $ARK_SERVICE_PATH."
    log "[DEBUG] VÉRIFIEZ LA VALEUR DE ExecStop: /usr/bin/pkill -f $ARK_SERVER_EXECUTABLE_PATH."
  fi

  if sudo sed -i "s|Restart=.*|Restart=$restart|" "$ARK_SERVICE_PATH"; then
    log "[SUCCESS] MODIFICATION DE Restart POUR LE SERVICE $SERVICE_NAME RÉUSSIE."
  else
    log "[ERROR] ERREUR LORS DE LA MODIFICATION DE Restart POUR LE SERVICE $SERVICE_NAME."
    log "[DEBUG] VÉRIFIEZ LE FICHIER DE SERVICE $SERVICE_NAME À L'EMPLACEMENT: $ARK_SERVICE_PATH."
    log "[DEBUG] VÉRIFIEZ LA VALEUR DE Restart: $restart."
  fi

}