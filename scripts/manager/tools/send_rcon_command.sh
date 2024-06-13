#!/bin/bash
set -euo pipefail

send_rcon_command() {
  local command="$1"
  $RCON_EXECUTABLE_PATH -a 127.0.0.1:"$RCON_PORT" -p "$SERVER_ADMIN_PASSWORD" "$command"
}

send_rcon_messages() {
  local messages=("${!1}")
  local delays=("${!2}")

  for i in "${!messages[@]}"; do
    send_rcon_command "$RCON_EXECUTABLE_PATH" "ServerChat ${messages[i]}"
    log "[OK] ${messages[i]}"
    sleep "${delays[i]}" 2>/dev/null || continue
  done
}

rcon_execute_commands() {
  local commands=("${!1}")
  for command in "${commands[@]}"; do
    log "[OK] EXECUTION DE LA COMMANDE RCON: $command"
    send_rcon_command "$RCON_EXECUTABLE_PATH" "$command"
  done
}