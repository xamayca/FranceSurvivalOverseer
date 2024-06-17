#!/bin/bash
set -euo pipefail

purge_start(){

  log "[WARNING] ACTIVATION DE LA PURGE PVP SUR LE SERVEUR ARK $SERVER_SERVICE_NAME SUR $HOSTNAME EN COURS..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE PreventOfflinePvP DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
  # Vérification de la valeur de PreventOfflinePvP dans le fichier de configuration du services
  if grep "PreventOfflinePvP=False" "$ARK_SERVICE_PATH"; then
    log "[OK] LA PURGE EST DÉJÀ ACTIVÉE SUR LE SERVEUR ARK $SERVER_SERVICE_NAME."
    return 0
  else
    update_command_line "edit_params" "PreventOfflinePvP" "False"
  fi

  # Vérification de la valeur de Restart dans le fichier de configuration du services
  if grep "Restart=on-failure" "$ARK_SERVICE_PATH"; then
    log "[LOG] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
    service_edit "restart" "$SERVER_SERVICE_NAME" "on-failure" "$ARK_SERVICE_PATH"
  fi

  daemon_reload

  local messages=()
  for i in {1..5}; do
    message_var="RCON_PURGE_START_MSG_$i"
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

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME POUR ACTIVATION DE LA PURGE PVP..."
  if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVER_SERVICE_NAME"
    exit 1
  fi

}