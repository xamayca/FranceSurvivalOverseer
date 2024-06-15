#!/bin/bash
set -euo pipefail

purge_start_ark_server(){

  log "[WARNING] ACTIVATION DE LA PURGE PVP SUR LE SERVEUR ARK $SERVER_SERVICE_NAME..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE PreventOfflinePvP DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
  # Vérification de la valeur de PreventOfflinePvP dans le fichier de configuration du service
  if grep "PreventOfflinePvP=False" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[OK] LA PURGE EST DÉJÀ ACTIVÉE SUR LE SERVEUR ARK $SERVER_SERVICE_NAME."
    return 0
  else
    service_edit_command_line "PreventOfflinePvP" "False"
  fi

  # Vérification de la valeur de Restart dans le fichier de configuration du service
  if grep "Restart=on-failure" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[LOG] LE REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit_restart "on-failure"
  fi

  service_daemon_reload

  local messages=(
    "$RCON_PURGE_START_MSG_1"
    "$RCON_PURGE_START_MSG_2"
    "$RCON_PURGE_START_MSG_3"
    "$RCON_PURGE_START_MSG_4"
    "$RCON_PURGE_START_MSG_5"
  )

  local delays=(300 240 60 10 5)
  send_rcon_messages messages[@] delays[@]
  local commands=(
    "SaveWorld"
    "DoExit"
  )
  rcon_execute_commands commands[@]

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME POUR ACTIVATION DE LA PURGE..."
  if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVER_SERVICE_NAME"
  fi

}