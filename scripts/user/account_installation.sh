#!/bin/bash
set -euo pipefail

account_installation(){

  user=(
    "user_account_create"
    "user_grant_sudo_permissions"
    "user_sudo_command_no_pwd"
  )

  for install in "${user[@]}"; do
    log "[INFO] CHARGEMENT DU SCRIPT D'INSTALLATION DE L'UTILISATEUR: $install"
    $install
  done
}