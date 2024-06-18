#!/bin/bash
set -euo pipefail

update_gus_ini() {
  local params="$1"
  local value="$2"

  log "[LOG] VÉRIFICATION DE LA PRÉSENCE DE $params DANS LE FICHIER $GUS_INI_FILE..."
  if grep -q "$params" "$GUS_INI_PATH"; then
    log "[OK] $params EST DÉJÀ DÉFINI DANS LE FICHIER $GUS_INI_FILE."
  else
    log "[WARNING] $params N'EST PAS DÉFINI DANS LE FICHIER $GUS_INI_FILE."
    log "[LOG] AJOUT DE $params DANS LE FICHIER $GUS_INI_FILE..."
    # Ajout de $params dans le fichier GUS sous [ServerSettings]
    if sudo sed -i "/\[ServerSettings\]/a $params=$value" "$GUS_INI_PATH"; then
      log "[SUCCESS] $params A ÉTÉ AJOUTÉ AVEC SUCCÈS DANS LE FICHIER $GUS_INI_FILE."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE $params DANS LE FICHIER $GUS_INI_FILE."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE FICHIER DE CONFIGURATION $GUS_INI_PATH."
      exit 1
    fi
  fi
}

