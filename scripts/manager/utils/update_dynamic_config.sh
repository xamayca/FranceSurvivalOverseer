#!/bin/bash
set -euo pipefail

update_dynamic_config(){

  day="$1"
  local commands=(
    "ForceUpdateDynamicConfig"
  )

  remove_active_dynamic_config(){
      log "[LOG] SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL POUR LE JOUR: $day EN COURS..."
      if sudo rm -f "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
        log "[SUCCESS] SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL RÉUSSIE."
      else
        log "[ERROR] ERREUR LORS DE LA SUPPRESSION DU FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL POUR LE JOUR: $day."
        log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE ACTUEL EXISTE DANS LE DOSSIER: $DYNAMIC_CONFIG_DIR/current."
        return
      fi
    }

  reset_dynamic_config(){
    log "[LOG] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR RESET LES PRÉCÉDENTES MODIFICATIONS EN COURS..."
    if sudo cp "$DYNAMIC_CONFIG_DIR/reset/dyn.ini" "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
      log "[SUCCESS] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE RÉUSSIE POUR RESET LES PRÉCÉDENTES MODIFICATIONS."
    else
      log "[ERROR] ERREUR LORS DE LA COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR RESET LES PRÉCÉDENTES MODIFICATIONS."
      log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE POUR RESET EXISTE DANS LE DOSSIER: $DYNAMIC_CONFIG_DIR/reset."
      return
    fi

    log "[LOG] EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig POUR RESET LES PRÉCÉDENTES MODIFICATIONS EN COURS..."
    if rcon_execute_commands commands[@]; then
      log "[SUCCESS] EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig RÉUSSIE SUR LE SERVEUR ARK: $SERVER_SERVICE_NAME."
    else
      log "[ERROR] ERREUR LORS DE L'EXÉCUTION DE LA COMMANDE RCON: ForceUpdateDynamicConfig SUR LE SERVEUR ARK: $SERVER_SERVICE_NAME."
      log "[DEBUG] VÉRIFIEZ QUE LE SERVEUR ARK: $SERVER_SERVICE_NAME EST BIEN DÉMARRÉ."
      return
    fi
  }

  copy_dynamic_config(){
    log "[LOG] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day..."
    if sudo cp "$DYNAMIC_CONFIG_DIR/$day/dyn.ini" "$DYNAMIC_CONFIG_DIR/current/dyn.ini"; then
      log "[SUCCESS] COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day RÉUSSIE."
    else
      log "[ERROR] ERREUR LORS DE LA COPIE DU FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day."
      log "[DEBUG] VÉRIFIEZ QUE LE FICHIER DE CONFIGURATION DYNAMIQUE POUR LE JOUR: $day EXISTE."
      return
    fi
  }

  compare_dynamic_config(){
    local day="$1"
    log "[LOG] COMPARAISON DES FICHIERS DE CONFIGURATION DYNAMIQUE ACTUEL ET DU JOUR: $day SUR LE SERVEUR ARK: $SERVER_SERVICE_NAME EN COURS..."
    if sudo diff -q "$DYNAMIC_CONFIG_DIR/current/dyn.ini" "$DYNAMIC_CONFIG_DIR/$day/dyn.ini"; then
      log "[OK] LES FICHIERS DE CONFIGURATION DYNAMIQUE ACTUEL ET DU JOUR: $day SONT IDENTIQUES, AUCUNE MODIFICATION N'EST NÉCESSAIRE."
    else
      log "[WARNING] LES FICHIERS DE CONFIGURATION DYNAMIQUE ACTUEL ET DU JOUR: $day SONT DIFFÉRENTS, DES MODIFICATIONS SONT NÉCESSAIRES."
      remove_active_dynamic_config
      reset_dynamic_config
      copy_dynamic_config
    fi
  }

  compare_dynamic_config "$day"

}

dynamic_config(){
  local day="$1"
  local destroy_wild_dinos="$7"

  update_dynamic_config "$day"

  local messages=()
  for i in {1..5}; do
    message_var="DYNAMIC_${day^^}_MSG_$i"
    message="${!message_var}"
    if [ -n "$message" ]; then
      messages+=("$message")
    fi
  done

  local delays=(5 5 5 5 5)

  send_rcon_messages messages[@] delays[@]

  local commands=("ForceUpdateDynamicConfig")
  if [ "$destroy_wild_dinos" = "Yes" ]; then
    commands+=("DestroyWildDinos")
  fi
  rcon_execute_commands commands[@]
}
