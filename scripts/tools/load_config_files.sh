#!/bin/bash
set -euo pipefail

clean_config_file() {
  local file_path="$1"
  # Remove all carriage return characters, spaces and empty lines from the configuration file
  # Retire tous les caractères de retour chariot, les espaces et les lignes vides du fichier de configuration
  if sed -i 's/\r$//; /^$/d; s/[[:space:]]*$//' "$file_path"; then
    return 0
  else
    return 1
  fi
}

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

  if clean_config_file "$config_file_path"; then
    log "[SUCCESS] LE FICHIER DE CONFIGURATION ${config_file_name^^} A ÉTÉ NETTOYÉ AVEC SUCCÈS."
    sleep 1
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