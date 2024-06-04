#!/bin/bash
set -euo pipefail

load_config_files() {

  local config_file_path="$1"
  local config_file_name
  config_file_name=$(basename "$config_file_path")

  local config_file_error_msg="[DEBUG] VEUILLEZ VOUS ASSURER QUE LE FICHIER ${config_file_name^^} EST PRÉSENT DANS LE RÉPERTOIRE: $config_file_path"

  if [[ ! -f "$config_file_path" ]]; then
      log "[ERROR] LE FICHIER DE CONFIGURATION ${config_file_name^^} N'EXISTE PAS."
      log "$config_file_error_msg"
      exit 1
  fi

  clear

  log "[WARNING] VÉRIFICATION DU CHARGEMENT DU FICHIER DE CONFIGURATION ${config_file_name^^} EN COURS ..."

  log "[LOG] NETTOYAGE DU FICHIER DE CONFIGURATION ${config_file_name^^} ..."


  if sed -i 's/\r$//' "$config_file_path"; then
    log "[SUCCESS] LE FICHIER DE CONFIGURATION ${config_file_name^^} A ÉTÉ NETTOYÉ AVEC SUCCÈS."
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU NETTOYAGE DU FICHIER DE CONFIGURATION ${config_file_name^^}."
    log "$config_file_error_msg"
    exit 1
  fi

  log "[LOG] CHARGEMENT DU FICHIER DE CONFIGURATION ${config_file_name^^} EN COURS ..."

  # shellcheck source=$config_file_path
  if source "$config_file_path"; then
      log "[SUCCESS] LE FICHIER DE CONFIGURATION ${config_file_name^^} A ÉTÉ CHARGÉ AVEC SUCCÈS."
      sleep 1
  else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU CHARGEMENT DU FICHIER DE CONFIGURATION ${config_file_name^^}."
      log "$config_file_error_msg"
      exit 1
  fi

}