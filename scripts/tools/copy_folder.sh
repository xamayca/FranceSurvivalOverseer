#!/bin/bash
set -euo pipefail

copy_folder() {
  local folder_name=$1
  local source_path=$2
  local target_path=$3

  log "[LOG] VÉRIFICATION & COPIE DU DOSSIER $folder_name DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT..."
  if [ -d "$target_path" ]; then
    log "[OK] LE DOSSIER $folder_name EXISTE DÉJÀ DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."
  else
    log "[WARNING] LE DOSSIER $folder_name N'EXISTE PAS DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."
    log "[LOG] COPIE DU DOSSIER $folder_name DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."
    if sudo cp -r "$source_path" "$target_path"; then
      log "[SUCCESS] COPIE DU DOSSIER $folder_name RÉUSSIE DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA COPIE DU DOSSIER $folder_name DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."
      log "[DEBUG] VEUILLEZ COPIER LE DOSSIER $folder_name DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT À L'AIDE DE LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo cp -r $source_path $target_path"
      exit 1
    fi
  fi
}