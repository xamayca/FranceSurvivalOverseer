#!/bin/bash
set -euo pipefail

dependencies_installation(){

  dependencies=(
    "install_timezone"
    "install_32_bit_arch"
    "install_sudo"
    "install_curl"
    "install_jq"
    "install_spc"
    "install_wine_hq"
    "install_non_free_repo"
    "install_locale_en_utf8"
    "install_nfs_common"
  )

  for install in "${dependencies[@]}"; do
    log "[INFO] CHARGEMENT DU SCRIPT D'INSTALLATION DE LA DÉPENDANCE: $install"
    $install
  done
}