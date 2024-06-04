#!/bin/bash
set -euo pipefail

# Vérifier si les dépendances sont installées
for file in "$(dirname "$0")"/scripts/dependencies/*; do
  # shellcheck source=$file
  source "$file"
done

declare -r GREEN='\033[0;32m'
declare -r YELLOW='\033[0;33m'
declare -r BLUE='\033[1;34m'
declare -r MAGENTA='\033[1;35m'
declare -r GREY='\033[0;37m'
declare -r RESET='\033[0m'
declare -r BOLD='\033[1m'
declare -r BLINK_START="\033[5m"
declare -r BLINK_END="\033[25m"

DEPENDENCIES=("timezone" "sudo" "software properties common" "non free repo" "curl" "jq" "ip tables" "architecture 32 bit" "wine" "Installer toutes les dependances")

declare -A DEPENDENCIES_DESCRIPTIONS=(
  ["timezone"]="Configuration du fuseau horaire du système pour assurer une synchronisation correcte du temps"
  ["sudo"]="Gestionnaire des privilèges super utilisateur, permettant l'exécution de commandes en tant que super utilisateur"
  ["software properties common"]="Outil nécessaire pour gérer les logiciels et les dépôts de logiciels sur votre système"
  ["non free repo"]="Ajout du dépôt non-free pour permettre l'installation de logiciels non libres"
  ["curl"]="Outil pour transférer des données depuis ou vers un serveur, supporte de nombreux protocoles dont HTTP, HTTPS, FTP"
  ["jq"]="Outil pour traiter des données JSON dans la ligne de commande Linux"
  ["ip tables"]="Outil pour configurer les règles de pare-feu dans le noyau Linux"
  ["architecture 32 bit"]="Activation de l'architecture 32 bits pour supporter les applications 32 bits sur un système 64 bits"
  ["wine"]="Outil pour exécuter des applications Windows sur Linux"
  ["Installer toutes les dependances"]="Installer toutes les dépendances nécessaires pour le script"
)

# faire un case pour chaque dépendance et sa commande de vérification
package_exist() {
  case $1 in
    "timezone")
      timedatectl show --property=Timezone --value | grep -q "$SYSTEM_TIMEZONE" && return 0 || return 1
      ;;
    "sudo")
      command -v sudo > /dev/null
      ;;
    "software properties common")
      dpkg -l | grep -qw software-properties-common
      ;;
    "non free repo")
      grep -q "$NON_FREE_REPO" /etc/apt/sources.list
      ;;
    "curl")
      command -v curl > /dev/null
      ;;
    "jq")
      command -v jq > /dev/null
      ;;
    "ip tables")
      command -v iptables > /dev/null
      ;;
    "architecture 32 bit")
      dpkg --print-foreign-architectures | grep -q i386
      ;;
    "wine")
      command -v wine > /dev/null
      ;;
    "Installer toutes les dependances")
      # Pour l'option "all", nous vérifions simplement si toutes les autres dépendances sont installées
      for package in "${DEPENDENCIES[@]}"; do
        if [ "$package" != "all" ] && ! package_exist "$package"; then
          return 1
        fi
      done
      return 0
      ;;
    *)
      echo "Le paquet $1 n'est pas géré par la fonction package_exist."
      exit 1
      ;;
  esac
}

# Fonction pour afficher le statut d'installation des dépendances
dependencies_option() {
  local CROSS_MARK="❌"
  local CHECK_MARK="✅"
  local DEPENDENCIES_NAME="$1"
  local DESCRIPTION="${DEPENDENCIES_DESCRIPTIONS[$DEPENDENCIES_NAME]}"
  local OPTION_NUMBER=1

  # Boucle pour incrémenter le numéro de l'option
  for package in "${DEPENDENCIES[@]}"; do
    if [ "$package" == "$DEPENDENCIES_NAME" ]; then
      break
    fi
    OPTION_NUMBER=$((OPTION_NUMBER + 1))
  done

  # Use package_exist to check if the package is installed
  if package_exist "$DEPENDENCIES_NAME"; then
    text_center "${BOLD}${MAGENTA}[$OPTION_NUMBER] ${RESET}${DEPENDENCIES_NAME^^} ${GREEN}[ INSTALLÉ $CHECK_MARK ]${RESET}\n"
    text_center "${BOLD}${BLUE} [ $DESCRIPTION ]${RESET}\n\n"
  else
    text_center "${BOLD}${MAGENTA}[$OPTION_NUMBER] ${RESET}${DEPENDENCIES_NAME^^} ${YELLOW}[ NON INSTALLÉ ${BLINK_START}$CROSS_MARK${BLINK_END} ]${RESET}\n"
    text_center "${BOLD}${BLUE} [ $DESCRIPTION ]${RESET}\n\n"
  fi
}









text_center() {
     [[ $# == 0 ]] && return 1

     declare -i TERM_COLS
     TERM_COLS="$(tput cols)"
     declare -i str_len
     str_len=$(echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m)
     [[ $str_len -ge $TERM_COLS ]] && {
          echo -e "$1";
          return 0;
     }

     declare -i filler_len_left="$(( (TERM_COLS - str_len) / 2 ))"
     declare -i filler_len_right="$(( TERM_COLS - str_len - filler_len_left ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler_left=""
     filler_right=""
     for (( i = 0; i < filler_len_left; i++ )); do
          filler_left="${filler_left}${ch}"
     done
     for (( i = 0; i < filler_len_right; i++ )); do
          filler_right="${filler_right}${ch}"
     done

     echo -e "${filler_left}$1${filler_right}";

     return 0
}







title(){
  local separator_line
  separator_line=$(printf "\033[1;30m%*s\033[0m\n" "$(tput cols)" '' | tr ' ' "-")

  echo -e "${separator_line}"
  echo
  text_center "${BOLD}${GREY}MENU DE VÉRIFICATION & D'INSTALLATION DES DÉPENDANCES DU SCRIPT POUR LE SERVEUR ARK: SURVIVAL ASCENDED${RESET}"
  echo
  echo -e "${separator_line}\n\n"
}

dependencies_menu(){
  clear
  title
  # Utilisez DEPENDENCIES pour vérifier chaque paquet
  for package in "${DEPENDENCIES[@]}"; do
    dependencies_option "$package"
  done

  echo "Vérification des dépendances terminée."
}









echo



