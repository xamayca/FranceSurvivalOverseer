#!/bin/bash
set -euo pipefail

stop_ark_server() {
    log "[WARNING] ARRÊT DU SERVEUR ARK: $SERVICE_NAME EN COURS..."
    log "[LOG] VÉRIFICATION DE LA VALEUR DE Restart DANS LE FICHIER DE CONFIGURATION DU SERVICE..."

    # Vérification de la valeur de Restart dans le fichier de configuration du service
    if grep -q "Restart=no" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
      log "[OK] LE REDÉMARRAGE DU SERVICE $SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: no."
    else
      service_edit_restart "no"
      service_daemon_reload
    fi

  local messages=(
    "$RCON_STOP_MSG_1"
    "$RCON_STOP_MSG_2"
    "$RCON_STOP_MSG_3"
    "$RCON_STOP_MSG_4"
    "$RCON_STOP_MSG_5"
  )

  local delays=(300 240 60 10 5)
  send_rcon_messages messages[@] delays[@]
  local commands=(
    "SaveWorld"
    "DoExit"
  )
  rcon_execute_commands commands[@]

  log "[LOG] ARRÊT DU SERVICE $SERVICE_NAME EN COURS..."
  if sudo systemctl stop "$SERVICE_NAME"; then
    log "[SUCCESS] ARRÊT DU SERVICE $SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DE L'ARRÊT DU SERVICE $SERVICE_NAME."
    log "[DEBUG] VEUILLEZ VÉRIFIER LE JOURNAL DU SERVICE POUR PLUS D'INFORMATIONS: journalctl -xe --no-pager -u $SERVICE_NAME"
  fi
}