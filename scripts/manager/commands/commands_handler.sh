#!/bin/bash
set -euo pipefail

check_server_build_id(){
  log "[LOG] VÉRIFICATION DU BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME DU FICHIER MANIFEST..."
  if server_build_id=$(grep -E "^\s+\"buildid\"\s+" "$ARK_SERVER_MANIFEST_PATH" | grep -o '[[:digit:]]*'); then
  log "[OK] LE BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME EST: $server_build_id"
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA RÉCUPÉRATION DU BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE RÉCUPÉRER LE BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] grep -E \"^\\s+\\\"buildid\\\"\\s+\" \"$ARK_SERVER_MANIFEST_PATH\" | grep -o '[[:digit:]]*'"
    exit 1
  fi
}

check_latest_build_id(){
  log "[LOG] VÉRIFICATION DU BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME DU SITE STEAM..."
  if latest_build_id=$(curl -sX GET "$ARK_LATEST_BUILD_ID" | jq -r ".data.\"$ARK_APP_ID\".depots.branches.public.buildid"); then
    log "[OK] LE DERNIER BUILD ID DU JEU $ARK_APP_ID EST: $latest_build_id"
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA RÉCUPÉRATION DU DERNIER BUILD ID DU JEU $ARK_APP_ID."
    log "[DEBUG] VEUILLEZ ESSAYER DE RÉCUPÉRER LE DERNIER BUILD ID DU JEU $ARK_APP_ID AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] curl -sX GET \"$ARK_LATEST_BUILD_ID\" | jq -r \".data.\"$ARK_APP_ID\".depots.branches.public.buildid\""
    exit 1
  fi
}

compare_build_ids(){
  log "[LOG] VÉRIFICATION DE LA CONCORDANCE DES BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME ET STEAM..."
  if [ "$server_build_id" -eq "$latest_build_id" ]; then
    log "[OK] LES BUILD ID DU SERVEUR: $SERVER_SERVICE_NAME ET STEAM SONT IDENTIQUES, AUCUNE MISE À JOUR N'EST NÉCESSAIRE."
    return 0
  else
    log "[WARNING] LE SERVEUR: $SERVER_SERVICE_NAME N'EST PAS À JOUR, MISE À JOUR EN COURS."
    rcon_send_messages_and_execute_commands "RCON_UPDATE"
    service_handler "restart" "$SERVER_SERVICE_NAME"
  fi
}

commands_handler() {
  local action=$1
  local restart_value=$2
  local message_prefix=$3


  if [ "$action" = "update" ]; then
    log "[WARNING] VÉRIFICATION & MISE À JOUR DU SERVEUR: $SERVER_SERVICE_NAME EN COURS..."
    check_server_build_id
    check_latest_build_id
    compare_build_ids
  else
    log "[WARNING] LA COMMANDE $action DU SERVICE $SERVER_SERVICE_NAME A ÉTÉ REÇUE."
    log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."

    if grep -q "Restart=$restart_value" "$ARK_SERVICE_PATH"; then
      log "[OK] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: $restart_value."
    else
      log "[WARNING] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME N'EST PAS CONFIGURÉ SUR: $restart_value."
      service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
      service_edit "restart" "$SERVER_SERVICE_NAME" "$restart_value" "$ARK_SERVICE_PATH"
      daemon_reload
    fi

    rcon_send_messages_and_execute_commands "$message_prefix"

    service_handler "$action" "$SERVER_SERVICE_NAME"

  fi
}

