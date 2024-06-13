#!/bin/bash
set -euo pipefail

send_rcon_command() {
  local command="$1"
  $RCON_EXECUTABLE_PATH -a 127.0.0.1:"$RCON_PORT" -p "$SERVER_ADMIN_PASSWORD" "$command"
}

send_rcon_messages() {
  local messages=("${!1}")
  local delays=("${!2}")

  while [ ${#messages[@]} -gt 0 ]; do
    local message="${messages[0]}"
    local delay="${delays[0]}"
    log "[OK] ENVOI DU MESSAGE RCON: $message"
    send_rcon_command "ServerChat $message"
    for delay in $(seq "$delay" -1 1); do
      log "[INFO] TEMPS RESTANT AVANT L'ENVOI DU PROCHAIN MESSAGE RCON: $delay SECONDES"
      sleep 1
    done
    messages=("${messages[@]:1}")
    delays=("${delays[@]:1}")
  done
}

rcon_execute_commands() {
  local commands=("${!1}")
  for command in "${commands[@]}"; do
    log "[OK] EXECUTION DE LA COMMANDE RCON: $command"
    send_rcon_command "$command"
  done
}