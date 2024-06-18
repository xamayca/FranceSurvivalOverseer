#!/bin/bash
set -euo pipefail

check_variables(){
  VAR_NAME=$1
  CHECK_TYPE=$2
  ERROR_MSG=$3
  EXAMPLE=$4

  log "[LOG] VÉRIFICATION & VALIDATION DE LA VARIABLE DE CONFIGURATION $VAR_NAME..."
  VAR_VALUE=$(eval echo \$"$VAR_NAME")

  # Z: Verifie si la variable est vide
  if [ "$CHECK_TYPE" = "z" ] && [ -z "$VAR_VALUE" ]; then
    log "[ERROR] $ERROR_MSG"
    log "[DEBUG] EXEMPLE D'UTILISATION DE LA VARIABLE $VAR_NAME: $EXAMPLE"
    exit 1
  # F: Verifie si le fichier existe
  elif [ "$CHECK_TYPE" = "f" ] && [ ! -f "$VAR_VALUE" ]; then
    log "[ERROR] $ERROR_MSG"
    log "[DEBUG] EXEMPLE D'UTILISATION DE LA VARIABLE $VAR_NAME: $EXAMPLE"
    exit 1
  # D: Verifie si le dossier existe
  elif [ "$CHECK_TYPE" = "d" ] && [ ! -d "$VAR_VALUE" ]; then
    log "[ERROR] $ERROR_MSG"
    log "[DEBUG] EXEMPLE D'UTILISATION DE LA VARIABLE $VAR_NAME: $EXAMPLE"
    exit 1
  # N: Verifie si la variable est vide
  elif [ "$CHECK_TYPE" = "n" ] && [ -n "$VAR_VALUE" ]; then
    log "[ERROR] $ERROR_MSG"
    log "[DEBUG] EXEMPLE D'UTILISATION DE LA VARIABLE $VAR_NAME: $EXAMPLE"
    exit 1
  else
    log "[SUCCESS] LA VARIABLE DE CONFIGURATION $VAR_NAME EST DÉFINIE CORRECTEMENT."
  fi
}