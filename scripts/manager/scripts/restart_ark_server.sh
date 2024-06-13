#!/bin/bash
set -euo pipefail

restart_ark_server() {

  log "[WARNING] REDÉMARRAGE DU SERVEUR ARK: $SERVICE_NAME EN COURS..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."

  # Vérification de la valeur de Restart dans le fichier de configuration du service
  if grep -q "Restart=on-failure" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[OK] LE REDÉMARRAGE DU SERVICE $SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit_restart "on-failure"
    service_daemon_reload
  fi

  # redemarrage journalier
  local messages=(
    "$RCON_MAINTENANCE_MSG_1"
    "$RCON_MAINTENANCE_MSG_2"
    "$RCON_MAINTENANCE_MSG_3"
    "$RCON_MAINTENANCE_MSG_4"
    "$RCON_MAINTENANCE_MSG_5"
  )

  local delays=(300 240 60 10 5)
  send_rcon_messages messages[@] delays[@]
  local commands=(
    "SaveWorld"
    "DoExit"
  )
  rcon_execute_commands commands[@]

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVICE_NAME EN COURS..."
  if sudo systemctl restart "$SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVICE_NAME."
    log "[DEBUG] VÉRIFIEZ LE JOURNAL DU SERVICE POUR PLUS D'INFORMATIONS: journalctl -xe"
  fi
}