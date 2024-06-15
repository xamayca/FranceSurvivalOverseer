#!/bin/bash
set -euo pipefail

dynamic_config_edit(){
  day="$1"
  local commands=(
    "ForceUpdateDynamicConfig"
  )

  log "[WARNING] CONFIGURATION DYNAMIQUE DU SERVEUR ARK: $SERVER_SERVICE_NAME POUR LE JOUR: $day..."

  log "[LOG] SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL..."
  if sudo rm -f "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
    log "[SUCCESS] SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL RÉUSSIE."
  else
    log "[ERROR] ERREUR LORS DE LA SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL."
    log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL EXISTE."
    return
  fi

  log "[LOG] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR RESET LES PRÉCÉDENTES MODIFICATIONS..."
  if sudo cp "$DYNAMIC_CONFIG_DIR/reset/dyn.ini" "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
    log "[SUCCESS] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE RÉUSSIE POUR RESET LES PRÉCÉDENTES MODIFICATIONS."
  else
    log "[ERROR] ERREUR LORS DE LA COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE."
    log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE POUR RESET EXISTE."
    return
  fi

  log "[LOG] EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig..."
  if rcon_execute_commands commands[@]; then
    log "[SUCCESS] EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig RÉUSSIE."
  else
    log "[ERROR] ERREUR LORS DE L'EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig."
    log "[DEBUG] VÉRIFIEZ QUE LE SERVEUR ARK: $SERVER_SERVICE_NAME EST BIEN DÉMARRÉ."
    return
  fi

  log "[LOG] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day..."
  if sudo cp "$DYNAMIC_CONFIG_DIR/$day/dyn.ini" "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
    log "[SUCCESS] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day RÉUSSIE."
  else
    log "[ERROR] ERREUR LORS DE LA COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day."
    log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day EXISTE."
    return
  fi

log "[SUCCESS] CONFIGURATION DYNAMIQUE DU SERVEUR ARK: $SERVER_SERVICE_NAME POUR LE JOUR: $day RÉUSSIE."

}

dynamic_config(){
  local day="$1"
  local dynamic_message_1="$2"
  local dynamic_message_2="$3"
  local dynamic_message_3="$4"
  local dynamic_message_4="$5"
  local dynamic_message_5="$6"
  local destroy_wild_dinos="$7"

  dynamic_config_edit "$day"

  local messages=()
  if [ -n "$dynamic_message_1" ]; then
    messages+=("$dynamic_message_1")
  fi
  if [ -n "$dynamic_message_2" ]; then
    messages+=("$dynamic_message_2")
  fi
  if [ -n "$dynamic_message_3" ]; then
    messages+=("$dynamic_message_3")
  fi
  if [ -n "$dynamic_message_4" ]; then
    messages+=("$dynamic_message_4")
  fi
  if [ -n "$dynamic_message_5" ]; then
    messages+=("$dynamic_message_5")
  fi

  local delays=(5 5 5 5 5)
  send_rcon_messages messages[@] delays[@]

  local commands=("ForceUpdateDynamicConfig")
  if [ "$destroy_wild_dinos" = "Yes" ]; then
    commands+=("DestroyWildDinos")
  fi
  rcon_execute_commands commands[@]
}