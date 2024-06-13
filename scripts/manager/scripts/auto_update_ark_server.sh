#!/bin/bash
set -euo pipefail

auto_update_ark_server(){

  log "[WARNING] VÉRIFICATION DE LA MISE À JOUR DU SERVEUR ARK: $SERVICE_NAME..."

  local manifest_acf="$ARK_SERVER_PATH/steamapps/appmanifest_$ARK_APP_ID.acf"
  local latest_build_id="https://api.steamcmd.net/v1/info/$ARK_APP_ID"

  log "[LOG] VERIFICATION DU BUILD ID DU SERVEUR ARK: $SERVICE_NAME DU FICHIER MANIFEST..."
  if server_build_id=$(grep -E "^\s+\"buildid\"\s+" "$manifest_acf" | grep -o '[[:digit:]]*'); then
  log "[OK] BUILD ID DU JEU ARK: SURVIVAL ASCENDED SUR LE SERVEUR: $server_build_id"
  else
    log "[ERROR] ERREUR LORS DE LA RÉCUPÉRATION DU BUILD ID DU SERVEUR ARK: $SERVICE_NAME."
  fi

  log "[LOG] VERIFICATION DU BUILD ID DU SERVEUR ARK: $SERVICE_NAME DU SITE STEAM..."
  if latest_build_id=$(curl -sX GET "https://api.steamcmd.net/v1/info/$ARK_APP_ID" | jq -r ".data.\"$ARK_APP_ID\".depots.branches.public.buildid"); then
    log "[OK] DERNIER BUILD ID DU JEU ARK: SURVIVAL ASCENDED: $latest_build_id"
  else
    log "[ERROR] ERREUR LORS DE LA RÉCUPÉRATION DU BUILD ID DU SERVEUR ARK: $SERVICE_NAME."
  fi

  log "[LOG] COMPARAIOSN DES BUILD ID DU SERVEUR ARK: $SERVICE_NAME ET DU SITE STEAM..."
  if [ "$server_build_id" -eq "$latest_build_id" ]; then
    log "[SUCCESS] LE SERVEUR ARK: $SERVICE_NAME EST À JOUR."
    return 0
  else
    log "[WARNING] LE SERVEUR ARK: $SERVICE_NAME N'EST PAS À JOUR."

    local messages=(
      "$RCON_AUTO_UPDATE_MSG_1"
      "$RCON_AUTO_UPDATE_MSG_2"
      "$RCON_AUTO_UPDATE_MSG_3"
      "$RCON_AUTO_UPDATE_MSG_4"
      "$RCON_AUTO_UPDATE_MSG_5"
    )

    local delays=(300 240 60 10 5)
    send_rcon_messages messages[@] delays[@]
    local commands=(
      "SaveWorld"
      "DoExit"
    )
    rcon_execute_commands commands[@]

    log "[LOG] REDÉMARRAGE DU SERVICE $SERVICE_NAME POUR MISE À JOUR..."
    if sudo systemctl restart "$SERVICE_NAME"; then
      log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVICE_NAME RÉUSSI."
    else
      log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVICE_NAME."
      log "[DEBUG] VÉRIFIEZ LE JOURNAL DU SERVICE POUR PLUS D'INFORMATIONS: journalctl -xe"
    fi
  fi
}