#!/bin/bash
set -euo pipefail

service_edit_command_line() {
    local params="$1"
    local value="$2"

    log "[LOG] MODIFICATION DU SERVICE $SERVER_SERVICE_NAME AVEC LES PARAMÈTRES: $params=$value..."
    log "[INFO] SERVICE AVANT MODIFICATION..."
    grep "$params" "$ARK_SERVICE_PATH"

    if sudo sed -i "s|\($params=\)[^?]*|\1$value|" "$ARK_SERVICE_PATH"; then
        log "[SUCCESS] MODIFICATION DE $params=$value POUR LE SERVICE $SERVER_SERVICE_NAME RÉUSSIE."
        log "[INFO] SERVICE APRÈS MODIFICATION..."
        grep "$params" "$ARK_SERVICE_PATH"
    else
        log "[ERROR] ERREUR LORS DE LA MODIFICATION DE $params=$value POUR LE SERVICE $SERVER_SERVICE_NAME."
        log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE SERVICE $ARK_SERVICE_PATH."
    fi
}