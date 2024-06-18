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

    local messages=()
      for i in {1..5}; do
        message_var="RCON_UPDATE_MSG_$i"
        if [ -n "${!message_var}" ]; then
          messages+=("${!message_var}")
        fi
    done
    local delays=(300 240 60 10 5)
    send_rcon_messages messages[@] delays[@]
    local commands=(
      "SaveWorld"
      "DoExit"
    )
    rcon_execute_commands commands[@]

    log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME POUR MISE À JOUR DU SERVEUR $SERVER_SERVICE_NAME..."
    if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
      log "[SUCCESS] LE SERVICE $SERVER_SERVICE_NAME A ÉTÉ REDÉMARRÉ AVEC SUCCÈS."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo systemctl restart $SERVER_SERVICE_NAME"
      exit 1
    fi
  fi
}

handle_action() {
  local action=$1
  local restart_value=$2
  local message_prefix=$3


  if [ "$action" = "update" ]; then
    log "[WARNING] VÉRIFICATION & MISE À JOUR DU SERVEUR: $SERVER_SERVICE_NAME EN COURS..."
    check_server_build_id
    check_latest_build_id
    compare_build_ids
  else
    log "[WARNING] $action DU SERVEUR: $SERVER_SERVICE_NAME SUR $HOSTNAME EN COURS..."
    log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."

    if grep -q "Restart=$restart_value" "$ARK_SERVICE_PATH"; then
      log "[OK] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: $restart_value."
    else
      log "[WARNING] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME N'EST PAS CONFIGURÉ SUR: $restart_value."
      service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
      service_edit "restart" "$SERVER_SERVICE_NAME" "$restart_value" "$ARK_SERVICE_PATH"
      daemon_reload
    fi

    local messages=()
    for i in {1..5}; do
      message_var="${message_prefix}_MSG_$i"
      if [ -n "${!message_var}" ]; then
        messages+=("${!message_var}")
      fi
    done
    local delays=(300 240 60 10 5)
    send_rcon_messages messages[@] delays[@]
    local commands=("SaveWorld" "DoExit")
    rcon_execute_commands commands[@]

    log "[LOG] $action DU SERVICE $SERVER_SERVICE_NAME EN COURS..."
    if sudo systemctl "$action" "$SERVER_SERVICE_NAME"; then
      log "[SUCCESS] $action DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
    else
      log "[ERROR] ERREUR LORS DU $action DU SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE $action LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo systemctl $action $SERVER_SERVICE_NAME"
      exit 1
    fi
  fi
}

