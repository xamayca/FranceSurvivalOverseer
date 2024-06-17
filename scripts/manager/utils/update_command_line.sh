#!/bin/bash
set -euo pipefail

update_command_line() {
  local function_name="$1"
  local params="$2"
  local value="$3"

  if [ "$function_name" == "add_query_params" ]; then
    add_query_params "$params" "$value"
  elif [ "$function_name" == "add_flag_params" ]; then
    add_flag_params "$params" "$value"
  elif [ "$function_name" == "add_simple_flag_params" ]; then
    add_simple_flag_params "$params"
  elif [ "$function_name" == "edit_params" ]; then
    edit_params "$params" "$value"
  else
    log "[ERROR] L'ARGUMENT $function_name N'EST PAS VALIDE POUR LA FONCTION edit_command_line."
    log "[DEBUG] VEUILLEZ FOURNIR UNE DES VALEURS SUIVANTES:"
    log "[DEBUG] add_query_params, add_flag_params, edit_params"
    exit 1
  fi
}

add_query_params() {
  local params="$1"
  local value="$2"

  # Ajout des paramètres de requête au service "? + valeur" avant ServerAdminPassword
  log "[LOG] VÉRIFICATION & AJOUT DES PARAMÈTRES DE REQUÊTE AU SERVICE $SERVER_SERVICE_NAME..."
  if grep -q "$params=$value" "$ARK_SERVICE_PATH"; then
    log "[OK] LE PARAMÈTRE DE REQUÊTE $params=$value EXISTE DÉJÀ DANS LE SERVICE $SERVER_SERVICE_NAME."
  else
    log "[WARNING] LE PARAMÈTRE DE REQUÊTE $params=$value N'EXISTE PAS DANS LE SERVICE $SERVER_SERVICE_NAME."
    log "[INFO] AJOUT DU PARAMÈTRE DE REQUÊTE $params=$value AU SERVICE $SERVER_SERVICE_NAME..."
    if sudo sed -i "/ServerAdminPassword/a ?$params=$value" "$ARK_SERVICE_PATH"; then
      log "[SUCCESS] LE PARAMÈTRE DE REQUÊTE $params=$value A ÉTÉ AJOUTÉ AVEC SUCCÈS AU SERVICE $SERVER_SERVICE_NAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DU PARAMÈTRE DE REQUÊTE $params=$value AU SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE SERVICE $ARK_SERVICE_PATH."
      exit 1
    fi
  fi
}

add_flag_params() {
  local params="$1"
  local value="$2"

  # Ajout des paramètres de drapeau au service "- + valeur" a la fin de la ligne ExecStart
  log "[LOG] VÉRIFICATION & AJOUT DES PARAMÈTRES DE DRAPEAU AU SERVICE $SERVER_SERVICE_NAME..."
  if grep -q "$params=$value" "$ARK_SERVICE_PATH"; then
    log "[OK] LE PARAMÈTRE DE DRAPEAU $params=$value EXISTE DÉJÀ DANS LE SERVICE $SERVER_SERVICE_NAME."
  else
    log "[WARNING] LE PARAMÈTRE DE DRAPEAU $params=$value N'EXISTE PAS DANS LE SERVICE $SERVER_SERVICE_NAME."
    log "[INFO] AJOUT DU PARAMÈTRE DE DRAPEAU $params=$value AU SERVICE $SERVER_SERVICE_NAME..."
    if sudo sed -i "/ExecStart/s|$| -$params=$value|" "$ARK_SERVICE_PATH"; then
      log "[SUCCESS] LE PARAMÈTRE DE DRAPEAU $params=$value A ÉTÉ AJOUTÉ AVEC SUCCÈS AU SERVICE $SERVER_SERVICE_NAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DU PARAMÈTRE DE DRAPEAU $params=$value AU SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE SERVICE $ARK_SERVICE_PATH."
      exit 1
    fi
  fi
}

add_simple_flag_params() {
  local params="$1"

  # Ajout des paramètres de drapeau au service "-" a la fin de la ligne ExecStart
  log "[LOG] VÉRIFICATION & AJOUT DES PARAMÈTRES DE DRAPEAU AU SERVICE $SERVER_SERVICE_NAME..."
  if grep -q "$params" "$ARK_SERVICE_PATH"; then
    log "[OK] LE PARAMÈTRE DE DRAPEAU $params EXISTE DÉJÀ DANS LE SERVICE $SERVER_SERVICE_NAME."
  else
    log "[WARNING] LE PARAMÈTRE DE DRAPEAU $params N'EXISTE PAS DANS LE SERVICE $SERVER_SERVICE_NAME."
    log "[INFO] AJOUT DU PARAMÈTRE DE DRAPEAU $params AU SERVICE $SERVER_SERVICE_NAME..."
    if sudo sed -i "/ExecStart/s|$| -$params|" "$ARK_SERVICE_PATH"; then
      log "[SUCCESS] LE PARAMÈTRE DE DRAPEAU $params A ÉTÉ AJOUTÉ AVEC SUCCÈS AU SERVICE $SERVER_SERVICE_NAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DU PARAMÈTRE DE DRAPEAU $params AU SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE SERVICE $ARK_SERVICE_PATH."
      exit 1
    fi
  fi
}

edit_params() {
  local params="$2"
  local value="$3"

  log "[LOG] MODIFICATION DU SERVICE $SERVER_SERVICE_NAME AVEC LES PARAMÈTRES: $params=$value..."
  log "[INFO] SERVICE AVANT MODIFICATION..."
  log "[INFO] $(grep "$params" "$ARK_SERVICE_PATH")"
  if sudo sed -i "s|\($params=\)[^?]*|\1$value|" "$ARK_SERVICE_PATH"; then
      log "[SUCCESS] MODIFICATION DE $params=$value POUR LE SERVICE $SERVER_SERVICE_NAME RÉUSSIE."
      log "[INFO] SERVICE APRÈS MODIFICATION..."
      grep "$params" "$ARK_SERVICE_PATH"
  else
      log "[ERROR] ERREUR LORS DE LA MODIFICATION DE $params=$value POUR LE SERVICE $SERVER_SERVICE_NAME."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE SERVICE $ARK_SERVICE_PATH."
      exit 1
  fi
}