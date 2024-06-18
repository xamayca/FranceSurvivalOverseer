#!/bin/bash
set -euo pipefail

stop() {

    log "[WARNING] L'ARRÊT DU SERVEUR ARK: $SERVER_SERVICE_NAME SUR $HOSTNAME EST EN COURS..."
    log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
    # Vérification de la valeur de Restart dans le fichier de configuration du services
    if grep -q "Restart=no" "$ARK_SERVICE_PATH"; then
      log "[OK] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: no."
    else
      log "[WARNING] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME N'EST PAS CONFIGURÉ SUR: no."
      service_edit "exec_stop" "$SERVER_SERVICE_NAME" "/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE" "$ARK_SERVICE_PATH"
      service_edit "restart" "$SERVER_SERVICE_NAME" "no" "$ARK_SERVICE_PATH"
      daemon_reload
    fi

  local messages=()
    for i in {1..5}; do
      message_var="RCON_STOP_MSG_$i"
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

  log "[LOG] ARRÊT DU SERVICE $SERVER_SERVICE_NAME SUR $HOSTNAME EN COURS..."
  if sudo systemctl stop "$SERVER_SERVICE_NAME"; then
    log "[SUCCESS] LE SERVICE $SERVER_SERVICE_NAME A ÉTÉ ARRÊTÉ AVEC SUCCÈS."
  else
    log "[ERROR] ERREUR LORS DE L'ARRÊT DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ VÉRIFIER LE JOURNAL DU SERVICE POUR PLUS D'INFORMATIONS: journalctl -xe --no-pager -u $SERVER_SERVICE_NAME"
    exit 1
  fi
}