#!/bin/bash
set -euo pipefail

update(){

  log "[WARNING] VÉRIFICATION & MISE À JOUR DU SERVEUR ARK: $SERVER_SERVICE_NAME EN COURS..."

  check_server_build_id(){
    log "[LOG] VÉRIFICATION DU BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME DU FICHIER MANIFEST..."
    if server_build_id=$(grep -E "^\s+\"buildid\"\s+" "$ARK_SERVER_MANIFEST_PATH" | grep -o '[[:digit:]]*'); then
    log "[OK] LE BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME EST: $server_build_id"
    else
      log "[ERROR] ERREUR LORS DE LA RÉCUPÉRATION DU BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE RÉCUPÉRER LE BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] grep -E \"^\\s+\\\"buildid\\\"\\s+\" \"$ARK_SERVER_MANIFEST_PATH\" | grep -o '[[:digit:]]*'"
      exit 1
    fi
  }

  check_latest_build_id(){
    log "[LOG] VÉRIFICATION DU BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME DU SITE STEAM..."
    if latest_build_id=$(curl -sX GET "$ARK_LATEST_BUILD_ID" | jq -r ".data.\"$ARK_APP_ID\".depots.branches.public.buildid"); then
      log "[OK] LE DERNIER BUILD ID DU JEU ARK: SURVIVAL ASCENDED EST: $latest_build_id"
    else
      log "[ERROR] ERREUR LORS DE LA RÉCUPÉRATION DU DERNIER BUILD ID DU JEU ARK: SURVIVAL ASCENDED."
      log "[DEBUG] VEUILLEZ ESSAYER DE RÉCUPÉRER LE DERNIER BUILD ID DU JEU ARK: SURVIVAL ASCENDED AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] curl -sX GET \"$ARK_LATEST_BUILD_ID\" | jq -r \".data.\"$ARK_APP_ID\".depots.branches.public.buildid\""
      exit 1
    fi
  }

  compare_build_ids(){
    log "[LOG] COMPARAISON DES BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME ET DU SITE STEAM..."
    if [ "$server_build_id" -eq "$latest_build_id" ]; then
      log "[OK] LES BUILD ID DU SERVEUR ARK: $SERVER_SERVICE_NAME ET STEAM SONT IDENTIQUES, AUCUNE MISE À JOUR N'EST NÉCESSAIRE."
      return 0
    else
      log "[WARNING] LE SERVEUR ARK: $SERVER_SERVICE_NAME N'EST PAS À JOUR, MISE À JOUR EN COURS..."

      local messages=()
        for i in {1..5}; do
          message_var="RCON_UPDATE_MSG_$i"
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

      log "[LOG] REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME POUR MISE À JOUR DU SERVEUR ARK EN COURS..."
      if sudo systemctl restart "$SERVER_SERVICE_NAME"; then
        log "[SUCCESS] LE SERVICE $SERVER_SERVICE_NAME A ÉTÉ REDÉMARRÉ AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVER_SERVICE_NAME."
        log "[DEBUG] VEUILLEZ VÉRIFIER LE JOURNAL DU SERVICE POUR PLUS D'INFORMATIONS AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] journalctl -xe"
        exit 1
      fi
    fi
  }

  check_server_build_id
  check_latest_build_id
  compare_build_ids

}