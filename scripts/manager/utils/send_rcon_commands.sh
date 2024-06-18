#!/bin/bash
set -euo pipefail

rcon_commands() {
  local command="$1"
  $RCON_EXECUTABLE_PATH -a 127.0.0.1:"$RCON_PORT" -p "$SERVER_ADMIN_PASSWORD" "$command"
}

rcon_execute_commands() {
  local commands=("${!1}")
  for command in "${commands[@]}"; do
    log "[INFO] EXECUTION DE LA COMMANDE RCON: $command"
    rcon_commands "$command"
  done
}

rcon_send_messages() {
  local messages=("${!1}")
  local delays=("${!2}")

  while [ ${#messages[@]} -gt 0 ]; do
    local message="${messages[0]}"
    local delay="${delays[0]}"
    log "[INFO] ENVOI DU MESSAGE RCON: $message"
    rcon_commands "ServerChat $message"
    sleep "$delay"
    #for delay in $(seq "$delay" -1 1); do
    #  log "[INFO] TEMPS RESTANT AVANT L'ENVOI DU PROCHAIN MESSAGE RCON: $delay SECONDES"
    #  sleep 1
    #done
    messages=("${messages[@]:1}")
    delays=("${delays[@]:1}")
  done
}

rcon_send_messages_and_execute_commands() {
  local message_prefix=$1

  local messages=()
  for i in {1..5}; do
    message_var="${message_prefix}_MSG_$i"
    if [ -n "${!message_var}" ]; then
      messages+=("${!message_var}")
    fi
  done
  local delays=(300 240 60 10 5)
  rcon_send_messages messages[@] delays[@]
  local commands=("SaveWorld" "DoExit")
  rcon_execute_commands commands[@]
}