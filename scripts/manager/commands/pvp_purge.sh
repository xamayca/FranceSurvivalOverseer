pvp_purge() {
  local action=$1
  local pvp_value=$2
  local message_prefix=$3

  log "[WARNING] ${action^^} DE LA PURGE PVP SUR LE SERVEUR: $SERVER_SERVICE_NAME SUR $HOSTNAME EN COURS..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE PreventOfflinePvP DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
  
  if grep "PreventOfflinePvP=$pvp_value" "$ARK_SERVICE_PATH"; then
    log "[OK] LA PURGE EST DÉJÀ REGLÉE SUR ${action^^} SUR LE SERVEUR: $SERVER_SERVICE_NAME."
    return 0
  else
    log "[WARNING] LA PURGE N'EST PAS REGLÉE SUR ${action^^} SUR LE SERVEUR: $SERVER_SERVICE_NAME."
    update_command_line "edit_params" "PreventOfflinePvP" "$pvp_value"
  fi

  if grep "Restart=on-failure" "$ARK_SERVICE_PATH"; then
    log "[LOG] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    log "[WARNING] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME N'EST PAS CONFIGURÉ SUR: on-failure."
    service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
    service_edit "restart" "$SERVER_SERVICE_NAME" "on-failure" "$ARK_SERVICE_PATH"
  fi

  services_handler "reload" "$SERVER_SERVICE_NAME"

  rcon_send_messages_and_execute_commands "$message_prefix"

  services_handler "restart" "$SERVER_SERVICE_NAME"
}
