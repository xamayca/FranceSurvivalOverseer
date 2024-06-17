#!/bin/bash
set -euo pipefail

restart() {

  log "[WARNING] REDÉMARRAGE DU SERVEUR ARK: $SERVER_SERVICE_NAME SUR $HOSTNAME EN COURS..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
  # Vérification de la valeur de Restart dans le fichier de configuration du services
  if grep -q "Restart=on-failure" "$ARK_SERVICE_PATH"; then
    log "[OK] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
    service_edit "restart" "$SERVER_SERVICE_NAME" "on-failure" "$ARK_SERVICE_PATH"
    daemon_reload
  fi

  local messages=()
  for i in {1..5}; do
    message_var="RCON_RESTART_MSG_$i"
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

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EN COURS..."
  if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVER_SERVICE_NAME"
    exit 1
  fi
}