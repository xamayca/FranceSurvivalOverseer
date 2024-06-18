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

  daemon_reload

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

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME POUR ${action^^} DE LA PURGE PVP..."
  if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVER_SERVICE_NAME"
    exit 1
  fi
}
