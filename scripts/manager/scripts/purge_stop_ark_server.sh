#!/bin/bash
set -euo pipefail

purge_stop_ark_server(){

  log "[WARNING] DÉSACTIVATION DE LA PURGE PVP SUR LE SERVEUR ARK $SERVICE_NAME..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE PreventOfflinePvP DANS LE FICHIER DE CONFIGURATION DU SERVICE..."

  # Vérification de la valeur de PreventOfflinePvP dans le fichier de configuration du service
  if grep -q "PreventOfflinePvP=True" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[OK] LA PURGE EST DÉJÀ DÉSACTIVÉE SUR LE SERVEUR ARK $SERVICE_NAME."
    return 0
  else
    service_edit_command_line "PreventOfflinePvP" "True"
  fi

  # Vérification de la valeur de Restart dans le fichier de configuration du service
  if grep -q "Restart=on-failure" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[LOG] LE REDÉMARRAGE DU SERVICE $SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit_restart "on-failure"
  fi

  service_daemon_reload

  local messages=(
    "$RCON_PURGE_STOP_MSG_1"
    "$RCON_PURGE_STOP_MSG_2"
    "$RCON_PURGE_STOP_MSG_3"
    "$RCON_PURGE_STOP_MSG_4"
    "$RCON_PURGE_STOP_MSG_5"
  )
  local delays=(300 240 60 10 5)
  send_rcon_messages messages[@] delays[@]
  local commands=(
    "SaveWorld"
    "DoExit"
  )
  rcon_execute_commands commands[@]

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVICE_NAME POUR DESACTIVATION DE LA PURGE..."
  if sudo systemctl restart "$SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVICE_NAME"
  fi

}