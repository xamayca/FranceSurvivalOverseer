#!/bin/bash
set -euo pipefail

server_installation(){

  server=(
    "install_steam_cmd"
    "install_server"
    "install_rcon_cli"
    "install_proton_ge"
    "install_command_line"
  )

  for install in "${server[@]}"; do
    log "[INFO] CHARGEMENT DU SCRIPT D'INSTALLATION POUR LE SERVEUR: $install..."
    $install
  done

}