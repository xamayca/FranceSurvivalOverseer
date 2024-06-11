#!/bin/bash
set -euo pipefail

server_command_line() {

  log "[WARNING] GÉNÉRATION DE LA LIGNE DE COMMANDE POUR LE LANCEMENT DU SERVEUR ARK: $SERVICE_NAME"

  local QUERY_PARAMS=""
  local FLAG_PARAMS=""

  # Tableau de paramètres avec ? + valeur
  local query_params=(
    "Map=$MAP_NAME"
    "SessionName=$SERVER_NAME"
    "Port=$GAME_PORT"
    "ServerPassword=$SERVER_PASSWORD"
    "ServerAdminPassword=$SERVER_ADMIN_PASSWORD"
    "RCONEnabled=$RCON_ENABLED"
    "RCONPort=$RCON_PORT"
    "PreventSpawnAnimations=$PREVENT_SPAWN_ANIMATION"
    "PreventDownloadSurvivors=$PREVENT_DOWNLOAD_SURVIVORS"
    "PreventDownloadItems=$PREVENT_DOWNLOAD_ITEMS"
    "PreventDownloadDinos=$PREVENT_DOWNLOAD_DINOS"
    "NoTributeDownloads=$NO_TRIBUTE_DOWNLOADS"
  )

  # Tableau de paramètres avec - + valeur
  local flag_params=(
    "ClusterDirOverride=$CLUSTER_DIR_OVERRIDE"
    "clusterid=$CLUSTER_ID"
    "WinLiveMaxPlayers=$WIN_LIVE_MAX_PLAYERS"
  )

  # Tableau de paramètres - (Yes) ou vide (No)
  local simple_flag_params=(
    "NoTransferFromFiltering=$NO_TRANSFER_FROM_FILTERING"
  )

  # Ajout des paramètres avec ? + valeur
  for param in "${query_params[@]}"; do
    query_param="${param%%=*}"
    query_value="${param#*=}"
    if [ "$query_param" == "Map" ]; then
      QUERY_PARAMS+="$query_value"
    else
      QUERY_PARAMS+="?$query_param=$query_value"
    fi
  done

  # Ajout des paramètres avec - + valeur
  for param in "${flag_params[@]}"; do
    flag_param="${param%%=*}"
    flag_value="${param#*=}"
    FLAG_PARAMS+=" -${flag_param}=${flag_value}"
  done

  # Ajout des paramètres - (Yes) ou vide (No)
  for param in "${simple_flag_params[@]}"; do
    simple_flag_param="${param%%=*}"
    simple_flag_value="${param#*=}"
    if [ "$simple_flag_value" == "Yes" ]; then
      FLAG_PARAMS+=" -${simple_flag_param}"
    fi
  done

  log "[SUCCESS] LIGNE DE COMMANDE GÉNÉRÉE POUR LE LANCEMENT DU SERVEUR ARK: $SERVICE_NAME"
  log "[LOG] $PROTON_GE_EXECUTABLE_PATH run $ARK_SERVER_EXECUTABLE $QUERY_PARAMS $FLAG_PARAMS"
  printf "%s %s" "$QUERY_PARAMS" "$FLAG_PARAMS"

}